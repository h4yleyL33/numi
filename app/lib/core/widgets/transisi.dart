import 'package:flutter/material.dart';

Route<T> transisiPudar<T>(Widget halaman) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim, _) => halaman,
      transitionsBuilder: (context, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
    );

Route<T> transisiNaik<T>(Widget halaman) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (context, anim, _) => halaman,
      transitionsBuilder: (context, anim, _, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
