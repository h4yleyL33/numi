import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bilah progres membulat yang mengisi dengan animasi pegas.
class BilahProgres extends StatelessWidget {
  const BilahProgres({
    super.key,
    required this.nilai,
    this.tinggi = 16,
    this.warna = NumiWarna.cahaya,
    this.latar = const Color(0xFFEDE7DA),
  });

  final double nilai;
  final double tinggi;
  final Color warna;
  final Color latar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(tinggi),
      child: SizedBox(
        height: tinggi,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: latar)),
            TweenAnimationBuilder<double>(
              tween: Tween(end: nilai.clamp(0, 1)),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              builder: (context, v, _) => FractionallySizedBox(
                widthFactor: v.clamp(0, 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.circular(tinggi),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(tinggi * 0.4, tinggi * 0.18, tinggi * 0.4, 0),
                      height: tinggi * 0.22,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(tinggi),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
