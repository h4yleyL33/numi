import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/features/quiz/pemutar_soal.dart';
import 'package:numi/features/quiz/tampilan_soal.dart';

void main() {
  testWidgets(
    'pembahasan pulih menampilkan respons pertama dan tetap terkunci',
    (tester) async {
      const soal = Soal(
        id: 'banding-9-17',
        topikId: 'T01',
        jenis: JenisSoal.bandingkan,
        pertanyaan: 'Pilih tanda yang tepat.',
        kalimat: '9 ☐ 17',
        jawabanBenar: '<',
        penjelasan: '9 lebih kecil dari 17.',
        pilihan: ['<', '=', '>'],
      );
      final respons = Jawaban(
        soalId: soal.id,
        topikId: soal.topikId,
        jawaban: '<',
        benar: true,
        waktu: DateTime(2026, 11, 18),
        konteks: KonteksJawaban.lesson,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PemutarSoal(
              soal: const [soal],
              konteks: KonteksJawaban.lesson,
              jawabanAwal: [respons],
              menungguLanjut: true,
              onSelesai: (_) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final tampilan = tester.widget<TampilanSoal>(find.byType(TampilanSoal));
      expect(tampilan.pilihanAwal, '<');
      expect(tampilan.terkunci, isTrue);
      expect(find.text('?'), findsNothing);
      expect(find.text('Lanjut'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
