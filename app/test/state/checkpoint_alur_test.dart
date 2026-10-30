import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/state/numi_controller.dart';

import 'checkpoint_mastery_test.dart' show soalCheckpoint, profilSiap;
import 'numi_controller_test.dart' show RepositoryMemori;

class _KonfirmasiTerputus extends RepositoryMemori {
  bool putus = false;
  @override
  Future<void> simpan(DataBelajar data) async {
    await super.simpan(data);
    if (putus) {
      putus = false;
      throw StateError('Konfirmasi terputus setelah commit');
    }
  }
}

Jawaban responsSoal(Soal s, KonteksJawaban konteks, {bool benar = true}) {
  final isi = benar
      ? s.jawabanBenar
      : s.pilihan.firstWhere((p) => p != s.jawabanBenar);
  return Jawaban(
    soalId: s.id,
    topikId: s.topikId,
    jawaban: isi,
    benar: s.periksa(isi),
    waktu: DateTime.now(),
    konteks: konteks,
    skillId: s.skillId,
    versiButir: s.versi,
  );
}

void main() {
  late RepositoryMemori repo;
  late ProviderContainer container;
  void buka(DataBelajar awal) => container = ProviderContainer(
    overrides: [
      repositoryProvider.overrideWithValue(repo),
      dataAwalProvider.overrideWithValue(awal),
    ],
  );
  NumiController kontrol() => container.read(numiControllerProvider.notifier);
  DataBelajar data() => container.read(numiControllerProvider);
  void restart() {
    final awal = DataBelajar.fromJson(
      jsonDecode(jsonEncode(repo.tersimpan!.toJson())),
    );
    container.dispose();
    buka(awal);
  }

  setUp(() {
    repo = RepositoryMemori();
    buka(profilSiap().copyWith(progresLesson: {}));
  });
  tearDown(() => container.dispose());

  test('commit lesson berhasil tetapi konfirmasi hilang: restart memakai receipt tanpa XP ganda', () async {
    container.dispose();
    repo = _KonfirmasiTerputus();
    buka(profilSiap());
    final lesson = lessonUntuk('T01').first;
    final sesi = await kontrol().mulaiSesiLesson(lesson, soalCheckpoint);
    for (var i = 0; i < 5; i++) {
      await kontrol().jawabLesson(
        lesson.id,
        sesi.id,
        sesi.commandId(i),
        responsSoal(sesi.soal[i], KonteksJawaban.lesson),
      );
      await kontrol().lanjutLesson(lesson.id, sesi.id, '${sesi.id}/lanjut/$i');
    }
    (repo as _KonfirmasiTerputus).putus = true;
    await expectLater(
      kontrol().finalisasiLesson(lesson.id, sesi.id),
      throwsStateError,
    );
    expect(data().xp, 0);
    expect(repo.tersimpan!.xp, 70);
    restart();
    final jumlah = repo.jumlahSimpan;
    await kontrol().finalisasiLesson(lesson.id, sesi.id);
    expect(data().xp, 70);
    expect(repo.jumlahSimpan, jumlah);
  });

  test('batas blok diagnostic: gagal tidak memajukan rute, retry/restart menjaga blok berikutnya', () async {
    final sesi = await kontrol().mulaiDiagnostic();
    final b = sesi.blok.first;
    await kontrol().jawabDiagnostic(
      sesi.id,
      b.commandId(0),
      responsSoal(b.soal[0], b.konteks),
    );
    final j = responsSoal(b.soal[1], b.konteks);
    repo.gagalSimpan = true;
    await expectLater(
      kontrol().jawabDiagnostic(sesi.id, b.commandId(1), j),
      throwsStateError,
    );
    expect(data().sesiDiagnostic!.blok.length, 1);
    expect(data().sesiDiagnostic!.jawaban.length, 1);
    repo.gagalSimpan = false;
    await kontrol().jawabDiagnostic(sesi.id, b.commandId(1), j);
    final snapshot = data().sesiDiagnostic!.toJson();
    restart();
    expect((await kontrol().mulaiDiagnostic()).toJson(), snapshot);
    final jumlah = repo.jumlahSimpan;
    await kontrol().jawabDiagnostic(sesi.id, b.commandId(1), j);
    expect(repo.jumlahSimpan, jumlah);
    expect(data().sesiDiagnostic!.blok.length, 2);
  });

  test('hasil diagnostic/referensi sesi hanya sekali; kelas profil berubah tidak mengganti titik awal sesi', () async {
    final sesi = await kontrol().mulaiDiagnostic();
    final b = sesi.blok.first;
    for (var i = 0; i < 2; i++) {
      await kontrol().jawabDiagnostic(
        sesi.id,
        b.commandId(i),
        responsSoal(b.soal[i], b.konteks, benar: false),
      );
    }
    await kontrol().ubahProfil(nama: 'Sari', kelas: 6);
    repo.gagalSimpan = true;
    await expectLater(
      kontrol().finalisasiDiagnostic(sesi.id),
      throwsStateError,
    );
    expect(data().hasilDiagnostic, isEmpty);
    expect(data().sesiDiagnostic!.ditutup, isFalse);
    repo.gagalSimpan = false;
    final hasil = await Future.wait([
      kontrol().finalisasiDiagnostic(sesi.id),
      kontrol().finalisasiDiagnostic(sesi.id),
    ]);
    expect(hasil.first.kelas, 1);
    expect(data().siswa!.kelas, 6);
    expect(data().riwayatJawaban.length, 2);
    expect(data().streakLog.single.jumlahAktivitas, 1);
    expect(data().xp, 0);
    expect(data().buktiSkill['T01']!.sumberSesi, sesi.id);
    restart();
    final jumlah = repo.jumlahSimpan;
    await kontrol().finalisasiDiagnostic(sesi.id);
    expect(repo.jumlahSimpan, jumlah);
  });

  test('lesson menahan pembahasan saat Lanjut gagal dan memulihkannya sesudah restart', () async {
    final lesson = lessonUntuk('T01').first;
    final sesi = await kontrol().mulaiSesiLesson(lesson, soalCheckpoint);
    final j = responsSoal(sesi.soal[0], KonteksJawaban.lesson);
    await kontrol().jawabLesson(lesson.id, sesi.id, sesi.commandId(0), j);
    repo.gagalSimpan = true;
    await expectLater(
      kontrol().lanjutLesson(lesson.id, sesi.id, '${sesi.id}/lanjut/0'),
      throwsStateError,
    );
    expect(data().sesiLesson[lesson.id]!.menungguLanjut, isTrue);
    repo.gagalSimpan = false;
    restart();
    final pulih = await kontrol().mulaiSesiLesson(
      lesson,
      soalCheckpoint.reversed.toList(),
    );
    expect(pulih.jawaban.single.toJson(), j.toJson());
    expect(pulih.menungguLanjut, isTrue);
    await kontrol().lanjutLesson(lesson.id, sesi.id, '${sesi.id}/lanjut/0');
    final jumlah = repo.jumlahSimpan;
    await kontrol().lanjutLesson(lesson.id, sesi.id, '${sesi.id}/lanjut/0');
    expect(repo.jumlahSimpan, jumlah);
    expect(data().sesiLesson[lesson.id]!.menungguLanjut, isFalse);
    expect(data().xp, 0);
  });

  test('lesson finalisasi gagal/retry/ganda tidak menggandakan XP, percobaan, riwayat atau bukti', () async {
    final lesson = lessonUntuk('T01').first;
    final sesi = await kontrol().mulaiSesiLesson(lesson, soalCheckpoint);
    final bukti = data().buktiSkill;
    for (var i = 0; i < 5; i++) {
      await kontrol().jawabLesson(
        lesson.id,
        sesi.id,
        sesi.commandId(i),
        responsSoal(sesi.soal[i], KonteksJawaban.lesson),
      );
      if (i == 4) {
        await expectLater(
          kontrol().finalisasiLesson(lesson.id, sesi.id),
          throwsStateError,
        );
      }
      await kontrol().lanjutLesson(lesson.id, sesi.id, '${sesi.id}/lanjut/$i');
    }
    repo.gagalSimpan = true;
    await expectLater(
      kontrol().finalisasiLesson(lesson.id, sesi.id),
      throwsStateError,
    );
    expect(data().xp, 0);
    expect(data().progresLesson, isEmpty);
    repo.gagalSimpan = false;
    final hasil = await Future.wait([
      kontrol().finalisasiLesson(lesson.id, sesi.id),
      kontrol().finalisasiLesson(lesson.id, sesi.id),
    ]);
    expect(hasil.first.toJson(), hasil.last.toJson());
    expect(data().xp, 70);
    expect(data().riwayatJawaban.length, 5);
    expect(data().progresLesson[lesson.id]!.jumlahPercobaan, 1);
    expect(data().buktiSkill, bukti);
    restart();
    final jumlah = repo.jumlahSimpan;
    expect(
      (await kontrol().finalisasiLesson(lesson.id, sesi.id)).toJson(),
      hasil.first.toJson(),
    );
    expect(repo.jumlahSimpan, jumlah);
  });
}
