import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/features/feedback/banner_umpan_balik.dart';
import 'package:numi/features/mastery/mastery_screen.dart';
import 'package:numi/features/quiz/pemutar_soal.dart';
import 'package:numi/state/numi_controller.dart';

import '../state/checkpoint_mastery_test.dart'
    show soalCheckpoint, jawabCheckpoint, profilSiap;
import '../state/numi_controller_test.dart' show RepositoryMemori;

class _GagalFinalisasi extends RepositoryMemori {
  bool gagalFinalisasi = true;
  @override
  Future<void> simpan(DataBelajar data) async {
    if (gagalFinalisasi && data.sesiMastery['T01']?.selesai == true) {
      throw StateError('Hasil belum tersimpan');
    }
    await super.simpan(data);
  }
}

void main() {
  testWidgets(
    'lima respons pulih tanpa hasil: finalisasi gagal dapat dicoba lagi',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var sesi = SesiMastery(
        id: 'sesi-lengkap',
        topikId: 'T01',
        soal: soalCheckpoint,
      );
      for (var i = 0; i < 5; i++) {
        sesi = sesi.catat(sesi.commandId(i), jawabCheckpoint(sesi.soal[i]));
      }
      final repo = _GagalFinalisasi();
      final container = ProviderContainer(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          dataAwalProvider.overrideWithValue(
            profilSiap().copyWith(sesiMastery: {'T01': sesi}),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: NumiTema.terang,
            home: MasteryScreen(topik: daftarTopik.first),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.tap(find.text('Lanjutkan test'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(find.text('Pembahasan jawaban'), findsNothing);
      expect(container.read(numiControllerProvider).xp, 0);
      expect(
        container
            .read(numiControllerProvider)
            .sesiMastery['T01']!
            .jawaban
            .length,
        5,
      );
      repo.gagalFinalisasi = false;
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Mercusuar menyala!'), findsOneWidget);
      expect(container.read(numiControllerProvider).hasilMastery.length, 1);
      final pembahasan = find.text('Pembahasan jawaban');
      await tester.scrollUntilVisible(pembahasan, 200);
      await tester.tap(pembahasan);
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.textContaining(soalCheckpoint.first.penjelasan),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'soal ditahan saat gagal, retry memakai respons identik sebelum lanjut',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final tunggu = Completer<void>();
      var gagal = true;
      final dikirim = <Jawaban>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: NumiTema.terang,
          home: Scaffold(
            body: PemutarSoal(
              soal: soalCheckpoint,
              konteks: KonteksJawaban.mastery,
              onSelesai: (_) {},
              simpanJawaban: (j) async {
                dikirim.add(j);
                await tunggu.future;
                if (gagal) throw StateError('Disk penuh');
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('Kirim'));
      await tester.pump();
      expect(find.text('1/5'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      tunggu.complete();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(find.byType(BannerUmpanBalik), findsNothing);
      gagal = false;
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(dikirim.length, 2);
      expect(dikirim.last.toJson(), dikirim.first.toJson());
      expect(dikirim.last.jawaban, '2');
      expect(find.text('2/5'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'mastery melanjutkan soal ketiga dari checkpoint dan finalisasi dapat diulang',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var sesi = SesiMastery(
        id: 'sesi-a',
        topikId: 'T01',
        soal: soalCheckpoint,
      );
      for (var i = 0; i < 2; i++) {
        sesi = sesi.catat(sesi.commandId(i), jawabCheckpoint(sesi.soal[i]));
      }
      final awal = profilSiap().copyWith(sesiMastery: {'T01': sesi});
      final repo = RepositoryMemori();
      final container = ProviderContainer(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          dataAwalProvider.overrideWithValue(awal),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: NumiTema.terang,
            home: MasteryScreen(topik: daftarTopik.first),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.tap(find.text('Lanjutkan test'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('3/5'), findsOneWidget);
      for (var i = 2; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('2'));
        await tester.pump();
        if (i == 4) repo.gagalSimpan = true;
        await tester.tap(find.text('Kirim'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));
      }
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(container.read(numiControllerProvider).xp, 0);
      // Simpan respons terakhir dulu, lalu simulasi kegagalan finalisasi tersendiri
      // lewat uji controller. Di UI ini retry meneruskan sampai hasil tersimpan.
      repo.gagalSimpan = false;
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Mercusuar menyala!'), findsOneWidget);
      expect(container.read(numiControllerProvider).hasilMastery.length, 1);
      expect(
        container.read(numiControllerProvider).sesiMastery['T01']!.selesai,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
