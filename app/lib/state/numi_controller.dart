import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/content/daftar_topik.dart';
import '../data/models/badge.dart';
import '../data/models/bukti_skill.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/companion_message.dart';
import '../data/models/data_belajar.dart';
import '../data/models/lesson.dart';
import '../data/models/siswa.dart';
import '../data/repositories/numi_repository.dart';
import '../domain/companion_service.dart';
import '../domain/diagnostic_engine.dart';
import '../domain/learning_path_service.dart';
import '../domain/progress_service.dart';
import '../domain/skill_map_service.dart';

/// Diisi di main.dart dengan repository yang sudah siap.
final repositoryProvider = Provider<NumiRepository>(
  (ref) => throw UnimplementedError(
    'repositoryProvider harus di-override di main.dart',
  ),
);

/// Data yang sudah dimuat dari repository sebelum aplikasi tampil.
final dataAwalProvider = Provider<DataBelajar>((ref) => const DataBelajar());

/// Sumber waktu. Diganti di pengujian supaya streak bisa diuji per tanggal.
final jamProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final learningPathProvider = Provider(
  (ref) => LearningPathService(daftarTopik),
);
final skillMapServiceProvider = Provider((ref) => SkillMapService(daftarTopik));
final progressServiceProvider = Provider((ref) => const ProgressService());
final companionServiceProvider = Provider((ref) => CompanionService());

final numiControllerProvider = NotifierProvider<NumiController, DataBelajar>(
  NumiController.new,
);

/// Ringkasan yang ditampilkan di akhir lesson atau mastery test.
class RingkasanSesi {
  const RingkasanSesi({
    required this.benar,
    required this.total,
    required this.lulus,
    required this.xpDidapat,
    required this.levelSebelum,
    required this.levelSesudah,
    required this.lencanaBaru,
    required this.pesan,
  });

  final int benar;
  final int total;
  final bool lulus;
  final int xpDidapat;
  final int levelSebelum;
  final int levelSesudah;
  final List<Lencana> lencanaBaru;
  final CompanionMessage pesan;

  int get skor => total == 0 ? 0 : (benar * 100 / total).round();
  bool get levelNaik => levelSesudah > levelSebelum;
}

class NumiController extends Notifier<DataBelajar> {
  NumiRepository get _repo => ref.read(repositoryProvider);
  SkillMapService get _skill => ref.read(skillMapServiceProvider);
  ProgressService get _progress => ref.read(progressServiceProvider);
  CompanionService get _companion => ref.read(companionServiceProvider);
  DateTime get _sekarang => ref.read(jamProvider)();

  @override
  DataBelajar build() => ref.read(dataAwalProvider);

  Future<void> _perbarui(DataBelajar data) async {
    await _repo.simpan(data);
    if (ref.mounted) state = data;
  }

  /// UC-008: siswa atau orang tua mengisi profil.
  Future<void> daftar({required String nama, required int kelas}) async {
    _validasiProfil(nama, kelas);
    if (state.sudahDaftar) {
      throw StateError('Profil sudah ada. Gunakan ubahProfil.');
    }
    final waktu = _sekarang;
    final siswa = Siswa(
      id: 'siswa-${waktu.microsecondsSinceEpoch}',
      nama: nama.trim(),
      kelas: kelas,
      dibuatPada: waktu,
    );
    await _perbarui(DataBelajar(siswa: siswa));
  }

  void _validasiProfil(String nama, int kelas) {
    if (nama.trim().isEmpty || nama.trim().length > 30) {
      throw ArgumentError('Nama panggilan harus berisi 1 sampai 30 karakter.');
    }
    KelompokKelas.dariKelas(kelas);
  }

  /// Mengonfirmasi kelas data lama dan memperbarui profil tanpa reset riwayat.
  Future<void> ubahProfil({required String nama, required int kelas}) async {
    _validasiProfil(nama, kelas);
    final siswa = state.siswa;
    if (siswa == null) throw StateError('Profil belum dibuat.');
    await _perbarui(
      state.copyWith(
        siswa: siswa.copyWith(nama: nama.trim(), kelas: kelas),
      ),
    );
  }

