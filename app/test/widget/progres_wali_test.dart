import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:numi/core/theme/app_theme.dart';
import 'package:numi/data/models/bukti_skill.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/features/progress/progress_screen.dart';
import 'package:numi/state/numi_controller.dart';

void main() {
  testWidgets('laporan kemampuan muncul setelah gerbang wali dibuka', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final tanggal = DateTime(2026, 11, 17);
    final data = DataBelajar(
      siswa: Siswa(id: 'uji', nama: 'Sari', kelas: 2, dibuatPada: tanggal),
      hasilDiagnostic: const [
        DiagnosticResult(
          topikId: 'T01',
          benar: 1,
          total: 2,
          statusPenguasaan: StatusTopik.perluLatihan,
        ),
      ],
      buktiSkill: {
        'T01': BuktiSkill(
          topikId: 'T01',
          skillId: 'T01-jangkar',
          status: StatusBukti.indikasiLatihan,
          benar: 1,
          total: 2,
          bantuan: 0,
          sumberSesi: 'diagnostic-uji',
          waktu: tanggal,
          versiKebijakan: 'numi-pilot-v1',
          versiButir: const ['kelas-2-v1'],
        ),
      },
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dataAwalProvider.overrideWithValue(data)],
        child: MaterialApp(
          theme: NumiTema.terang,
          home: const Scaffold(body: ProgressScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    final tombol = find.text('Untuk orang tua');
    await tester.scrollUntilVisible(
      tombol,
      250,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.tap(tombol);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Progres untuk wali'), findsNothing);

    final soal = find.textContaining(RegExp(r'^\d+ \+ \d+ = \?$'));
    final angka = (tester.widget<Text>(soal).data!).split(' ');
    await tester.enterText(
      find.byType(TextField),
      '${int.parse(angka[0]) + int.parse(angka[2])}',
    );
    await tester.pump();
    await tester.tap(find.text('Buka ruang wali'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));

    expect(find.text('Progres untuk wali'), findsOneWidget);
    expect(
      find.textContaining('1/2 benar · 0 bantuan · 2026-11-17'),
      findsOneWidget,
    );
    expect(find.text('Kemampuan per topik'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
