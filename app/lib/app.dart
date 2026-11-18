import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/krayon.dart';
import 'features/onboarding/splash_screen.dart';

class NumiApp extends StatelessWidget {
  const NumiApp({super.key, this.home, this.bilahWali, this.navigatorKey});

  final Widget? home;
  final Widget? bilahWali;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Numi',
      debugShowCheckedModeBanner: false,
      theme: NumiTema.terang,
      builder: (context, child) => LatarKrayon(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                ?bilahWali,
                Expanded(child: child!),
              ],
            ),
          ),
        ),
      ),
      home: home ?? const SplashScreen(),
    );
  }
}
