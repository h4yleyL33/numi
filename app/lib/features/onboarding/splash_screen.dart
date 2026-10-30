import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/latar_malam.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../diagnostic/diagnostic_intro_screen.dart';
import '../home/home_shell.dart';
import '../mascot/numi_mascot.dart';
import 'onboarding_screen.dart';
import '../../core/widgets/transisi.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1900), _lanjut);
  }

  void _lanjut() {
    if (!mounted) return;
    final data = ref.read(numiControllerProvider);
    final Widget tujuan;
    if (!data.sudahDaftar) {
      tujuan = const OnboardingScreen();
    } else if (!data.diagnosticSelesai) {
      tujuan = const DiagnosticIntroScreen();
    } else {
      tujuan = const HomeShell();
    }
    Navigator.of(context).pushReplacement(transisiPudar(tujuan));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LatarMalam(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NumiMascot(ukuran: 170, ekspresi: EkspresiMaskot.senang),
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutBack,
                  builder: (context, v, child) => Opacity(
                    opacity: v.clamp(0, 1),
                    child: Transform.translate(
                      offset: Offset(0, (1 - v) * 30),
                      child: child,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Numi',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                      ),
                      const Text(
                        'Petualangan di Samudra Angka',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
