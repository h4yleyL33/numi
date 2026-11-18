import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/features/mastery/mastery_screen.dart';
import 'package:numi/state/numi_controller.dart';

import '../state/checkpoint_mastery_test.dart' show profilSiap, jawabCheckpoint;
import '../state/numi_controller_test.dart' show RepositoryMemori;

void main() {
  testWidgets(
    'Mulai test baru mengecualikan isi mastery lama meskipun ID acak',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final generator = GeneratorSoal(Random(42));
      final pool = [
        for (var i = 0; i < 20; i++) ...generator.buat('T05', 5, tingkat: 2),
      ];
      final gambar = {
        for (final s in pool.where((s) => s.jenis == JenisSoal.pecahanGambar))
          s.gambarPecahan.toString(): s,
      };
      expect(gambar, hasLength(2));
      final soalLama = [
        ...gambar.values,
        ...pool.where((s) => s.jenis != JenisSoal.pecahanGambar).take(3),
      ];
      var sesi = SesiMastery(
        id: 'mastery-lama',
        topikId: 'T05',
        soal: soalLama,
      );
      for (var i = 0; i < 5; i++) {
        sesi = sesi.catat(
          sesi.commandId(i),
          jawabCheckpoint(soalLama[i], isi: soalLama[i].jawabanBenar),
        );
      }
      final awal = profilSiap().copyWith(
        sesiMastery: {'T05': sesi},
        skillMap: {
          'T05': SkillMap(
            topikId: 'T05',
            status: StatusTopik.belumDiuji,
            diperbarui: DateTime(2026),
          ),
        },
        progresLesson: {
          for (final l in lessonUntuk('T05'))
            l.id: LessonProgress(
              lessonId: l.id,
              topikId: 'T05',
              selesai: true,
              skorTerbaik: 100,
              jumlahPercobaan: 1,
              waktu: DateTime(2026),
            ),
        },
      );
      final container = ProviderContainer(
        overrides: [
          repositoryProvider.overrideWithValue(RepositoryMemori()),
          dataAwalProvider.overrideWithValue(awal),
        ],
      );
      addTearDown(container.dispose);
      await container
          .read(numiControllerProvider.notifier)
          .finalisasiMastery('T05', sesi.id);
      final xp = container.read(numiControllerProvider).xp;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: NumiTema.terang,
            home: MasteryScreen(topik: topikById('T05')),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      await tester.ensureVisible(find.text('Mulai test baru'));
      await tester.tap(find.text('Mulai test baru'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      final baru = container.read(numiControllerProvider).sesiMastery['T05']!;
      expect(baru.id, isNot(sesi.id));
      expect(baru.soal, hasLength(5));
      expect(
        baru.soal.where((s) => s.jenis == JenisSoal.pecahanGambar),
        isEmpty,
        reason: 'kedua isi gambar pecahan sudah ada dalam mastery sebelumnya',
      );
      expect(container.read(numiControllerProvider).xp, xp);
      expect(tester.takeException(), isNull);
    },
  );
}
