import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_soal.dart';
import 'package:numi/data/models/data_belajar.dart';

import '../state/checkpoint_mastery_test.dart' show soalCheckpoint;

void main() {
  test(
    'checkpoint mastery versi 4 tetap terbaca saat metadata lesson belum ada',
    () {
      final lama =
          SesiSoal(
              id: 'mastery-lama',
              topikId: 'T01',
              soal: soalCheckpoint,
            ).toJson()
            ..remove('konteks')
            ..remove('lessonId')
            ..remove('mulaiPada')
            ..remove('menungguLanjut');
      final data = DataBelajar.fromJson({
        'versi': 4,
        'xp': 42,
        'sesiMastery': [lama],
      });
      expect(data.xp, 42);
      expect(data.sesiMastery['T01']!.id, 'mastery-lama');
      expect(data.sesiMastery['T01']!.konteks, KonteksJawaban.mastery);
      expect(data.sesiLesson, isEmpty);
      expect(data.sesiDiagnostic, isNull);
    },
  );
  test('lesson memulihkan pembahasan dan Lanjut idempoten sebelum respons berikutnya', () {
    final sesi = SesiSoal(
      id: 'lesson-a',
      topikId: 'T01',
      soal: soalCheckpoint,
      konteks: KonteksJawaban.lesson,
      lessonId: 'T01-kenalan',
      mulaiPada: DateTime(2026),
    );
    Jawaban jawab(int i) => Jawaban(
      soalId: sesi.soal[i].id,
      topikId: 'T01',
      jawaban: '2',
      benar: true,
      waktu: DateTime(2026),
      konteks: KonteksJawaban.lesson,
      versiButir: sesi.soal[i].versi,
    );
    final pertama = sesi.catat(sesi.commandId(0), jawab(0));
    final pulih = SesiSoal.fromJson(jsonDecode(jsonEncode(pertama.toJson())));
    expect(pulih.menungguLanjut, isTrue);
    expect(() => pulih.catat(sesi.commandId(1), jawab(1)), throwsStateError);
    final lanjut = pulih.lanjut('${sesi.id}/lanjut/0');
    expect(lanjut.menungguLanjut, isFalse);
    expect(lanjut.lanjut('${sesi.id}/lanjut/0'), same(lanjut));
    expect(lanjut.catat(sesi.commandId(1), jawab(1)).jawaban.length, 2);
    expect(() => pulih.tutup({}), throwsFormatException);
  });
}
