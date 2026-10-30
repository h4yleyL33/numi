import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/bukti_skill.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/state/numi_controller.dart';

import 'numi_controller_test.dart' show RepositoryMemori;

final soalCheckpoint = [
  for (var i = 0; i < 5; i++)
    Soal(
      id: 'soal-$i',
      topikId: 'T01',
      jenis: JenisSoal.pilihanGanda,
      pertanyaan: 'Soal nomor $i',
      jawabanBenar: '2',
      pilihan: ['2', '3'],
      penjelasan: 'Pembahasan $i',
      versi: 'uji-v1',
    ),
];

DataBelajar profilSiap() => DataBelajar(
  siswa: Siswa(
    id: 'anak-a',
    waliUid: 'wali-a',
    nama: 'Sari',
    kelas: 1,
    dibuatPada: DateTime(2026),
  ),
  skillMap: {
    'T01': SkillMap(
      topikId: 'T01',
      status: StatusTopik.belumDiuji,
      diperbarui: DateTime(2026),
    ),
  },
  progresLesson: {
    for (final l in lessonUntuk('T01'))
      l.id: LessonProgress(
        lessonId: l.id,
        topikId: l.topikId,
        selesai: true,
        skorTerbaik: 100,
        jumlahPercobaan: 1,
        waktu: DateTime(2026),
      ),
  },
);

Jawaban jawabCheckpoint(Soal s, {String isi = '2', int bantuan = 0}) => Jawaban(
  soalId: s.id,
  topikId: s.topikId,
  skillId: s.skillId,
  versiButir: s.versi,
  jawaban: isi,
  benar: s.periksa(isi),
  waktu: DateTime(2026),
  konteks: KonteksJawaban.mastery,
  bantuan: bantuan,
);

