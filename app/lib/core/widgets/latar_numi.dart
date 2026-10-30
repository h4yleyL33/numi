import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Ilustrasi asli Numi, dengan lapisan tenang agar teks tetap terbaca.
class LatarNumi extends StatelessWidget {
  const LatarNumi({super.key, required this.child, this.gelap = false});
  final Widget child;
  final bool gelap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, batas) => Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: Image.asset(
            batas.maxWidth > batas.maxHeight
                ? 'assets/images/numi-landscape.png'
                : 'assets/images/numi-portrait.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
        ),
        ColoredBox(
          color: (gelap ? NumiWarna.malam : NumiWarna.krem).withValues(
            alpha: gelap ? 0.84 : 0.93,
          ),
        ),
        child,
      ],
    ),
  );
}
