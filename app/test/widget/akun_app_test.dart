import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numi/data/repositories/akun_repository.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';
import 'package:numi/features/account/akun_app.dart';
import 'package:numi/features/diagnostic/diagnostic_screen.dart';
import 'package:numi/features/diagnostic/diagnostic_intro_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numi/state/numi_controller.dart';
import 'package:numi/main.dart' as bootstrap;

class AkunUji implements AkunRepository {
  final events = StreamController<AkunWali?>.broadcast();
  @override
  String? uidAktif;
  HasilMasuk hasil = HasilMasuk.dibatalkan;
  bool gagal = false;
  bool gagalKeluar = false;

  void ganti(String? uid) {
    uidAktif = uid;
    events.add(uid == null ? null : AkunWali(uid: uid, nama: 'Wali'));
  }

  @override
  Stream<AkunWali?> get perubahanAkun => events.stream;
  @override
  Future<HasilMasuk> masukGoogle() async {
    if (gagal) throw StateError('Jaringan putus');
    if (hasil == HasilMasuk.berhasil) ganti('wali-a');
    return hasil;
  }

  @override
  Future<void> keluar() async {
    if (gagalKeluar) throw StateError('Belum keluar');
    ganti(null);
  }
}

void main() {
  Future<void> frame(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
  }

  Future<void> bukaWali(WidgetTester tester) async {
    await tester.tap(find.text('Ruang wali').first);
    await frame(tester);
    final hitungan = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .map((t) => RegExp(r'^(\d+) \+ (\d+) = \?$').firstMatch(t))
        .whereType<RegExpMatch>()
        .single;
    final hasil = int.parse(hitungan[1]!) + int.parse(hitungan[2]!);
    await tester.enterText(find.byType(TextField), '$hasil');
    await tester.pump();
    await tester.tap(find.text('Buka ruang wali'));
    await frame(tester);
    await tester.pump();
  }

  testWidgets('bootstrap tanpa konfigurasi tidak membuka demo atau data lama', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'numi.data_belajar.v1': '{data-lama}',
    });
    await tester.runAsync(bootstrap.main);
    await tester.pump();
    expect(find.text('Layanan akun belum tersedia'), findsOneWidget);
    expect(find.byType(DiagnosticIntroScreen), findsNothing);
    expect(find.text('Profil anak'), findsNothing);
  });

  testWidgets('wali dapat membuat dan mengubah profil dari form enam kelas', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final akun = AkunUji()..uidAktif = 'wali-a';
    addTearDown(akun.events.close);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = LocalProfilRepository(
      prefs,
      uid: 'wali-a',
      uidAktif: () => akun.uidAktif,
    );
    await tester.pumpWidget(AkunApp(akun: akun, profilUntuk: (_) => repo));
    akun.ganti('wali-a');
    await frame(tester);
    await tester.tap(find.text('Tambah profil anak'));
    await frame(tester);
    await tester.enterText(find.byType(TextField), 'Sari');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Kelas 4'));
    await tester.pump();
    await tester.tap(find.text('Periksa profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Simpan dan lanjut'));
    await tester.tap(find.text('Simpan dan lanjut'));
    await frame(tester);
    expect((await repo.daftar()).single.kelas, 4);
    expect((await repo.daftar()).single.waliUid, 'wali-a');
    await bukaWali(tester);
    await tester.tap(find.byTooltip('Ubah profil Sari'));
    await frame(tester);
    await tester.enterText(find.byType(TextField), 'Sari Baru');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Kelas 5'));
    await tester.pump();
    await tester.tap(find.text('Periksa profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Simpan dan lanjut'));
    await tester.tap(find.text('Simpan dan lanjut'));
    await frame(tester);
    expect(find.text('Sari Baru'), findsOneWidget);
    expect((await repo.daftar()).single.kelas, 5);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('gagal keluar memberi retry dan tidak kembali ke layar belajar', (
    tester,
  ) async {
    final akun = AkunUji()
      ..uidAktif = 'wali-a'
      ..gagalKeluar = true;
    addTearDown(akun.events.close);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      AkunApp(
        akun: akun,
        profilUntuk: (wali) => LocalProfilRepository(
          prefs,
          uid: wali.uid,
          uidAktif: () => akun.uidAktif,
        ),
      ),
    );
    akun.ganti('wali-a');
    await frame(tester);
    await tester.tap(find.text('Keluar akun'));
    await frame(tester);
    expect(
      find.text('Belum berhasil keluar akun. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.byType(DiagnosticScreen), findsNothing);
    akun.gagalKeluar = false;
    await tester.tap(find.text('Keluar akun'));
    await frame(tester);
    expect(find.text('Masuk dengan Google'), findsOneWidget);
  });

  for (final ukuran in [const Size(360, 640), const Size(844, 390)]) {
    testWidgets('layar masuk terbaca pada $ukuran dengan teks besar', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.binding.setSurfaceSize(ukuran);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final akun = AkunUji();
      addTearDown(akun.events.close);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.4)),
          child: AkunApp(
            akun: akun,
            profilUntuk: (_) => throw StateError('Belum login'),
          ),
        ),
      );
      akun.ganti(null);
      await frame(tester);
      await tester.ensureVisible(find.text('Masuk dengan Google'));
      await tester.tap(find.text('Masuk dengan Google'));
      await tester.pump();
      expect(find.text('Masuk dibatalkan. Silakan coba lagi.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'batal/gagal login tidak memuat profil, retry baru membuka profil',
    (tester) async {
      final akun = AkunUji();
      addTearDown(akun.events.close);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      var dibaca = 0;
      await tester.pumpWidget(
        AkunApp(
          akun: akun,
          profilUntuk: (wali) {
            dibaca++;
            return LocalProfilRepository(
              prefs,
              uid: wali.uid,
              uidAktif: () => akun.uidAktif,
            );
          },
        ),
      );
      akun.ganti(null);
      await tester.pump();
      expect(dibaca, 0);
      await tester.tap(find.text('Masuk dengan Google'));
      await tester.pump();
      expect(find.text('Masuk dibatalkan. Silakan coba lagi.'), findsOneWidget);
      expect(dibaca, 0);
      akun.gagal = true;
      await tester.tap(find.text('Masuk dengan Google'));
      await tester.pump();
      expect(
        find.text('Belum berhasil masuk. Periksa koneksi lalu coba lagi.'),
        findsOneWidget,
      );
      expect(dibaca, 0);
      akun.gagal = false;
      akun.hasil = HasilMasuk.berhasil;
      await tester.tap(find.text('Masuk dengan Google'));
      await tester.pump();
      await tester.pump();
      expect(dibaca, 1);
      expect(find.text('Pilih profil anak'), findsOneWidget);
      await tester.tap(find.text('Keluar akun'));
      await tester.pump();
      await tester.pump();
      expect(find.text('Masuk dengan Google'), findsOneWidget);
      expect(find.text('Pilih profil anak'), findsNothing);
    },
  );

  testWidgets(
    'ganti profil membuang route soal dan memuat progres anak tujuan',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final akun = AkunUji()..uidAktif = 'wali-a';
      addTearDown(akun.events.close);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = LocalProfilRepository(
        prefs,
        uid: 'wali-a',
        uidAktif: () => akun.uidAktif,
      );
      final sari = await repo.tambah(nama: 'Sari', kelas: 2);
      await repo.tambah(nama: 'Budi', kelas: 5);
      final sariData = repo.untukProfil(sari.id);
      await sariData.simpan((await sariData.muat()).copyWith(xp: 120));
      await tester.pumpWidget(
        AkunApp(
          akun: akun,
          profilUntuk: (wali) => LocalProfilRepository(
            prefs,
            uid: wali.uid,
            uidAktif: () => akun.uidAktif,
          ),
        ),
      );
      akun.ganti('wali-a');
      await frame(tester);
      await tester.tap(find.text('Sari'));
      await frame(tester);
      await tester.pump(const Duration(seconds: 2));
      await frame(tester);
      await tester.tap(find.text('Ayo mulai'));
      await frame(tester);
      expect(find.byType(DiagnosticScreen), findsOneWidget);
      await bukaWali(tester);
      expect(find.text('Pilih profil anak'), findsOneWidget);
      expect(find.byType(DiagnosticScreen), findsNothing);
      await tester.tap(find.text('Budi'));
      await frame(tester);
      await tester.pump(const Duration(seconds: 2));
      await frame(tester);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(DiagnosticIntroScreen)),
      );
      expect(container.read(numiControllerProvider).siswa!.nama, 'Budi');
      expect(container.read(numiControllerProvider).xp, 0);
      akun.ganti('wali-b');
      await frame(tester);
      expect(find.byType(DiagnosticIntroScreen), findsNothing);
      expect(find.byType(DiagnosticScreen), findsNothing);
      expect(find.text('Sari'), findsNothing);
      expect(find.text('Budi'), findsNothing);
      expect(find.text('Pilih profil anak'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
