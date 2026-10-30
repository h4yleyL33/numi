import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/features/feedback/banner_umpan_balik.dart';
import 'package:numi/features/quiz/pemutar_soal.dart';

const soal = Soal(
  id: 'satu',
  topikId: 'T01',
  jenis: JenisSoal.pilihanGanda,
  pertanyaan: 'Berapa hasilnya?',
  kalimat: '1 + 1 = ?',
  pilihan: ['2', '3'],
  jawabanBenar: '2',
  penjelasan: 'Satu dan satu menjadi dua.',
);

void main() {
  for (final konteks in KonteksJawaban.values) {
    testWidgets('$konteks memakai waktu pembahasan yang sesuai', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(420, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var selesai = 0;
      List<Jawaban>? hasil;
      await tester.pumpWidget(
        MaterialApp(
          theme: NumiTema.terang,
          home: Scaffold(
            body: PemutarSoal(
              soal: const [soal],
              konteks: konteks,
              onSelesai: (jawaban) {
                selesai++;
                hasil = jawaban;
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Cek Jawaban'), findsNothing);
      expect(find.text('Kirim'), findsNothing);
      await tester.tap(find.text('3'));
      await tester.pump();
      final label = konteks == KonteksJawaban.lesson ? 'Cek Jawaban' : 'Kirim';
      await tester.tap(find.text(label));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      if (konteks == KonteksJawaban.lesson) {
        expect(find.byType(BannerUmpanBalik), findsOneWidget);
        expect(selesai, 0);
        await tester.tap(find.text('Lanjut'));
        await tester.pump();
      } else {
        expect(find.byType(BannerUmpanBalik), findsNothing);
        // Layar pemanggil dapat menunggu penyimpanan; kiriman ulang harus diabaikan.
        await tester.tap(find.text('Kirim'));
        await tester.pump();
      }
      expect(selesai, 1);
      expect(hasil, hasLength(1));
      expect(hasil!.single.jawaban, '3');
      expect(hasil!.single.benar, isFalse);
    });
  }
}
