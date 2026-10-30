import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/latar_numi.dart';
import 'features/onboarding/splash_screen.dart';

class NumiApp extends StatelessWidget {
  const NumiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numi',
      debugShowCheckedModeBanner: false,
      theme: NumiTema.terang,
      builder: (context, child) => LatarNumi(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child!,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
