import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../core/widgets/transisi.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../mascot/mascot_bubble.dart';
import 'diagnostic_screen.dart';

class DiagnosticIntroScreen extends ConsumerWidget {
  const DiagnosticIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama =
        ref.watch(numiControllerProvider).siswa?.namaPanggilan ?? 'Teman';
    return Scaffold(
      body: LatarMalam(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text('🗺️', style: TextStyle(fontSize: 72)),
                        const SizedBox(height: 12),
                        const Text(
                          'Membaca Peta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 28),
                        MascotBubble(
                          gelap: true,
                          ekspresi: EkspresiMaskot.berpikir,
                          ukuranMaskot: 96,
                          teks:
                              'Sebelum berlayar, aku perlu tahu pulau mana yang sudah bisa kamu terangi, $nama. '
                              'Jawab sebisamu ya. Ini bukan ujian, tidak ada nilai merah!',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TombolNumi(
                  label:
                      ref
                              .watch(numiControllerProvider)
                              .sesiDiagnostic
                              ?.ditutup ==
                          false
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
    );
  }
}
