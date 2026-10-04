import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Langit malam dengan bintang berkelip. Dipakai di splash, cerita, dan peta.
class LatarMalam extends StatefulWidget {
  const LatarMalam({super.key, required this.child, this.jumlahBintang = 60});

  final Widget child;
  final int jumlahBintang;

  @override
  State<LatarMalam> createState() => _LatarMalamState();
}

class _LatarMalamState extends State<LatarMalam> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  late final List<_Bintang> _bintang = List.generate(widget.jumlahBintang, (i) {
    final r = Random(i * 7 + 3);
    return _Bintang(Offset(r.nextDouble(), r.nextDouble()), 0.6 + r.nextDouble() * 1.8, r.nextDouble() * pi * 2);
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF12143A), NumiWarna.malam, NumiWarna.laut],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) => CustomPaint(painter: _PelukisBintang(_bintang, _c.value)),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _Bintang {
  const _Bintang(this.posisi, this.ukuran, this.fase);
  final Offset posisi;
  final double ukuran;
  final double fase;
}

class _PelukisBintang extends CustomPainter {
  _PelukisBintang(this.bintang, this.t);

  final List<_Bintang> bintang;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bintang) {
      final kelip = 0.35 + 0.65 * (0.5 + 0.5 * sin(t * 2 * pi + b.fase));
      canvas.drawCircle(
        Offset(b.posisi.dx * size.width, b.posisi.dy * size.height),
        b.ukuran,
        Paint()..color = Colors.white.withValues(alpha: kelip * 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisBintang lama) => lama.t != t;
}
