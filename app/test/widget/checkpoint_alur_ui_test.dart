import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/checkpoint_diagnostic.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/sesi_soal.dart';
import 'package:numi/features/diagnostic/diagnostic_screen.dart';
import 'package:numi/features/feedback/banner_umpan_balik.dart';
import 'package:numi/features/lesson/lesson_screen.dart';
import 'package:numi/state/numi_controller.dart';

import '../domain/checkpoint_diagnostic_test.dart' show jawabDiagnostic;
import '../state/checkpoint_mastery_test.dart' show soalCheckpoint, profilSiap;
import '../state/checkpoint_alur_test.dart' show responsSoal;
import '../state/numi_controller_test.dart' show RepositoryMemori;

void main() {
  Future<void> tampil(
    WidgetTester tester,
    ProviderContainer container,
    Widget layar,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: NumiTema.terang, home: layar),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));
  }

  ProviderContainer buka(RepositoryMemori repo, DataBelajar awal) {
    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        dataAwalProvider.overrideWithValue(awal),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  testWidgets(
    'diagnostic pulih lengkap: gagal simpan hasil terlihat dan retry tidak mengulang respons',
    (tester) async {
      var sesi = CheckpointDiagnostic.mulai('diag-a', 1);
      final b = sesi.blok.first;
      for (var i = 0; i < 2; i++) {
        sesi = sesi.catat(b.commandId(i), jawabDiagnostic(b, i, benar: false));
      }
      final repo = RepositoryMemori()..gagalSimpan = true;
      final container = buka(repo, profilSiap().copyWith(sesiDiagnostic: sesi));
      await tampil(tester, container, const DiagnosticScreen());
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(find.byType(BannerUmpanBalik), findsNothing);
      expect(
        container.read(numiControllerProvider).sesiDiagnostic!.ditutup,
        isFalse,
      );
      repo.gagalSimpan = false;
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Lihat Peta'), findsOneWidget);
      expect(container.read(numiControllerProvider).riwayatJawaban.length, 2);
      expect(
        container.read(numiControllerProvider).sesiDiagnostic!.ditutup,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'lesson pulih pada pembahasan; gagal Lanjut menahan soal hingga retry',
    (tester) async {
      final lesson = lessonUntuk('T01').first;
      var sesi = SesiSoal(
        id: 'lesson-a',
        topikId: 'T01',
        soal: soalCheckpoint,
        konteks: KonteksJawaban.lesson,
        lessonId: lesson.id,
        mulaiPada: DateTime(2026),
      );
      sesi = sesi.catat(
        sesi.commandId(0),
        responsSoal(sesi.soal[0], KonteksJawaban.lesson, benar: false),
      );
      final repo = RepositoryMemori()..gagalSimpan = true;
      final container = buka(
        repo,
        profilSiap().copyWith(sesiLesson: {lesson.id: sesi}),
      );
      await tampil(tester, container, LessonScreen(lesson: lesson));
      expect(find.byType(BannerUmpanBalik), findsOneWidget);
      expect(find.text('1/5'), findsOneWidget);
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(
        container
            .read(numiControllerProvider)
            .sesiLesson[lesson.id]!
            .menungguLanjut,
        isTrue,
      );
      repo.gagalSimpan = false;
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('2/5'), findsOneWidget);
      expect(find.byType(BannerUmpanBalik), findsNothing);
      expect(
        container
            .read(numiControllerProvider)
            .sesiLesson[lesson.id]!
            .jawaban
            .length,
        1,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'lesson lengkap: finalisasi gagal/retry menampilkan hasil tanpa reward ganda',
    (tester) async {
      final lesson = lessonUntuk('T01').first;
      var sesi = SesiSoal(
        id: 'lesson-a',
        topikId: 'T01',
        soal: soalCheckpoint,
        konteks: KonteksJawaban.lesson,
        lessonId: lesson.id,
        mulaiPada: DateTime(2026),
      );
      for (var i = 0; i < 5; i++) {
        sesi = sesi.catat(
          sesi.commandId(i),
          responsSoal(sesi.soal[i], KonteksJawaban.lesson),
        );
        sesi = sesi.lanjut('${sesi.id}/lanjut/$i');
      }
      final repo = RepositoryMemori()..gagalSimpan = true;
      final container = buka(
        repo,
        profilSiap().copyWith(sesiLesson: {lesson.id: sesi}),
      );
      await tampil(tester, container, LessonScreen(lesson: lesson));
      expect(find.text('Coba simpan lagi'), findsOneWidget);
      expect(container.read(numiControllerProvider).xp, 0);
      repo.gagalSimpan = false;
      await tester.tap(find.text('Coba simpan lagi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Lesson selesai!'), findsOneWidget);
      expect(container.read(numiControllerProvider).xp, 70);
      expect(
        container.read(numiControllerProvider).sesiLesson[lesson.id]!.selesai,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
