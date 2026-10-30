import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/app.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/features/home/home_shell.dart';
import 'package:numi/features/quiz/pemutar_soal.dart';
import 'package:numi/state/numi_controller.dart';

import '../state/numi_controller_test.dart' show RepositoryMemori;

const _soal = Soal(
  id: 'responsive',
  topikId: 't01',
  jenis: JenisSoal.pilihanGanda,
  pertanyaan: 'Berapa hasilnya?',
  kalimat: '8 + 5 = ?',
  pilihan: ['11', '12', '13', '14'],
  jawabanBenar: '13',
  penjelasan:
      'Gabungkan delapan benda dengan lima benda. Jumlahnya tiga belas.',
);

void main() {
  for (final ukuran in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 768),
    const Size(1440, 900),
  ]) {
    testWidgets('profil dan navigasi dapat dipakai pada $ukuran', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(ukuran);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repo = RepositoryMemori();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [repositoryProvider.overrideWithValue(repo)],
          child: const NumiApp(),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);
      for (final label in ['Lanjut', 'Lanjut', 'Aku mau membantu!']) {
        await tester.tap(find.text(label));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
      }
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Sari');
      await tester.ensureVisible(find.text('Kelas 2'));
      await tester.tap(find.text('Kelas 2'));
      await tester.pump();
      await tester.tap(find.text('Mulai Petualangan'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(repo.tersimpan!.siswa!.kelas, 2);
      expect(find.text('Membaca Peta'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'soal, feedback, dan navigasi utama tidak terpotong pada $ukuran',
      (tester) async {
        await tester.binding.setSurfaceSize(ukuran);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var selesai = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: NumiTema.terang,
            home: Scaffold(
              body: SafeArea(
                child: PemutarSoal(
                  soal: const [_soal],
                  konteks: KonteksJawaban.lesson,
                  onSelesai: (_) => selesai = true,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 700));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.ensureVisible(find.text('11'));
        await tester.pump();
        await tester.tap(find.text('11'));
        await tester.pump();
        await tester.tap(find.text('Cek Jawaban'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Lanjut'));
        await tester.pump();
        await tester.tap(find.text('Lanjut'));
        await tester.pump();
        expect(selesai, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(theme: NumiTema.terang, home: const HomeShell()),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(
          ukuran.width >= 700
              ? find.byType(NavigationRail)
              : find.byType(NavigationBar),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('soal landscape tetap terbaca dengan pembesaran teks', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(844, 390));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: NumiTema.terang,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.4)),
          child: child!,
        ),
        home: Scaffold(
          body: SafeArea(
            child: PemutarSoal(
              soal: const [_soal],
              konteks: KonteksJawaban.lesson,
              onSelesai: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('13'));
    await tester.pump();
    await tester.tap(find.text('13'));
    await tester.pump();
    await tester.tap(find.text('Cek Jawaban'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Lanjut'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