void main() {
  late RepositoryMemori repo;
  late ProviderContainer container;
  void buka(DataBelajar awal) {
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        dataAwalProvider.overrideWithValue(awal),
      ],
    );
  }

  NumiController kontrol() => container.read(numiControllerProvider.notifier);
  DataBelajar data() => container.read(numiControllerProvider);
  setUp(() {
    repo = RepositoryMemori();
    buka(profilSiap());
  });
  tearDown(() => container.dispose());

  test('gagal/tertunda menahan cursor; retry dan restart mempertahankan respons pertama', () async {
    final sesi = await kontrol().mulaiMastery('T01', soalCheckpoint);
    repo.tungguSimpan = Completer<void>();
    final simpan = kontrol().jawabMastery(
      'T01',
      sesi.id,
      sesi.commandId(0),
      jawabCheckpoint(sesi.soal.first),
    );
    await Future<void>.delayed(Duration.zero);
    expect(data().sesiMastery['T01']!.jawaban, isEmpty);
    repo.tungguSimpan!.complete();
    await simpan;
    final jumlah = repo.jumlahSimpan;
    await kontrol().jawabMastery(
      'T01',
      sesi.id,
      sesi.commandId(0),
      jawabCheckpoint(sesi.soal.first),
    );
    expect(repo.jumlahSimpan, jumlah);
    await expectLater(
      kontrol().jawabMastery(
        'T01',
        sesi.id,
        sesi.commandId(0),
        jawabCheckpoint(sesi.soal.first, isi: '3'),
      ),
      throwsStateError,
    );
    repo.gagalSimpan = true;
    await expectLater(
      kontrol().jawabMastery(
        'T01',
        sesi.id,
        sesi.commandId(1),
        jawabCheckpoint(sesi.soal[1]),
      ),
      throwsStateError,
    );
    expect(data().sesiMastery['T01']!.jawaban.length, 1);
    repo.gagalSimpan = false;
    await kontrol().jawabMastery(
      'T01',
      sesi.id,
      sesi.commandId(1),
      jawabCheckpoint(sesi.soal[1]),
    );
    final pulih = DataBelajar.fromJson(
      jsonDecode(jsonEncode(repo.tersimpan!.toJson())),
    );
    container.dispose();
    buka(pulih);
    final lanjut = await kontrol().mulaiMastery(
      'T01',
      soalCheckpoint.reversed.toList(),
    );
    expect(lanjut.id, sesi.id);
    expect(lanjut.soal.map((s) => s.id), sesi.soal.map((s) => s.id));
    expect(lanjut.jawaban.length, 2);
    expect(data().xp, 0);
  });

  test(
    'commit hasil+XP atomik dan finalisasi ganda tetap sekali setelah restart',
    () async {
      final sesi = await kontrol().mulaiMastery('T01', soalCheckpoint);
      await expectLater(
        kontrol().finalisasiMastery('T01', sesi.id),
        throwsStateError,
      );
      for (var i = 0; i < 5; i++) {
        await kontrol().jawabMastery(
          'T01',
          sesi.id,
          sesi.commandId(i),
          jawabCheckpoint(sesi.soal[i]),
        );
      }
      repo.gagalSimpan = true;
      await expectLater(
        kontrol().finalisasiMastery('T01', sesi.id),
        throwsStateError,
      );
      expect(data().xp, 0);
      expect(data().sesiMastery['T01']!.selesai, isFalse);
      expect(data().hasilMastery, isEmpty);
      repo.gagalSimpan = false;
      final hasil = await Future.wait([
        kontrol().finalisasiMastery('T01', sesi.id),
        kontrol().finalisasiMastery('T01', sesi.id),
      ]);
      expect(hasil.first.toJson(), hasil.last.toJson());
      expect(data().xp, hasil.first.xpDidapat);
      expect(data().hasilMastery.length, 1);
      expect(data().hasilMastery.single.skor, 100);
      expect(data().statusTopik('T01'), StatusTopik.mastered);
      expect(data().riwayatJawaban.length, 5);
      expect(data().buktiSkill['T01']!.sumberSesi, sesi.id);
      final pulih = DataBelajar.fromJson(
        jsonDecode(jsonEncode(repo.tersimpan!.toJson())),
      );
      container.dispose();
      buka(pulih);
      final jumlah = repo.jumlahSimpan;
      expect(
        (await kontrol().finalisasiMastery('T01', sesi.id)).toJson(),
        hasil.first.toJson(),
      );
      expect(repo.jumlahSimpan, jumlah);
      expect(data().xp, hasil.first.xpDidapat);
      final baru = await kontrol().mulaiMastery('T01', soalCheckpoint);
      expect(baru.id, isNot(sesi.id));
      await expectLater(
        kontrol().finalisasiMastery('T01', sesi.id),
        throwsStateError,
      );
    },
  );

  test('operasi profil bersamaan tidak menghapus checkpoint', () async {
    final sesi = await kontrol().mulaiMastery('T01', soalCheckpoint);
    await Future.wait([
      kontrol().ubahProfil(nama: 'Sari Baru', kelas: 2),
      kontrol().jawabMastery(
        'T01',
        sesi.id,
        sesi.commandId(0),
        jawabCheckpoint(sesi.soal[0]),
      ),
    ]);
    expect(data().sesiMastery['T01']!.jawaban.length, 1);
    expect(data().siswa!.nama, 'Sari Baru');
  });

  for (final bantuan in [0, 1]) {
    test(
      '4 benar atau 5 benar berbantuan tidak memberi bukti mandiri ($bantuan)',
      () async {
        final sesi = await kontrol().mulaiMastery('T01', soalCheckpoint);
        for (var i = 0; i < 5; i++) {
          await kontrol().jawabMastery(
            'T01',
            sesi.id,
            sesi.commandId(i),
            jawabCheckpoint(
              sesi.soal[i],
              isi: bantuan == 0 && i == 4 ? '3' : '2',
              bantuan: i == 0 ? bantuan : 0,
            ),
          );
        }
        final hasil = await kontrol().finalisasiMastery('T01', sesi.id);
        expect(hasil.lulus, isFalse);
        expect(data().jumlahBuktiAwal, 0);
        expect(data().buktiSkill['T01']!.status, StatusBukti.indikasiLatihan);
        expect(data().buktiSkill['T01']!.bantuan, bantuan);
      },
    );
  }
}
