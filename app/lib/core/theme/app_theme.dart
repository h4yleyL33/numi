import 'package:flutter/material.dart';

/// Palet laut, krem, dan cahaya dari rancangan Numi.
class NumiWarna {
  NumiWarna._();

  static const malam = Color(0xFF174951);
  static const malamTerang = Color(0xFF287C88);
  static const laut = Color(0xFF238FA0);
  static const cahaya = Color(0xFFFFBF58);
  static const cahayaMuda = Color(0xFFFFD98A);
  static const krem = Color(0xFFFFF8E9);
  static const tinta = Color(0xFF19373D);
  static const tintaPudar = Color(0xFF536970);
  static const benar = Color(0xFF2EBD8E);
  static const benarMuda = Color(0xFFD7F5EA);
  static const salah = Color(0xFFFF6B6B);
  static const salahMuda = Color(0xFFFFE1E1);
  static const ungu = Color(0xFF7C5CFF);
  static const langit = Color(0xFF4FC3F7);
  static const kartu = Colors.white;
}

class NumiTema {
  NumiTema._();

  static ThemeData get terang {
    final dasar = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NumiWarna.cahaya,
        primary: NumiWarna.malam,
        secondary: NumiWarna.cahaya,
        surface: NumiWarna.krem,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );

    final teks = dasar.textTheme.apply(
      bodyColor: NumiWarna.tinta,
      displayColor: NumiWarna.tinta,
    );
    return dasar.copyWith(
      textTheme: teks.copyWith(
        displaySmall: teks.displaySmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        headlineMedium: teks.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: teks.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        titleLarge: teks.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: teks.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: teks.bodyLarge?.copyWith(fontSize: 17, height: 1.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
