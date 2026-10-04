import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/app.dart';
import 'package:numi/state/numi_controller.dart';

import '../state/numi_controller_test.dart' show RepositoryMemori;

void main() {
  testWidgets('siswa baru melewati cerita lalu mengisi profil sampai diagnostic', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    final repo = RepositoryMemori();
    await tester.pumpWidget(ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(repo)],
      child: const NumiApp(),
    ));

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

    expect(find.text('Halo, Teman!'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Sari');
    await tester.tap(find.text('8'));
    await tester.pump();
    await tester.tap(find.text('Mulai Petualangan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(repo.tersimpan!.siswa!.nama, 'Sari');
    expect(repo.tersimpan!.siswa!.usia, 8);
    expect(find.text('Membaca Peta'), findsOneWidget);
  });
}
