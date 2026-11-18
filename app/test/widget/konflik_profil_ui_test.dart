import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';
import 'package:numi/features/account/akun_app.dart';

import '../data/sinkron_profil_test.dart' show ServerProfilUji;
import 'akun_app_test.dart' show AkunUji;

void main() {
  testWidgets('wali meninjau konflik, dapat membatalkan, lalu memakai cloud', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final server = ServerProfilUji();
    final akun = AkunUji()..uidAktif = 'wali-a';
    addTearDown(akun.events.close);
    Future<LocalProfilRepository> perangkat(String nama) async {
      final db = await newDatabaseFactoryMemory().openDatabase(nama);
      addTearDown(db.close);
      final repo = LocalProfilRepository(
        prefs,
        uid: 'wali-a',
        uidAktif: () => akun.uidAktif,
        database: db,
        cloud: server,
      );
      await repo.aturCloud(true);
      return repo;
    }

    final b = await tester.runAsync(() async {
      final a = await perangkat('a');
      final b = await perangkat('b');
      final siswa = await a.tambah(nama: 'Sari', kelas: 1);
      await a.sinkron(tarik: false);
      await b.sinkron(tarik: true);
      final lokal = b.untukProfil(siswa.id);
      await lokal.simpan((await lokal.muat()).copyWith(xp: 20));
      final cloud = a.untukProfil(siswa.id);
      await cloud.simpan((await cloud.muat()).copyWith(xp: 10));
      await a.sinkron(tarik: false);
      await b.sinkron(tarik: true);
      return b;
    });
    final siswa = (await tester.runAsync(() => b!.daftar()))!.single;
    Future<void> frame() async {
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump(const Duration(milliseconds: 700));
    }

    await tester.pumpWidget(AkunApp(akun: akun, profilUntuk: (_) => b!));
    akun.ganti('wali-a');
    await frame();
    await tester.tap(find.text('Selesaikan konflik'));
    await frame();
    expect(find.textContaining('20 XP'), findsOneWidget);
    expect(find.textContaining('10 XP'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await frame();
    expect(
      (await tester.runAsync(() => b!.untukProfil(siswa.id).muat()))!.xp,
      20,
    );
    await tester.tap(find.text('Selesaikan konflik'));
    await frame();
    await tester.tap(find.text('Pakai cloud'));
    await frame();
    expect(
      (await tester.runAsync(() => b!.untukProfil(siswa.id).muat()))!.xp,
      10,
    );
    expect(find.textContaining('kedua salinan dicadangkan'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
