import 'dart:math';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/soal.dart';

void main() {
  final generator = GeneratorSoal(Random(42));

  test(
    'mastery berbeda dari lesson dan paket sebelumnya, termasuk ID acak',
    () {
      String isi(Soal s) => jsonEncode(
        s.toJson()
          ..remove('id')
          ..remove('pilihan')
          ..remove('penjelasan')
          ..remove('versi')
          ..remove('tingkat')
          ..remove('statusValidasi'),
      );
      for (final topik in daftarTopik) {
        final acak = GeneratorSoal(Random(42));
        var sebelumnya = <Soal>[];
        for (var i = 0; i < 100; i++) {
          final lesson = [
            ...acak.buat(topik.id, 5, tingkat: 1),
            ...acak.buat(topik.id, 5, tingkat: 2),
          ];
          final hindari = [...lesson, ...sebelumnya];
          final mastery = acak.buat(
            topik.id,
            5,
            tingkat: 2,
            hindariButir: hindari,
          );
          expect(mastery, hasLength(5), reason: '${topik.id}/$i');
          expect(mastery.map(isi).toSet(), hasLength(5));
          expect(
            mastery.map(isi).toSet().intersection(hindari.map(isi).toSet()),
            isEmpty,
            reason: '${topik.id}/$i',
          );
          sebelumnya = mastery;
        }
      }
    },
  );

  for (final topik in daftarTopik) {
    group('${topik.id} ${topik.nama}', () {
      for (final tingkat in [1, 2]) {
        test('200 soal tingkat $tingkat selalu bisa dijawab', () {
          for (var ulang = 0; ulang < 40; ulang++) {
            final daftar = generator.buat(topik.id, 5, tingkat: tingkat);
            expect(daftar, hasLength(5));
            expect(
              daftar.map((s) => s.id).toSet(),
              hasLength(5),
              reason: 'soal dalam satu sesi tidak boleh kembar',
            );

            for (final s in daftar) {
              expect(s.topikId, topik.id);
              expect(s.kompetensiId, '${topik.id}-jangkar');
              expect(s.statusValidasi, 'PENDING_EDUCATOR_REVIEW');
              expect(s.tingkat, tingkat);
              expect(
                s.pilihan.toSet(),
                hasLength(s.pilihan.length),
                reason: 'pilihan kembar di ${s.id}',
              );

              switch (s.jenis) {
                case JenisSoal.pasangkan:
                  expect(s.pasangan, hasLength(3));
                  expect(
                    s.jawabanBenar,
                    s.pasangan.map((p) => p.kanan).join('|'),
                  );
                  expect(
                    s.pilihan.toSet(),
                    s.pasangan.map((p) => p.kanan).toSet(),
                  );
                case JenisSoal.bandingkan:
                  expect(s.pilihan, ['<', '=', '>']);
                  expect(s.kalimat, contains('☐'));
                  expect(s.pilihan, contains(s.jawabanBenar));
                default:
                  expect(s.pilihan, hasLength(4), reason: s.id);
                  expect(s.pilihan, contains(s.jawabanBenar), reason: s.id);
              }

              // Soal SD tidak boleh memunculkan bilangan negatif.
              for (final p in s.pilihan) {
                expect(
                  p.startsWith('-'),
                  isFalse,
                  reason: '${s.id} punya pilihan negatif $p',
                );
              }
              if (s.jenis == JenisSoal.seretKeKotak) {
                expect(s.kalimat, contains('☐'));
              }
              if (s.jenis == JenisSoal.hitungBenda) {
                expect(s.jumlahBenda, greaterThan(0));
              }
              if (s.jenis == JenisSoal.pecahanGambar) {
                expect(s.gambarPecahan, isNotNull);
              }
              expect(s.penjelasan, isNotEmpty);
            }
          }
        });
      }
    });
  }

  test('T04 tidak pernah menghasilkan pengurangan dengan hasil negatif', () {
    for (var i = 0; i < 300; i++) {
      for (final s in generator.buat('T04', 5, tingkat: 2)) {
        expect(int.tryParse(s.jawabanBenar) ?? 0, greaterThanOrEqualTo(0));
      }
    }
  });

  test('format pasangan lama tetap dapat dipulihkan', () {
    final pasangan = PasanganSoal.fromJson(['2 + 3', '5']);
    expect(pasangan.toJson(), {'kiri': '2 + 3', 'kanan': '5'});
    expect(PasanganSoal.fromJson(pasangan.toJson()).kanan, '5');
  });

  test('T05 hanya memakai pecahan setengah dan seperempat sesuai Fase A', () {
    for (var i = 0; i < 200; i++) {
      for (final s in generator.buat('T05', 5)) {
        if (s.gambarPecahan != null) {
          expect(s.gambarPecahan!.penyebut, anyOf(2, 4));
        }
      }
    }
  });
}
