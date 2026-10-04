import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pulau kecil dengan mercusuar. Dipakai di cerita pembuka dan layar mastery.
class PulauHias extends StatefulWidget {
  const PulauHias({super.key, required this.menyala, this.ukuran = 100});

  final bool menyala;
  final double ukuran;

  @override
  State<PulauHias> createState() => _PulauHiasState();
}

class _PulauHiasState extends State<PulauHias> with SingleTickerProviderStateMixin {
  late final AnimationController _putar =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.ukuran * 1.6,
      height: widget.ukuran * 1.4,
      child: AnimatedBuilder(
        animation: _putar,
        builder: (context, _) => CustomPaint(
          painter: PelukisMercusuar(menyala: widget.menyala, sudutSorot: _putar.value * 2 * pi),
        ),
      ),
    );
  }
}

class PelukisMercusuar extends CustomPainter {
  PelukisMercusuar({required this.menyala, required this.sudutSorot});

  final bool menyala;
  final double sudutSorot;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final dasar = Offset(w / 2, h * 0.82);

    canvas.drawOval(
      Rect.fromCenter(center: dasar, width: w * 0.9, height: h * 0.26),
      Paint()..color = menyala ? const Color(0xFFF2D48C) : const Color(0xFF4A4F7A),
    );
    canvas.drawOval(
      Rect.fromCenter(center: dasar.translate(0, -h * 0.03), width: w * 0.6, height: h * 0.14),
      Paint()..color = menyala ? const Color(0xFF6CC47A) : const Color(0xFF3A3F66),
    );

    final atas = Offset(w / 2, h * 0.3);
    final badan = Path()
      ..moveTo(dasar.dx - w * 0.08, dasar.dy - h * 0.05)
      ..lineTo(atas.dx - w * 0.05, atas.dy)
      ..lineTo(atas.dx + w * 0.05, atas.dy)
      ..lineTo(dasar.dx + w * 0.08, dasar.dy - h * 0.05)
      ..close();
    canvas.drawPath(badan, Paint()..color = menyala ? Colors.white : const Color(0xFF8B8FB3));
    for (var i = 1; i <= 2; i++) {
      final y = atas.dy + (dasar.dy - atas.dy) * i / 3.2;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(w / 2, y), width: w * 0.13, height: h * 0.05),
        Paint()..color = menyala ? NumiWarna.salah : const Color(0xFF6B6F99),
      );
    }

    final lampu = atas.translate(0, -h * 0.05);
    if (menyala) {
      final sorot = Path()
        ..moveTo(lampu.dx, lampu.dy)
        ..lineTo(lampu.dx + cos(sudutSorot - 0.18) * w, lampu.dy + sin(sudutSorot - 0.18) * w * 0.35)
        ..lineTo(lampu.dx + cos(sudutSorot + 0.18) * w, lampu.dy + sin(sudutSorot + 0.18) * w * 0.35)
        ..close();
      canvas.drawPath(sorot, Paint()..color = NumiWarna.cahayaMuda.withValues(alpha: 0.35));
      canvas.drawCircle(lampu, w * 0.14, Paint()..color = NumiWarna.cahaya.withValues(alpha: 0.4));
    }
    canvas.drawCircle(lampu, w * 0.06, Paint()..color = menyala ? NumiWarna.cahayaMuda : const Color(0xFF5A5E88));
    final atap = Path()
      ..moveTo(lampu.dx - w * 0.08, lampu.dy - h * 0.03)
      ..lineTo(lampu.dx, lampu.dy - h * 0.13)
      ..lineTo(lampu.dx + w * 0.08, lampu.dy - h * 0.03)
      ..close();
    canvas.drawPath(atap, Paint()..color = menyala ? NumiWarna.salah : const Color(0xFF6B6F99));
  }

  @override
  bool shouldRepaint(covariant PelukisMercusuar lama) =>
      lama.menyala != menyala || lama.sudutSorot != sudutSorot;
}
