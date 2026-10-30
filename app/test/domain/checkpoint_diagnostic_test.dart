import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/models/checkpoint_diagnostic.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_soal.dart';

Jawaban jawabDiagnostic(SesiSoal b, int i, {bool benar = true}) {
  final s = b.soal[i];
  return Jawaban(
    soalId: s.id,
    topikId: s.topikId,
    jawaban: benar
        ? s.jawabanBenar
        : s.pilihan.firstWhere((p) => p != s.jawabanBenar),
    benar: benar,
    waktu: DateTime(2026),
    konteks: KonteksJawaban.diagnostic,
    skillId: s.skillId,
    versiButir: s.versi,
  );
}

void main() {
  for (final kelas in [1, 2, 3, 4, 5, 6]) {
    for (final benar in [true, false]) {
      test(
        'rute kelas $kelas ($benar) pulih tiap respons tanpa mengganti blok',
        () {
          var sesi = CheckpointDiagnostic.mulai('diagnostic-a', kelas);
          while (!sesi.lengkap) {
            final b = sesi.blok.last;
            final i = b.jawaban.length;
            sesi = sesi.catat(
              b.commandId(i),
              jawabDiagnostic(b, i, benar: benar),
            );
            final snapshot = sesi.toJson();
            sesi = CheckpointDiagnostic.fromJson(
              jsonDecode(jsonEncode(snapshot)),
            );
            expect(sesi.toJson(), snapshot);
            expect(sesi.jawaban.length, lessThanOrEqualTo(12));
          }
          expect(sesi.hasilAkhir().kelas, kelas);
          expect(sesi.hasilAkhir().hasilPerTopik.length, sesi.blok.length);
          expect(sesi.tutup().ditutup, isTrue);
        },
      );
    }
  }
  test('jawaban batas blok idempoten dan snapshot rute palsu ditolak', () {
    var sesi = CheckpointDiagnostic.mulai('a', 1);
    final b = sesi.blok.first;
    sesi = sesi.catat(b.commandId(0), jawabDiagnostic(b, 0));
    final j = jawabDiagnostic(b, 1);
    sesi = sesi.catat(b.commandId(1), j);
    expect(sesi.blok.length, 2);
    expect(sesi.catat(b.commandId(1), j), same(sesi));
    expect(() => sesi.tutup(), throwsFormatException);
    expect(
      () => CheckpointDiagnostic(id: 'a', kelas: 6, blok: sesi.blok),
      throwsFormatException,
    );
  });
}
