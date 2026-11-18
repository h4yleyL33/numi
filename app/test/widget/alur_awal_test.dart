import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/app.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/features/onboarding/onboarding_screen.dart';
import 'package:numi/state/numi_controller.dart';

import '../state/numi_controller_test.dart' show RepositoryMemori;

void main() {
  testWidgets(
    'siswa baru melewati cerita lalu mengisi profil sampai diagnostic',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repo = RepositoryMemori();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [repositoryProvider.overrideWithValue(repo)],
          child: const NumiApp(),
        ),
      );

      expect(find.text('Numi'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.textContaining('Samudra Angka'), findsWidgets);
      for (final label in ['Lanjut', 'Lanjut', 'Aku mau membantu!']) {
        await tester.tap(find.text(label));
        // Maskot beranimasi terus, jadi pumpAndSettle tidak akan pernah tenang.
        // Animasi geser halaman baru mulai di frame berikutnya.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump();
      }

      expect(find.text('Profil anak'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Sari');
      await tester.tap(find.text('Kelas 2'));
      await tester.pump();
      await tester.tap(find.text('Periksa profil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(repo.tersimpan, isNull);
      await tester.tap(find.text('Simpan dan lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 700));

      expect(repo.tersimpan!.siswa!.nama, 'Sari');
      expect(repo.tersimpan!.siswa!.kelas, 2);
      expect(find.text('Membaca Peta'), findsOneWidget);
    },
  );

  testWidgets(
    'profil usia lama meminta kelas dan menjaga riwayat setelah retry',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final lama = DataBelajar(
        siswa: Siswa(
          id: 'lama',
          nama: 'Sari',
          usia: 10,
          dibuatPada: DateTime(2026, 9, 20),
        ),
        xp: 120,
      );
      final repo = RepositoryMemori()..gagalSimpan = true;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            repositoryProvider.overrideWithValue(repo),
            dataAwalProvider.overrideWithValue(lama),
          ],
          child: const NumiApp(),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byType(OnboardingScreen), findsOneWidget);
      for (var kelas = 1; kelas <= 6; kelas++) {
        expect(find.text('Kelas $kelas'), findsOneWidget);
      }
      expect(find.text('Berapa umurmu?'), findsNothing);
      expect(find.text('Sari'), findsOneWidget);
      await tester.ensureVisible(find.text('Kelas 6'));
      await tester.tap(find.text('Kelas 6'));
      await tester.pump();
      await tester.tap(find.text('Periksa profil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(repo.tersimpan, isNull);
      await tester.tap(find.text('Simpan dan lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Profil belum tersimpan. Coba lagi.'), findsOneWidget);
      expect(repo.tersimpan, isNull);
      repo.gagalSimpan = false;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 700));
      expect(repo.tersimpan!.siswa!.id, 'lama');
      expect(repo.tersimpan!.siswa!.kelas, 6);
      expect(repo.tersimpan!.xp, 120);
      expect(find.text('Membaca Peta'), findsOneWidget);
    },
  );
}