  /// UC-001: menyimpan hasil diagnostic dan menyusun skill map awal.
  Future<void> simpanDiagnostic(
    HasilAkhirDiagnostic hasil,
    List<Jawaban> jawaban,
  ) async {
    final waktu = _sekarang;
    if (hasil.hasilPerTopik.isEmpty ||
        hasil.hasilPerTopik.map((h) => h.topikId).toSet().length !=
            hasil.hasilPerTopik.length ||
        jawaban.map((j) => j.soalId).toSet().length != jawaban.length ||
        jawaban.length >
            AppConfig.maksTopikDiagnostic * AppConfig.soalDiagnosticPerTopik ||
        jawaban.length !=
            hasil.hasilPerTopik.fold<int>(0, (n, h) => n + h.total)) {
      throw ArgumentError('Blok diagnostic tidak lengkap.');
    }
    final bukti = {...state.buktiSkill};
    for (final h in hasil.hasilPerTopik) {
      final respons = jawaban.where((j) => j.topikId == h.topikId).toList();
      final b = _buatBukti(
        h.topikId,
        respons,
        AppConfig.soalDiagnosticPerTopik,
        KonteksJawaban.diagnostic,
      );
      if (b.benar != h.benar) {
        throw ArgumentError('Ringkasan diagnostic tidak sesuai respons.');
      }
      bukti[h.topikId] = b;
    }
    final data = state.copyWith(
      hasilDiagnostic: hasil.hasilPerTopik,
      buktiSkill: bukti,
      aksesMateri: _skill.susunAkses(bukti),
      riwayatJawaban: _tambahRiwayat(jawaban),
      streakLog: _progress.catatAktivitas(state.streakLog, waktu),
    );
    await _perbarui(data);
  }

  /// Memulai lesson tidak menghasilkan bukti kemampuan.
  Future<void> mulaiLesson(String topikId) async {
    final status = state.statusTopik(topikId);
    if (status == StatusTopik.terkunci || status == StatusTopik.belumTersedia) {
      throw StateError('Materi belum dapat dibuka.');
    }
  }

  /// UC-003 dan UC-004: menyimpan hasil lesson, XP, streak, dan lencana.
  Future<RingkasanSesi> selesaiLesson(
    Lesson lesson,
    List<Jawaban> jawaban,
    Duration durasi,
  ) async {
    final waktu = _sekarang;
    final benar = jawaban.where((j) => j.benar).length;
    final lulus = benar >= AppConfig.minBenarLesson;
    final skor = jawaban.isEmpty ? 0 : (benar * 100 / jawaban.length).round();
    final lama = state.progresLesson[lesson.id];

    final progres = LessonProgress(
      lessonId: lesson.id,
      topikId: lesson.topikId,
      selesai: (lama?.selesai ?? false) || lulus,
      skorTerbaik: lama == null || skor > lama.skorTerbaik
          ? skor
          : lama.skorTerbaik,
      jumlahPercobaan: (lama?.jumlahPercobaan ?? 0) + 1,
      waktu: waktu,
    );
    final xp =
        benar * AppConfig.xpPerBenar + (lulus ? AppConfig.xpLessonSelesai : 0);

    final data = state.copyWith(
      progresLesson: {...state.progresLesson, lesson.id: progres},
      riwayatJawaban: _tambahRiwayat(jawaban),
      streakLog: _progress.catatAktivitas(state.streakLog, waktu),
      xp: state.xp + xp,
    );
    return _tutupSesi(
      data,
      benar: benar,
      total: jawaban.length,
      lulus: lulus,
      xp: xp,
      kejadian: KejadianSesi(
        lessonSelesai: lulus,
        sempurna: benar == jawaban.length,
        durasi: durasi,
      ),
      triggerLulus: JenisTrigger.lessonSelesai,
      triggerGagal: JenisTrigger.lessonGagal,
    );
  }

  /// UC-005: menilai mastery test dan memperbarui skill map.
  Future<RingkasanSesi> selesaiMastery(
    String topikId,
    List<Jawaban> jawaban,
  ) async {
    final waktu = _sekarang;
    final benar = jawaban.where((j) => j.benar).length;
    final skor = jawaban.isEmpty ? 0 : (benar * 100 / jawaban.length).round();
    final baru = _buatBukti(
      topikId,
      jawaban,
      AppConfig.soalMastery,
      KonteksJawaban.mastery,
    );
    final lulus = baru.status == StatusBukti.buktiAwal;
    final bukti = {...state.buktiSkill, topikId: baru};
    final xp =
        benar * AppConfig.xpPerBenar + (lulus ? AppConfig.xpMasteryLulus : 0);

    final data = state.copyWith(
      buktiSkill: bukti,
      aksesMateri: _skill.susunAkses(bukti),
      hasilMastery: [
        ...state.hasilMastery,
        MasteryResult(topikId: topikId, skor: skor, lulus: lulus, waktu: waktu),
      ],
      riwayatJawaban: _tambahRiwayat(jawaban),
      streakLog: _progress.catatAktivitas(state.streakLog, waktu),
      xp: state.xp + xp,
    );
    return _tutupSesi(
      data,
      benar: benar,
      total: jawaban.length,
      lulus: lulus,
      xp: xp,
      kejadian: const KejadianSesi(),
      triggerLulus: JenisTrigger.masteryLulus,
      triggerGagal: JenisTrigger.masteryGagal,
    );
  }

