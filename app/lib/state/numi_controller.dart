import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/content/daftar_topik.dart';
import '../data/content/daftar_lesson.dart';
import '../data/models/checkpoint_diagnostic.dart';
import '../data/models/badge.dart';
import '../data/models/bukti_skill.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/companion_message.dart';
import '../data/models/data_belajar.dart';
import '../data/models/lesson.dart';
import '../data/models/siswa.dart';
import '../data/models/sesi_mastery.dart';
import '../data/models/soal.dart';
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

  Map<String, dynamic> toJson() => {
    'benar': benar,
    'total': total,
    'lulus': lulus,
    'xpDidapat': xpDidapat,
    'levelSebelum': levelSebelum,
    'levelSesudah': levelSesudah,
    'lencanaBaru': lencanaBaru
        .map(
          (l) => {
            'id': l.id,
            'nama': l.nama,
            'ikon': l.ikon,
            'syarat': l.syarat,
          },
        )
        .toList(),
    'pesan': pesan.toJson(),
  };

  factory RingkasanSesi.fromJson(Map<String, dynamic> j) => RingkasanSesi(
    benar: j['benar'] as int,
    total: j['total'] as int,
    lulus: j['lulus'] as bool,
    xpDidapat: j['xpDidapat'] as int,
    levelSebelum: j['levelSebelum'] as int,
    levelSesudah: j['levelSesudah'] as int,
    lencanaBaru: (j['lencanaBaru'] as List)
        .map(
          (l) => Lencana(
            id: l['id'] as String,
            nama: l['nama'] as String,
            ikon: l['ikon'] as String,
            syarat: l['syarat'] as String,
          ),
        )
        .toList(),
    pesan: CompanionMessage.fromJson(
      Map<String, dynamic>.from(j['pesan'] as Map),
    ),
  );
}

class NumiController extends Notifier<DataBelajar> {
  NumiRepository get _repo => ref.read(repositoryProvider);
  SkillMapService get _skill => ref.read(skillMapServiceProvider);
  ProgressService get _progress => ref.read(progressServiceProvider);
  CompanionService get _companion => ref.read(companionServiceProvider);
  DateTime get _sekarang => ref.read(jamProvider)();
  Future<void> _antreanSesi = Future.value();

  Future<T> _antrekan<T>(Future<T> Function() aksi) {
    final hasil = _antreanSesi.then((_) {
      if (!ref.mounted) throw StateError('Sesi profil sudah ditutup.');
      return aksi();
    });
    _antreanSesi = hasil.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return hasil;
  }

  Future<SesiMastery> mulaiMastery(String topikId, List<Soal> soal) =>
      _antrekan(() async {
        final lama = state.sesiMastery[topikId];
        if (lama != null && !lama.selesai) return lama;
        if (!ref.read(learningPathProvider).siapMastery(topikId, state) ||
            state.statusTopik(topikId) == StatusTopik.terkunci ||
            state.statusTopik(topikId) == StatusTopik.belumTersedia) {
          throw StateError('Selesaikan lesson sebelum mulai mastery.');
        }
        final id =
            '${state.siswa!.id}/mastery/$topikId/'
            '${_sekarang.microsecondsSinceEpoch}';
        if (id == lama?.id) throw StateError('Identitas sesi harus baru.');
        final sesi = SesiMastery(id: id, topikId: topikId, soal: soal);
        await _perbarui(
          state.copyWith(sesiMastery: {...state.sesiMastery, topikId: sesi}),
        );
        return sesi;
      });

  SesiMastery _sesi(String topikId, String id) {
    final sesi = state.sesiMastery[topikId];
    if (sesi == null || sesi.id != id) {
      throw StateError('Sesi tidak ditemukan.');
    }
    return sesi;
  }

  Future<void> jawabMastery(
    String topikId,
    String id,
    String commandId,
    Jawaban jawaban,
  ) => _antrekan(() async {
    final sesi = _sesi(topikId, id);
    final baru = sesi.catat(commandId, jawaban);
    if (identical(sesi, baru)) return;
    await _perbarui(
      state.copyWith(sesiMastery: {...state.sesiMastery, topikId: baru}),
    );
  });

  Future<RingkasanSesi> finalisasiMastery(String topikId, String id) =>
      _antrekan(() async {
        final sesi = _sesi(topikId, id);
        if (sesi.hasil case final hasil?) return RingkasanSesi.fromJson(hasil);
        if (!sesi.lengkap) throw StateError('Blok mastery belum lengkap.');
        return _nilaiMastery(sesi);
      });

