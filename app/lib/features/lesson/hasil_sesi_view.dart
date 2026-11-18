import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/konfeti.dart';
import '../../core/widgets/krayon.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../state/numi_controller.dart';
import '../mascot/mascot_bubble.dart';

/// Layar akhir lesson dan mastery test: skor, XP, level, dan lencana baru.
class HasilSesiView extends StatelessWidget {
  const HasilSesiView({
    super.key,
    required this.ringkasan,
    required this.judul,
    required this.tombolUtama,
    required this.onUtama,
    this.tombolKedua,
    this.onKedua,
    this.hiasan,
    this.catatan,
    this.pembahasan,
  });

  final RingkasanSesi ringkasan;
  final String judul;
  final String tombolUtama;
  final VoidCallback onUtama;
  final String? tombolKedua;
  final VoidCallback? onKedua;
  final Widget? hiasan;
  final String? catatan;
  final Widget? pembahasan;

  @override
  Widget build(BuildContext context) {
    final r = ringkasan;
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (hiasan != null)
                        Container(
                          decoration: kertasKrayon('panel-mint'),
                          padding: const EdgeInsets.all(16),
                          child: Center(child: hiasan!),
                        ),
                      Text(
                        judul,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (catatan != null)
                        Text(catatan!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _Angka(
                            label: 'Benar',
                            nilai: '${r.benar}/${r.total}',
                            warna: NumiWarna.benar,
                          ),
                          const SizedBox(width: 12),
                          _Angka(
                            label: 'XP',
                            nilai: '+${r.xpDidapat}',
                            warna: NumiWarna.cahaya,
                            hitung: r.xpDidapat,
                          ),
                        ],
                      ),
                      if (r.levelNaik) ...[
                        const SizedBox(height: 12),
                        _Pita(
                          teks: 'Level naik ke ${r.levelSesudah}!',
                          ikon: '🚀',
                        ),
                      ],
                      for (final l in r.lencanaBaru) ...[
                        const SizedBox(height: 12),
                        _Pita(teks: 'Lencana baru: ${l.nama}', ikon: l.ikon),
                      ],
                      const SizedBox(height: 24),
                      MascotBubble(
                        teks: r.pesan.isi,
                        ekspresi: r.pesan.ekspresi,
                        ukuranMaskot: 92,
                      ),
                      ?pembahasan,
                    ],
                  ),
                ),
                TombolNumi(
                  label: tombolUtama,
                  lebar: double.infinity,
                  onTap: onUtama,
                ),
                if (tombolKedua != null) ...[
                  const SizedBox(height: 10),
                  TombolNumi(
                    label: tombolKedua!,
                    lebar: double.infinity,
                    warna: NumiWarna.kartu,
                    onTap: onKedua,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (r.lulus) const Positioned.fill(child: Konfeti()),
      ],
    );
  }
}

class _Angka extends StatelessWidget {
  const _Angka({
    required this.label,
    required this.nilai,
    required this.warna,
    this.hitung,
  });

  final String label;
  final String nilai;
  final Color warna;
  final int? hitung;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: warna, width: 3),
          boxShadow: [BoxShadow(color: warna, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: NumiWarna.tintaPudar,
              ),
            ),
            if (hitung == null)
              Text(
                nilai,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              )
            else
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: hitung!),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Text(
                  '+$v',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Pita extends StatelessWidget {
  const _Pita({required this.teks, required this.ikon});

  final String teks;
  final String ikon;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [NumiWarna.ungu, NumiWarna.langit],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(ikon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                teks,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
