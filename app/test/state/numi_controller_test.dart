import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/companion_message.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/data/models/bukti_skill.dart';
import 'package:numi/data/repositories/numi_repository.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/state/numi_controller.dart';

class RepositoryMemori implements NumiRepository {
  DataBelajar? tersimpan;
  int jumlahSimpan = 0;
  bool gagalSimpan = false;
  Completer<void>? tungguSimpan;

  @override
  Future<DataBelajar> muat() async => tersimpan ?? const DataBelajar();

  @override
  Future<void> simpan(DataBelajar data) async {
    await tungguSimpan?.future;
    if (gagalSimpan) throw StateError('Penyimpanan tidak tersedia');
    tersimpan = data;
    jumlahSimpan++;
  }

  @override
  Future<void> hapus() async => tersimpan = null;
}

void main() {
  late RepositoryMemori repo;
  late ProviderContainer container;
  var sekarang = DateTime(2026, 9, 26, 9);

  setUp(() {
    repo = RepositoryMemori();
    sekarang = DateTime(2026, 9, 26, 9);
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        jamProvider.overrideWithValue(() => sekarang),
      ],
    );
  });

  tearDown(() => container.dispose());

  NumiController controller() =>
      container.read(numiControllerProvider.notifier);
  DataBelajar data() => container.read(numiControllerProvider);

  test('gagal simpan tidak menerbitkan profil dan dapat dicoba lagi', () async {
    repo.gagalSimpan = true;
    await expectLater(
      controller().daftar(nama: 'Sari', kelas: 2),
      throwsStateError,
    );
    expect(data().sudahDaftar, isFalse);
    expect(repo.tersimpan, isNull);
    repo.gagalSimpan = false;
    await controller().daftar(nama: 'Sari', kelas: 2);
    expect(data().sudahDaftar, isTrue);
  });

  test(
    'profil belum dianggap tersimpan ketika repository masih menunggu',
    () async {
      repo.tungguSimpan = Completer<void>();
      final simpan = controller().daftar(nama: 'Sari', kelas: 2);
      expect(data().sudahDaftar, isFalse);
      repo.tungguSimpan!.complete();
      await simpan;
      expect(data().sudahDaftar, isTrue);
    },
  );

  Future<void> daftarDanDiagnostic() async {
    await controller().daftar(nama: 'Adi Pratama', kelas: 1);
    final mulai = await controller().mulaiDiagnostic();
    while (!data().sesiDiagnostic!.lengkap) {
      final blok = data().sesiDiagnostic!.blok.last;
      final i = blok.jawaban.length;
      final soal = blok.soal[i];
      final isi = soal.topikId == 'T01'
          ? soal.jawabanBenar
          : soal.pilihan.firstWhere((p) => p != soal.jawabanBenar);
      await controller().jawabDiagnostic(
        mulai.id,
        blok.commandId(i),
        Jawaban(
          soalId: soal.id,
          topikId: soal.topikId,
          jawaban: isi,
          benar: soal.periksa(isi),
          waktu: sekarang,
          konteks: KonteksJawaban.diagnostic,
          skillId: soal.skillId,
          versiButir: soal.versi,
        ),
      );
    }
    await controller().finalisasiDiagnostic(mulai.id);
  }

  Future<RingkasanSesi> selesaikanLesson(int benar, Duration durasi) async {
    final lesson = lessonUntuk('T02').first;
    final soal = [
      for (var i = 0; i < 5; i++)
        Soal(
          id: 'lesson-$i',
          topikId: 'T02',
          jenis: JenisSoal.pilihanGanda,
          pertanyaan: 'Soal $i',
          pilihan: ['x', 'y'],
          jawabanBenar: 'x',
          penjelasan: 'Contoh',
        ),
    ];
    final sesi = await controller().mulaiSesiLesson(lesson, soal);
    for (var i = 0; i < 5; i++) {
      await controller().jawabLesson(
        lesson.id,
        sesi.id,
        sesi.commandId(i),
        Jawaban(
          soalId: soal[i].id,
          topikId: 'T02',
          jawaban: i < benar ? 'x' : 'y',
          benar: i < benar,
          waktu: sekarang.add(durasi),
          konteks: KonteksJawaban.lesson,
          versiButir: soal[i].versi,
        ),
      );
      await controller().lanjutLesson(
        lesson.id,
        sesi.id,
        '${sesi.id}/lanjut/$i',
      );
    }
    return controller().finalisasiLesson(lesson.id, sesi.id);
  }

  test(
    'pendaftaran dan diagnostic tersimpan, dan topik berprasyarat T01 terbuka',
    () async {
      await daftarDanDiagnostic();
      expect(data().siswa!.namaPanggilan, 'Adi');
      expect(data().siswa!.kelompokKelas, KelompokKelas.faseA);
      expect(
        data().statusTopik('T03'),
        StatusTopik.belumDiuji,
        reason: 'prasyarat T03 hanya T01',
      );
      expect(data().statusTopik('T04'), StatusTopik.terkunci);
      expect(repo.tersimpan!.diagnosticSelesai, isTrue);
    },
  );

  test(
    'lesson lulus memberi XP, menandai selesai, dan membuka lencana',
    () async {
      await daftarDanDiagnostic();
      final lesson = lessonUntuk('T02').first;
      expect(data().statusTopik('T02'), StatusTopik.perluLatihan);

      final r = await selesaikanLesson(5, const Duration(seconds: 90));
      expect(r.lulus, isTrue);
      expect(r.xpDidapat, 70);
      expect(data().xp, 70);
      expect(data().lessonSelesai(lesson.id), isTrue);
      expect(
        r.lencanaBaru.map((l) => l.id),
        containsAll(['pemula', 'teliti', 'cepat']),
      );
      expect(r.pesan.trigger, JenisTrigger.badgeBaru);
    },
  );

  test(
    'lesson dengan benar kurang dari minimum tidak dianggap selesai',
    () async {
      await daftarDanDiagnostic();
      final lesson = lessonUntuk('T02').first;
      final r = await selesaikanLesson(2, const Duration(minutes: 3));
      expect(r.lulus, isFalse);
      expect(data().lessonSelesai(lesson.id), isFalse);
      expect(r.pesan.trigger, JenisTrigger.lessonGagal);
    },
  );

  test(
    'maskot menyapa sekali sehari dan mengingatkan saat streak terancam',
    () async {
      await daftarDanDiagnostic();
      expect(
        (await controller().periksaPesanMaskot())!.trigger,
        JenisTrigger.sambutan,
      );
      expect(
        await controller().periksaPesanMaskot(),
        isNull,
        reason: 'tidak muncul dua kali sehari',
      );

      sekarang = DateTime(2026, 9, 27, 18);
      expect(
        (await controller().periksaPesanMaskot())!.trigger,
        JenisTrigger.streakTerancam,
      );

      sekarang = DateTime(2026, 10, 2, 18);
      expect(
        (await controller().periksaPesanMaskot())!.trigger,
        JenisTrigger.lamaTidakAktif,
      );
    },
  );

  test('data disimpan setiap aktivitas selesai', () async {
    await daftarDanDiagnostic();
    expect(repo.tersimpan!.toJson(), data().toJson());
    await controller().mulaiUlang();
    expect(data().sudahDaftar, isFalse);
    expect(repo.tersimpan, isNull);
  });

  test('lesson memberi XP tanpa mengubah bukti kemampuan', () async {
    await daftarDanDiagnostic();
    final sebelum = data().buktiSkill;
    await selesaikanLesson(5, const Duration(minutes: 2));
    expect(data().xp, 70);
    expect(data().buktiSkill, sebelum);
    expect(data().buktiSkill['T01']!.status, StatusBukti.indikasiSiap);
    expect(data().jumlahBuktiAwal, 0);
  });

  test('kelas dan nama tidak sah ditolak sebelum menyimpan', () async {
    for (final kelas in [0, 7]) {
      await expectLater(
        controller().daftar(nama: 'Sari', kelas: kelas),
        throwsRangeError,
      );
    }
    await expectLater(
      controller().daftar(nama: '   ', kelas: 1),
      throwsArgumentError,
    );
    await expectLater(
      controller().daftar(nama: 'a' * 31, kelas: 1),
      throwsArgumentError,
    );
    expect(repo.jumlahSimpan, 0);
  });

  test('ubah kelas menjaga ID dan seluruh riwayat, gagal simpan menjaga kelas lama', () async {
    await daftarDanDiagnostic();
    final sebelum = data();
    await controller().ubahProfil(nama: ' Adi ', kelas: 6);
    expect(data().siswa!.id, sebelum.siswa!.id);
    expect(data().siswa!.kelas, 6);
    expect(data().siswa!.kelompokKelas, KelompokKelas.faseC);
    expect(data().hasilDiagnostic, sebelum.hasilDiagnostic);
    expect(data().riwayatJawaban, sebelum.riwayatJawaban);
    expect(data().skillMap, sebelum.skillMap);
    repo.gagalSimpan = true;
    await expectLater(
      controller().ubahProfil(nama: 'Adi', kelas: 3),
      throwsStateError,
    );
    expect(data().siswa!.kelas, 6);
  });
}
