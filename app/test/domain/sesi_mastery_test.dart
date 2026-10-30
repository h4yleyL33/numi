import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/data/models/soal.dart';

void main() {
  test('seluruh bentuk soal tetap sama setelah snapshot JSON', () {
    final semua = [
      for (var i = 1; i <= 12; i++)
        ...GeneratorSoal().buat(
          'T${i.toString().padLeft(2, '0')}',
          15,
          tingkat: 2,
        ),
    ];
    expect(semua.map((s) => s.jenis).toSet(), containsAll(JenisSoal.values));
    for (final s in semua) {
      expect(
        Soal.fromJson(jsonDecode(jsonEncode(s.toJson()))).toJson(),
        s.toJson(),
      );
    }
  });

  test('blok/identitas/konteks palsu dan respons di luar urutan ditolak', () {
    final soal = GeneratorSoal().buat('T02', 5);
    expect(
      () => SesiMastery(id: 'a', topikId: 'T02', soal: soal.take(4).toList()),
      throwsFormatException,
    );
    expect(
      () => SesiMastery(
        id: 'a',
        topikId: 'T02',
        soal: [for (var i = 0; i < 5; i++) soal.first],
      ),
      throwsFormatException,
    );
    final sesi = SesiMastery(id: 'a', topikId: 'T02', soal: soal);
    Jawaban j(
      int i, {
      bool? benar,
      KonteksJawaban konteks = KonteksJawaban.mastery,
    }) => Jawaban(
      soalId: soal[i].id,
      topikId: 'T02',
      jawaban: soal[i].jawabanBenar,
      benar: benar ?? true,
      waktu: DateTime(2026),
      konteks: konteks,
      versiButir: soal[i].versi,
    );
    expect(
      () => sesi.catat(sesi.commandId(0), j(0, konteks: KonteksJawaban.lesson)),
      throwsFormatException,
    );
    expect(
      () => sesi.catat(sesi.commandId(0), j(0, benar: false)),
      throwsFormatException,
    );
    expect(() => sesi.catat(sesi.commandId(1), j(1)), throwsStateError);
    final rusak = sesi.toJson()..['versiKebijakan'] = 'tidak-dikenal';
    expect(() => SesiMastery.fromJson(rusak), throwsFormatException);
  });
  test(
    'snapshot pulih persis dan command retry tidak mengganti respons pertama',
    () {
      final sesi = SesiMastery(
        id: 'sesi-a',
        topikId: 'T02',
        soal: GeneratorSoal().buat('T02', 5),
      );
      final s = sesi.soal.first;
      Jawaban respons(String isi) => Jawaban(
        soalId: s.id,
        topikId: s.topikId,
        skillId: s.skillId,
        versiButir: s.versi,
        jawaban: isi,
        benar: s.periksa(isi),
        waktu: DateTime(2026),
        konteks: KonteksJawaban.mastery,
      );
      final simpan = sesi.catat(sesi.commandId(0), respons(s.jawabanBenar));
      final pulih = SesiMastery.fromJson(
        jsonDecode(jsonEncode(simpan.toJson())),
      );
      expect(
        pulih.soal.map((s) => s.toJson()),
        sesi.soal.map((s) => s.toJson()),
      );
      expect(pulih.jawaban.length, 1);
      expect(
        pulih.catat(sesi.commandId(0), respons(s.jawabanBenar)),
        same(pulih),
      );
      final salah = s.pilihan.firstWhere((p) => p != s.jawabanBenar);
      expect(
        () => pulih.catat(sesi.commandId(0), respons(salah)),
        throwsStateError,
      );
      expect(
        () => pulih.catat('command-lain', respons(s.jawabanBenar)),
        throwsStateError,
      );
      expect(() => sesi.tutup({}), throwsFormatException);
    },
  );
}
