import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/models/bukti_skill.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/domain/diagnostic_engine.dart';
import 'package:numi/features/diagnostic/diagnostic_result_screen.dart';
import 'package:numi/features/skill_map/topik_sheet.dart';
import 'package:numi/state/numi_controller.dart';

void main() {
  testWidgets(
    'hasil diagnostic tidak menampilkan penguasaan topik yang belum diuji',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final sesi = SesiDiagnostic(topik: daftarTopik, kelas: 4)
        ..catat(0)
        ..catat(2);
      await tester.pumpWidget(
        MaterialApp(
          theme: NumiTema.terang,
          home: DiagnosticResultScreen(hasil: sesi.hasilAkhir()),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Belum dicoba'), findsWidgets);
      expect(find.text('Bukti awal'), findsNothing);
      expect(
        find.textContaining('bukan penguasaan seluruh materi'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'kartu pulau menampilkan bukti dan alasan akses secara terpisah',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final data = DataBelajar(
        buktiSkill: {
          'T02': BuktiSkill(
            topikId: 'T02',
            skillId: 'T02-jangkar',
            status: StatusBukti.indikasiSiap,
            benar: 2,
            total: 2,
            bantuan: 0,
            sumberSesi: 'diagnostic-1',
            waktu: DateTime(2026, 10, 30),
            versiKebijakan: 'pilot-v1',
            versiButir: const ['kelas-2-v1'],
          ),
        },
        aksesMateri: {
          'T02': const AksesMateri(
            topikId: 'T02',
            terbuka: false,
            alasan: 'Prasyarat perlu dilatih.',
          ),
        },
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dataAwalProvider.overrideWithValue(data)],
          child: MaterialApp(
            theme: NumiTema.terang,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      tampilkanTopikSheet(context, topikById('T02')),
                  child: const Text('Pulau'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pulau'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Bukti pada sampel: Siap lanjut'), findsOneWidget);
      expect(find.text('Akses: Prasyarat perlu dilatih.'), findsOneWidget);
      expect(find.text('Terkunci'), findsOneWidget);
      expect(find.text('Mulai'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