  Future<RingkasanSesi> _tutupSesi(
    DataBelajar data, {
    required int benar,
    required int total,
    required bool lulus,
    required int xp,
    required KejadianSesi kejadian,
    required JenisTrigger triggerLulus,
    required JenisTrigger triggerGagal,
  }) async {
    final waktu = _sekarang;
    final lencana = _progress.lencanaBaru(data, waktu, kejadian);
    final levelSebelum = _progress.level(state.xp);
    final levelSesudah = _progress.level(data.xp);

    final JenisTrigger trigger;
    if (lencana.isNotEmpty) {
      trigger = JenisTrigger.badgeBaru;
    } else if (levelSesudah > levelSebelum) {
      trigger = JenisTrigger.levelNaik;
    } else {
      trigger = lulus ? triggerLulus : triggerGagal;
    }
    final pesan = _companion
        .buat(trigger, data.siswa!.namaPanggilan, waktu)
        .tandaiDibaca();

    await _perbarui(
      data.copyWith(
        lencana: [
          ...data.lencana,
          for (final l in lencana)
            SiswaLencana(badgeId: l.id, waktuDiperoleh: waktu),
        ],
        pesanMaskot: _tambahPesan(pesan),
      ),
    );

    return RingkasanSesi(
      benar: benar,
      total: total,
      lulus: lulus,
      xpDidapat: xp,
      levelSebelum: levelSebelum,
      levelSesudah: levelSesudah,
      lencanaBaru: lencana,
      pesan: pesan,
    );
  }

  /// UC-007: dipanggil saat halaman utama dibuka.
  Future<CompanionMessage?> periksaPesanMaskot() async {
    final pesan = _companion.periksaSaatMembuka(state, _sekarang);
    if (pesan == null) return null;
    await _perbarui(state.copyWith(pesanMaskot: _tambahPesan(pesan)));
    return pesan;
  }

  Future<void> tandaiPesanDibaca(String id) async {
    await _perbarui(
      state.copyWith(
        pesanMaskot: [
          for (final p in state.pesanMaskot) p.id == id ? p.tandaiDibaca() : p,
        ],
      ),
    );
  }

  Future<void> mulaiUlang() async {
    final repo = _repo;
    await repo.hapus();
    if (!ref.mounted) return;
    final data = await repo.muat();
    if (ref.mounted) state = data;
  }

  BuktiSkill _buatBukti(
    String topikId,
    List<Jawaban> jawaban,
    int total,
    KonteksJawaban konteks,
  ) {
    if (!daftarTopik.any((t) => t.id == topikId) ||
        jawaban.length != total ||
        jawaban.any(
          (j) => j.topikId != topikId || j.konteks != konteks || j.bantuan < 0,
        ) ||
        jawaban.map((j) => j.soalId).toSet().length != total) {
      throw ArgumentError('Respons pertama atau jumlah butir tidak sah.');
    }
    final benar = jawaban.where((j) => j.benar).length;
    final bantuan = jawaban.fold<int>(0, (n, j) => n + j.bantuan);
    final mandiri =
        bantuan == 0 &&
        jawaban.every(
          (j) =>
              j.versiButir.trim().isNotEmpty &&
              j.versiButir != 'legacy-tanpa-versi',
        );
    final status = konteks == KonteksJawaban.mastery
        ? (benar == total && mandiri
              ? StatusBukti.buktiAwal
              : StatusBukti.indikasiLatihan)
        : (benar == total && bantuan == 0
              ? StatusBukti.indikasiSiap
              : StatusBukti.indikasiLatihan);
    final skill = jawaban.map((j) => j.skillId).toSet();
    return BuktiSkill(
      topikId: topikId,
      skillId: skill.length == 1
          ? skill.single ?? '$topikId-sampel'
          : '$topikId-sampel',
      status: status,
      benar: benar,
      total: total,
      bantuan: bantuan,
      sumberSesi:
          '${konteks.name}-${_sekarang.microsecondsSinceEpoch}-$topikId',
      waktu: jawaban.last.waktu,
      versiKebijakan: 'numi-pilot-v1',
      versiButir: jawaban.map((j) => j.versiButir).toSet().toList(),
    );
  }

  List<Jawaban> _tambahRiwayat(List<Jawaban> baru) {
    final semua = [...state.riwayatJawaban, ...baru];
    final lebih = semua.length - AppConfig.maksRiwayatJawaban;
    return lebih > 0 ? semua.sublist(lebih) : semua;
  }

  List<CompanionMessage> _tambahPesan(CompanionMessage pesan) {
    final semua = [...state.pesanMaskot, pesan];
    return semua.length > 50 ? semua.sublist(semua.length - 50) : semua;
  }
}
