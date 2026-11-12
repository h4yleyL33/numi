import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../core/widgets/transisi.dart';
import '../../data/models/companion_message.dart';
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
      body: LatarMalam(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 468),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              const NumiMascot(
                                ekspresi: EkspresiMaskot.berpikir,
                                ukuran: 120,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Membaca Peta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: NumiWarna.malamTerang,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    '$nama, ayo jawab beberapa soal. Jawabanmu membantu Numi memilih pulau tempatmu mulai belajar. Jawab sebisamu, ya!',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      height: 1.4,
                                    ),
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
