import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/repositories/local_numi_repository.dart';
import 'data/repositories/local_profil_repository.dart';
import 'data/repositories/firebase_akun_repository.dart';
import 'features/account/akun_app.dart';
import 'features/account/masuk_screen.dart';
import 'firebase_options.dart';
import 'state/numi_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const demo = bool.fromEnvironment('NUMI_LOCAL_DEMO');
  if (!demo || kReleaseMode) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final akun = FirebaseAkunRepository(FirebaseAuth.instance);
      final prefs = await SharedPreferences.getInstance();
      runApp(
        AkunApp(
          akun: akun,
          profilUntuk: (wali) => LocalProfilRepository(
            prefs,
            uid: wali.uid,
            uidAktif: () => akun.uidAktif,
          ),
        ),
      );
    } catch (_) {
      runApp(const NumiApp(home: LayananAkunScreen()));
    }
    return;
  }

  // Demo pengembangan dipilih eksplisit, terpisah dari cache akun wali.
  final repository = LocalNumiRepository(await SharedPreferences.getInstance());
  final data = await repository.muat();

  runApp(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
        dataAwalProvider.overrideWithValue(data),
      ],
      child: const NumiApp(),
    ),
  );
}