  Future<CheckpointDiagnostic> mulaiDiagnostic() => _antrekan(() async {
    final lama = state.sesiDiagnostic;
    if (lama != null) return lama;
    final siswa = state.siswa;
    if (siswa?.kelas == null) {
      throw StateError('Konfirmasi kelas terlebih dahulu.');
    }
    final sesi = CheckpointDiagnostic.mulai(
      '${siswa!.id}/diagnostic/${_sekarang.microsecondsSinceEpoch}',
      siswa.kelas!,
    );
    await _perbarui(state.copyWith(sesiDiagnostic: sesi));
    return sesi;
  });

  CheckpointDiagnostic _diagnostic(String id) {
    final sesi = state.sesiDiagnostic;
    if (sesi == null || sesi.id != id) {
      throw StateError('Sesi diagnostic sudah berubah.');
    }
    return sesi;
  }

  Future<void> jawabDiagnostic(String id, String command, Jawaban j) =>
      _antrekan(() async {
        final sesi = _diagnostic(id);
        final baru = sesi.catat(command, j);
        if (!identical(sesi, baru)) {
          await _perbarui(state.copyWith(sesiDiagnostic: baru));
        }
      });

  Future<HasilAkhirDiagnostic> finalisasiDiagnostic(String id) =>
      _antrekan(() async {
        final sesi = _diagnostic(id);
        final hasil = sesi.hasilAkhir();
        if (!sesi.ditutup) await _simpanDiagnostic(hasil, sesi.jawaban, sesi);
        return hasil;
      });

  Future<SesiSoal> mulaiSesiLesson(
    Lesson lesson,
    List<Soal> soal,
  ) => _antrekan(() async {
    final lama = state.sesiLesson[lesson.id];
    if (lama != null && !lama.selesai) return lama;
    final daftar = lessonUntuk(lesson.topikId);
    final indeks = daftar.indexWhere((l) => l.id == lesson.id);
    final status = state.statusTopik(lesson.topikId);
    if (indeks < 0 ||
        status == StatusTopik.terkunci ||
        status == StatusTopik.belumTersedia ||
        (indeks > 0 && !state.lessonSelesai(daftar[indeks - 1].id))) {
      throw StateError('Lesson belum dapat dibuka.');
    }
    final waktu = _sekarang;
    final sesi = SesiSoal(
      id: '${state.siswa!.id}/lesson/${lesson.id}/${waktu.microsecondsSinceEpoch}',
      topikId: lesson.topikId,
      soal: soal,
      konteks: KonteksJawaban.lesson,
      lessonId: lesson.id,
      mulaiPada: waktu,
    );
    if (sesi.id == lama?.id) throw StateError('Identitas sesi harus baru.');
    await _perbarui(
      state.copyWith(sesiLesson: {...state.sesiLesson, lesson.id: sesi}),
    );
    return sesi;
  });

  SesiSoal _lesson(String lessonId, String id) {
    final sesi = state.sesiLesson[lessonId];
    if (sesi == null || sesi.id != id) {
      throw StateError('Sesi lesson sudah berubah.');
    }
    return sesi;
  }

  Future<void> jawabLesson(
    String lessonId,
    String id,
    String command,
    Jawaban j,
  ) => _antrekan(() async {
    final sesi = _lesson(lessonId, id);
    final baru = sesi.catat(command, j);
    if (!identical(sesi, baru)) {
      await _perbarui(
        state.copyWith(sesiLesson: {...state.sesiLesson, lessonId: baru}),
      );
    }
  });

  Future<void> lanjutLesson(String lessonId, String id, String command) =>
      _antrekan(() async {
        final sesi = _lesson(lessonId, id);
        final baru = sesi.lanjut(command);
        if (!identical(sesi, baru)) {
          await _perbarui(
            state.copyWith(sesiLesson: {...state.sesiLesson, lessonId: baru}),
          );
        }
      });

  Future<RingkasanSesi> finalisasiLesson(String lessonId, String id) =>
      _antrekan(() async {
        final sesi = _lesson(lessonId, id);
        if (sesi.hasil case final hasil?) return RingkasanSesi.fromJson(hasil);
        if (!sesi.lengkap || sesi.menungguLanjut) {
          throw StateError('Lesson belum lengkap.');
        }
        final lesson = lessonUntuk(sesi.topikId)
            .firstWhere((l) => l.id == lessonId);
        return _nilaiLesson(lesson, sesi);
      });

  @override
  DataBelajar build() => ref.read(dataAwalProvider);

  Future<void> _perbarui(DataBelajar data) async {
    await _repo.simpan(data);
    if (ref.mounted) state = data;
  }

  /// UC-008: siswa atau orang tua mengisi profil.
  Future<void> daftar({required String nama, required int kelas}) =>
      _antrekan(() async {
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
      });

  void _validasiProfil(String nama, int kelas) {
    if (nama.trim().isEmpty || nama.trim().length > 30) {
      throw ArgumentError('Nama panggilan harus berisi 1 sampai 30 karakter.');
    }
    KelompokKelas.dariKelas(kelas);
  }

