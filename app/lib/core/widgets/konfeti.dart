import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Hujan konfeti sekali jalan untuk momen berhasil. Doktek menyebut Lottie untuk
/// momen ini; versi CustomPainter dipakai dulu agar tidak perlu file animasi.
class Konfeti extends StatefulWidget {
  const Konfeti({super.key, this.jumlah = 70});

  final int jumlah;

  @override
  State<Konfeti> createState() => _KonfetiState();
}

class _KonfetiState extends State<Konfeti> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();
  static const _warna = [NumiWarna.cahaya, NumiWarna.benar, NumiWarna.salah, NumiWarna.ungu, NumiWarna.langit];
  late final List<_Kertas> _kertas = List.generate(widget.jumlah, (i) {
    final r = Random(i);
    return _Kertas(
      x: r.nextDouble(),
      tunda: r.nextDouble() * 0.35,
      kecepatan: 0.7 + r.nextDouble() * 0.6,
      goyang: r.nextDouble() * 2 * pi,
      warna: _warna[i % _warna.length],
      ukuran: 6 + r.nextDouble() * 6,
    );
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(painter: _PelukisKonfeti(_kertas, _c.value), size: Size.infinite),
      ),
    );
  }
}

class _Kertas {
  const _Kertas({
    required this.x,
    required this.tunda,
    required this.kecepatan,
    required this.goyang,
    required this.warna,
    required this.ukuran,
  });

  final double x;
  final double tunda;
  final double kecepatan;
  final double goyang;
  final Color warna;
  final double ukuran;
}

class _PelukisKonfeti extends CustomPainter {
  _PelukisKonfeti(this.kertas, this.t);

  final List<_Kertas> kertas;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final k in kertas) {
      final p = ((t - k.tunda) / (1 - k.tunda)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final y = -20 + p * k.kecepatan * (size.height + 40);
      final x = k.x * size.width + sin(p * 10 + k.goyang) * 18;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p * 12 + k.goyang);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: k.ukuran, height: k.ukuran * 0.55),
        Paint()..color = k.warna.withValues(alpha: 1 - p * 0.6),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisKonfeti lama) => lama.t != t;
}
