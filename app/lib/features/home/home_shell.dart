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
    if (!mounted) return;
    CompanionMessage? pesan;
    try {
      pesan = await ref.read(numiControllerProvider.notifier).periksaPesanMaskot();
    } catch (_) {
      // Sesi yang ditutup atau simpan gagal tidak boleh membuka pesan lama.
      return;
    }
    if (!mounted || pesan == null) return;
    setState(() => _pesan = pesan);
    _tutup = Timer(const Duration(seconds: 7), _sembunyikan);
  }

  Future<void> _sembunyikan() async {
    final pesan = _pesan;
    if (!mounted || pesan == null) return;
    setState(() => _pesan = null);
    try {
      await ref.read(numiControllerProvider.notifier).tandaiPesanDibaca(pesan.id);
    } catch (_) {
      // Pesan sudah ditutup; status baca dapat diperiksa pada pembukaan berikutnya.
    }
  }

  @override
  void dispose() {
    _tutup?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, batas) {
        final mendatar = batas.maxWidth >= 700;
        return Scaffold(
          body: Row(
            children: [
              if (mendatar)
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Colors.white,
                    indicatorColor: NumiWarna.cahayaMuda,
                    labelType: NavigationRailLabelType.all,
                    selectedIndex: _tab,
                    onDestinationSelected: (i) => setState(() => _tab = i),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.map_outlined),
                        selectedIcon: Icon(Icons.map_rounded),
                        label: Text('Peta'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.emoji_events_outlined),
                        selectedIcon: Icon(Icons.emoji_events_rounded),
                        label: Text('Progres'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(
                      index: _tab,
                      children: const [SkillMapScreen(), ProgressScreen()],
                    ),
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
                            : MascotBubble(
                                teks: _pesan!.isi,
                                ekspresi: _pesan!.ekspresi,
                                ukuranMaskot: 88,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: mendatar
              ? null
              : NavigationBar(
                  backgroundColor: Colors.white,
                  indicatorColor: NumiWarna.cahayaMuda,
                  selectedIndex: _tab,
                  onDestinationSelected: (i) => setState(() => _tab = i),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map_rounded),
                      label: 'Peta',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events_rounded),
                      label: 'Progres',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
