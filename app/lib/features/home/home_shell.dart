import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../mascot/mascot_bubble.dart';
import '../progress/progress_screen.dart';
import '../skill_map/skill_map_screen.dart';

/// Kerangka halaman utama: peta dan progres, ditambah pesan maskot yang muncul
/// saat aplikasi dibuka (UC-007).
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;
  CompanionMessage? _pesan;
  Timer? _tutup;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cekPesan());
  }

  Future<void> _cekPesan() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final pesan = await ref.read(numiControllerProvider.notifier).periksaPesanMaskot();
    if (!mounted || pesan == null) return;
    setState(() => _pesan = pesan);
    _tutup = Timer(const Duration(seconds: 7), _sembunyikan);
  }

  void _sembunyikan() {
    final pesan = _pesan;
    if (!mounted || pesan == null) return;
    setState(() => _pesan = null);
    ref.read(numiControllerProvider.notifier).tandaiPesanDibaca(pesan.id);
  }

  @override
  void dispose() {
    _tutup?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _tab, children: const [SkillMapScreen(), ProgressScreen()]),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            left: 12,
            right: 12,
            bottom: _pesan == null ? -220 : 12,
            child: GestureDetector(
              onTap: _sembunyikan,
              child: _pesan == null
                  ? const SizedBox(height: 160)
                  : MascotBubble(teks: _pesan!.isi, ekspresi: _pesan!.ekspresi, ukuranMaskot: 88),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: NumiWarna.cahayaMuda,
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Peta'),
          NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events_rounded), label: 'Progres'),
        ],
      ),
    );
  }
}
