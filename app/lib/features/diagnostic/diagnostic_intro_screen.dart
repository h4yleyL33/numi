import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/krayon.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../core/widgets/transisi.dart';
import '../../state/numi_controller.dart';
import '../mascot/numi_mascot.dart';
import 'diagnostic_screen.dart';

class DiagnosticIntroScreen extends ConsumerWidget {
  const DiagnosticIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(numiControllerProvider);
    final nama = data.siswa?.namaPanggilan ?? 'Teman';
    return Scaffold(
      body: LatarKrayon(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 468),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const Alignment(0, -0.52),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              const Text('🗺️', style: TextStyle(fontSize: 72)),
                              const SizedBox(height: 12),
                              Text(
                                'Membaca Peta',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              const SizedBox(height: 44),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: NumiWarna.kartu,
                                  border: Border.all(color: NumiWarna.garis),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      const NumiMascot(
                                        ukuran: 64,
                                        melayang: false,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Sebelum berlayar, kita coba beberapa soal dulu, $nama. Kerjakan sebisamu. Hasilnya membantu memilih latihan.',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            height: 1.45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TombolNumi(
                      label: data.sesiDiagnostic?.ditutup == false
                          ? 'Lanjutkan pemetaan'
                          : 'Ayo mulai',
                      lebar: double.infinity,
                      onTap: () =>
                          Navigator.of(context)
                              .push(transisiNaik(const DiagnosticScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