  /// Mengonfirmasi kelas data lama dan memperbarui profil tanpa reset riwayat.
  Future<void> ubahProfil({required String nama, required int kelas}) =>
      _antrekan(() async {
        _validasiProfil(nama, kelas);
        final siswa = state.siswa;
        if (siswa == null) throw StateError('Profil belum dibuat.');
        await _perbarui(
          state.copyWith(
            siswa: siswa.copyWith(nama: nama.trim(), kelas: kelas),
          ),
        );
      });

  /// UC-001: menyimpan hasil diagnostic dan menyusun skill map awal.
  Future<void> _simpanDiagnostic(
    HasilAkhirDiagnostic hasil,
    List<Jawaban> jawaban,
    CheckpointDiagnostic sesi,
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
        sumberSesi: sesi.id,
      );
      if (b.benar != h.benar) {
        throw ArgumentError('Ringkasan diagnostic tidak sesuai respons.');
      }
      bukti[h.topikId] = b;
    }
    final data = state.copyWith(
      sesiDiagnostic: sesi.tutup(),
      hasilDiagnostic: hasil.hasilPerTopik,
      buktiSkill: bukti,
      aksesMateri: _skill.susunAkses(bukti),
      riwayatJawaban: _tambahRiwayat(jawaban),
      streakLog: _progress.catatAktivitas(state.streakLog, waktu),
    );
    await _perbarui(data);
  }

  /// UC-003 dan UC-004: menyimpan hasil lesson, XP, streak, dan lencana.
  Future<RingkasanSesi> _nilaiLesson(Lesson lesson, SesiSoal sesi) async {
    final jawaban = sesi.jawaban;
    final selisih = jawaban.last.waktu.difference(sesi.mulaiPada!);
    final durasi = selisih.isNegative ? null : selisih;
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
      sesiLesson: sesi,
    );
  }

  /// Hanya finalisasi checkpoint lengkap yang boleh menerbitkan bukti/reward.
  Future<RingkasanSesi> _nilaiMastery(SesiMastery sesi) async {
    final topikId = sesi.topikId;
    final jawaban = sesi.jawaban;
    final waktu = _sekarang;
    final benar = jawaban.where((j) => j.benar).length;
    final skor = jawaban.isEmpty ? 0 : (benar * 100 / jawaban.length).round();
    final baru = _buatBukti(
      topikId,
      jawaban,
      AppConfig.soalMastery,
      KonteksJawaban.mastery,
      sumberSesi: sesi.id,
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
      sesi: sesi,
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
    SesiMastery? sesi,
    SesiSoal? sesiLesson,
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

    final ringkasan = RingkasanSesi(
      benar: benar,
      total: total,
      lulus: lulus,
      xpDidapat: xp,
      levelSebelum: levelSebelum,
      levelSesudah: levelSesudah,
      lencanaBaru: lencana,
      pesan: pesan,
    );
    await _perbarui(
      data.copyWith(
        sesiLesson: sesiLesson == null
            ? null
            : {
                ...data.sesiLesson,
                sesiLesson.lessonId!: sesiLesson.tutup(ringkasan.toJson()),
              },
        sesiMastery: sesi == null
            ? null
            : {
                ...data.sesiMastery,
                sesi.topikId: sesi.tutup(ringkasan.toJson()),
              },
        lencana: [
          ...data.lencana,
          for (final l in lencana)
            SiswaLencana(badgeId: l.id, waktuDiperoleh: waktu),
        ],
        pesanMaskot: _tambahPesan(pesan),
      ),
    );

    return ringkasan;
  }

  /// UC-007: dipanggil saat halaman utama dibuka.
  Future<CompanionMessage?> periksaPesanMaskot() => _antrekan(() async {
    final pesan = _companion.periksaSaatMembuka(state, _sekarang);
    if (pesan == null) return null;
    await _perbarui(state.copyWith(pesanMaskot: _tambahPesan(pesan)));
    return pesan;
  });

  Future<void> tandaiPesanDibaca(String id) => _antrekan(() async {
    await _perbarui(
      state.copyWith(
        pesanMaskot: [
          for (final p in state.pesanMaskot) p.id == id ? p.tandaiDibaca() : p,
        ],
      ),
    );
  });

  Future<void> mulaiUlang() => _antrekan(() async {
    final repo = _repo;
    await repo.hapus();
    if (!ref.mounted) return;
    final data = await repo.muat();
    if (ref.mounted) state = data;
  });

  BuktiSkill _buatBukti(
    String topikId,
    List<Jawaban> jawaban,
    int total,
    KonteksJawaban konteks, {
    String? sumberSesi,
  }) {
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
          sumberSesi ??
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
