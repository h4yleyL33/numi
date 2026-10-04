import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/splash_screen.dart';

class NumiApp extends StatelessWidget {
  const NumiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numi',
      debugShowCheckedModeBanner: false,
      theme: NumiTema.terang,
      home: const SplashScreen(),
    );
  }
}
