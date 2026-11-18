import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/krayon.dart';
import '../../data/models/companion_message.dart';

/// Maskot Numi, kunang-kunang kecil yang cahayanya menerangi pulau-pulau angka.
///
/// Digambar dengan CustomPainter supaya bisa bergerak tanpa file animasi.
/// Doktek menyebut Rive untuk animasi maskot; widget ini bisa diganti dengan
/// RiveAnimation nanti tanpa mengubah pemanggilnya, selama ekspresinya sama.
class NumiMascot extends StatefulWidget {
  const NumiMascot({
    super.key,
    this.ekspresi = EkspresiMaskot.senang,
    this.ukuran = 120,
    this.melayang = true,
  });

  final EkspresiMaskot ekspresi;
  final double ukuran;
  final bool melayang;

  @override
  State<NumiMascot> createState() => _NumiMascotState();
}

class _NumiMascotState extends State<NumiMascot> with TickerProviderStateMixin {
  late final AnimationController _nafas = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();
  late final AnimationController _kedip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final AnimationController _ganti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: 1,
  );
  final _rng = Random();
  Timer? _timerKedip;

  @override
  void initState() {
    super.initState();
    _jadwalKedip();
  }

  void _jadwalKedip() {
    _timerKedip = Timer(
      Duration(milliseconds: 1800 + _rng.nextInt(2600)),
      () async {
        if (!mounted) return;
        await _kedip.forward();
        if (!mounted) return;
        await _kedip.reverse();
        if (mounted) _jadwalKedip();
      },
    );
  }

  @override
  void didUpdateWidget(covariant NumiMascot lama) {
    super.didUpdateWidget(lama);
    if (lama.ekspresi != widget.ekspresi) _ganti.forward(from: 0);
  }

  @override
  void dispose() {
    _timerKedip?.cancel();
    _nafas.dispose();
    _kedip.dispose();
    _ganti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kolomKrayon = switch (widget.ekspresi) {
      EkspresiMaskot.senang => 0,
      EkspresiMaskot.berpikir => 1,
      EkspresiMaskot.semangat => 2,
      EkspresiMaskot.mengantuk => 3,
      EkspresiMaskot.bangga => 0,
      EkspresiMaskot.sedih => null,
    };
    return Semantics(
      label: 'Numi si kunang-kunang',
      child: SizedBox.square(
        dimension: widget.ukuran,
        child: AnimatedBuilder(
          animation: Listenable.merge([_nafas, _kedip, _ganti]),
          builder: (context, _) {
            final t = _nafas.value * 2 * pi;
            final lompat = Curves.elasticOut.transform(_ganti.value);
            return Transform.translate(
              offset: Offset(
                0,
                widget.melayang ? sin(t) * widget.ukuran * 0.04 : 0,
              ),
              child: Transform.scale(
                scale: 0.85 + 0.15 * lompat,
                child: kolomKrayon != null
                    ? IlustrasiKrayon(
                        kolom: kolomKrayon,
                        lebar: widget.ukuran,
                        tinggi: widget.ukuran,
                      )
                    : CustomPaint(
                        painter: _PelukisNumi(
                          ekspresi: widget.ekspresi,
                          fase: t,
                          kedip: _kedip.value,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PelukisNumi extends CustomPainter {
  _PelukisNumi({
    required this.ekspresi,
    required this.fase,
    required this.kedip,
  });

  final EkspresiMaskot ekspresi;
  final double fase;
  final double kedip;

  static const _badan = Color(0xFFFFD166);
  static const _badanGelap = Color(0xFFF4A340);
  static const _perut = Color(0xFFFFF1C1);
  static const _mata = Color(0xFF2A2350);
  static const _pipi = Color(0xFFFF9AA2);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final pusat = Offset(s * 0.5, s * 0.56);
    final r = s * 0.3;

    // Cahaya di sekeliling tubuh berdenyut pelan. Saat mengantuk cahayanya redup.
    final redup = ekspresi == EkspresiMaskot.mengantuk ? 0.45 : 1.0;
    final denyut = 0.85 + 0.15 * sin(fase * 2);
    canvas.drawCircle(
      pusat,
      r * 1.75 * denyut,
      Paint()
        ..shader = RadialGradient(
          colors: [
            NumiWarna.cahaya.withValues(alpha: 0.45 * redup),
            NumiWarna.cahaya.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: pusat, radius: r * 1.75)),
    );

    _sayap(canvas, pusat, r);
    _antena(canvas, pusat, r, redup);

    // Ekor bercahaya di bawah tubuh, ciri kunang-kunang.
    final ekor = Offset(pusat.dx, pusat.dy + r * 0.95);
    canvas.drawCircle(
      ekor,
      r * 0.42,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: redup),
            NumiWarna.cahayaMuda.withValues(alpha: 0.9 * redup),
            NumiWarna.cahaya.withValues(alpha: 0),
          ],
          stops: const [0, 0.45, 1],
        ).createShader(Rect.fromCircle(center: ekor, radius: r * 0.42)),
    );

    canvas.drawCircle(
      pusat,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [_badan, _badanGelap],
        ).createShader(Rect.fromCircle(center: pusat, radius: r)),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: pusat.translate(0, r * 0.35),
        width: r * 1.1,
        height: r * 0.8,
      ),
      Paint()..color = _perut.withValues(alpha: 0.9),
    );

    _wajah(canvas, pusat, r);
  }

  void _sayap(Canvas canvas, Offset pusat, double r) {
    final kepak = sin(fase * 6) * 0.25;
    final cat = Paint()..color = Colors.white.withValues(alpha: 0.55);
    final garis = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.04;
    for (final arah in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(pusat.dx + arah * r * 0.55, pusat.dy - r * 0.55);
      canvas.rotate(arah * (0.6 + kepak));
      final bentuk = Rect.fromCenter(
        center: Offset(arah * r * 0.35, -r * 0.2),
        width: r * 0.9,
        height: r * 0.55,
      );
      canvas.drawOval(bentuk, cat);
      canvas.drawOval(bentuk, garis);
      canvas.restore();
    }
  }

  void _antena(Canvas canvas, Offset pusat, double r, double redup) {
    final tangkai = Paint()
      ..color = _mata
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.07;
    for (final arah in [-1.0, 1.0]) {
      final ayun = sin(fase + arah) * r * 0.06;
      final pangkal = Offset(pusat.dx + arah * r * 0.3, pusat.dy - r * 0.9);
      final ujung = Offset(
        pusat.dx + arah * r * 0.65 + ayun,
        pusat.dy - r * 1.55,
      );
      final jalur = Path()
        ..moveTo(pangkal.dx, pangkal.dy)
        ..quadraticBezierTo(
          pusat.dx + arah * r * 0.2,
          pusat.dy - r * 1.4,
          ujung.dx,
          ujung.dy,
        );
      canvas.drawPath(jalur, tangkai);
      canvas.drawCircle(
        ujung,
        r * 0.2,
        Paint()..color = NumiWarna.cahaya.withValues(alpha: 0.35 * redup),
      );
      canvas.drawCircle(ujung, r * 0.11, Paint()..color = NumiWarna.cahayaMuda);
    }
  }

  void _wajah(Canvas canvas, Offset pusat, double r) {
    final tinta = Paint()
      ..color = _mata
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = r * 0.08;
    final isi = Paint()..color = _mata;
    final mataY = pusat.dy - r * 0.15;
    final jarak = r * 0.38;

    for (final arah in [-1.0, 1.0]) {
      final m = Offset(pusat.dx + arah * jarak, mataY);
      switch (ekspresi) {
        case EkspresiMaskot.mengantuk:
          canvas.drawArc(
            Rect.fromCenter(center: m, width: r * 0.3, height: r * 0.18),
            0,
            pi,
            false,
            tinta,
          );
        case EkspresiMaskot.bangga:
          canvas.drawArc(
            Rect.fromCenter(center: m, width: r * 0.3, height: r * 0.26),
            pi,
            pi,
            false,
            tinta,
          );
        default:
          final tinggi = r * 0.34 * (1 - kedip * 0.9);
          canvas.drawOval(
            Rect.fromCenter(center: m, width: r * 0.26, height: tinggi),
            isi,
          );
          if (kedip < 0.5) {
            canvas.drawCircle(
              m.translate(r * 0.05, -r * 0.07),
              r * 0.05,
              Paint()..color = Colors.white,
            );
          }
      }
    }

    // Alis hanya muncul saat ekspresi butuh penegasan.
    if (ekspresi == EkspresiMaskot.sedih) {
      for (final arah in [-1.0, 1.0]) {
        final dalam = Offset(pusat.dx + arah * jarak * 0.55, mataY - r * 0.3);
        final luar = Offset(pusat.dx + arah * jarak * 1.35, mataY - r * 0.3);
        canvas.drawLine(
          dalam.translate(0, -r * 0.1),
          luar.translate(0, r * 0.1),
          tinta,
        );
      }
    } else if (ekspresi == EkspresiMaskot.semangat) {
      // Alis melengkung naik supaya terlihat bersemangat, bukan marah.
      for (final arah in [-1.0, 1.0]) {
        final pusatAlis = Offset(pusat.dx + arah * jarak, mataY - r * 0.36);
        canvas.drawArc(
          Rect.fromCenter(center: pusatAlis, width: r * 0.32, height: r * 0.18),
          pi,
          pi,
          false,
          tinta,
        );
      }
    }

    final pipi = Paint()..color = _pipi.withValues(alpha: 0.55);
    canvas.drawCircle(
      Offset(pusat.dx - r * 0.62, pusat.dy + r * 0.12),
      r * 0.12,
      pipi,
    );
    canvas.drawCircle(
      Offset(pusat.dx + r * 0.62, pusat.dy + r * 0.12),
      r * 0.12,
      pipi,
    );

    final mulut = Offset(pusat.dx, pusat.dy + r * 0.22);
    switch (ekspresi) {
      case EkspresiMaskot.senang:
        canvas.drawArc(
          Rect.fromCenter(center: mulut, width: r * 0.42, height: r * 0.3),
          0.15,
          pi - 0.3,
          false,
          tinta,
        );
      case EkspresiMaskot.bangga:
      case EkspresiMaskot.semangat:
        final jalur = Path()
          ..moveTo(mulut.dx - r * 0.24, mulut.dy - r * 0.04)
          ..quadraticBezierTo(
            mulut.dx,
            mulut.dy + r * 0.38,
            mulut.dx + r * 0.24,
            mulut.dy - r * 0.04,
          )
          ..close();
        canvas.drawPath(jalur, isi);
        canvas.drawCircle(
          mulut.translate(0, r * 0.13),
          r * 0.07,
          Paint()..color = const Color(0xFFFF7A85),
        );
      case EkspresiMaskot.berpikir:
        canvas.drawCircle(mulut.translate(r * 0.1, r * 0.02), r * 0.07, isi);
      case EkspresiMaskot.sedih:
        canvas.drawArc(
          Rect.fromCenter(
            center: mulut.translate(0, r * 0.12),
            width: r * 0.36,
            height: r * 0.24,
          ),
          pi + 0.2,
          pi - 0.4,
          false,
          tinta,
        );
      case EkspresiMaskot.mengantuk:
        canvas.drawOval(
          Rect.fromCenter(
            center: mulut.translate(0, r * 0.03),
            width: r * 0.16,
            height: r * 0.2,
          ),
          isi,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisNumi lama) =>
      lama.fase != fase || lama.kedip != kedip || lama.ekspresi != ekspresi;
}
