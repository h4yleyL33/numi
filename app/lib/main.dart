import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/repositories/cloud_profil_repository.dart';
import 'data/repositories/local_numi_repository.dart';
import 'data/repositories/buka_database.dart';
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
      const hostEmulator = String.fromEnvironment(
        'NUMI_FIREBASE_EMULATOR_HOST',
      );
      final pakaiEmulator = kDebugMode && hostEmulator.isNotEmpty;
      final firebase = await Firebase.initializeApp(
        name: pakaiEmulator ? 'numi-emulator' : null,
        options: pakaiEmulator
            ? DefaultFirebaseOptions.emulator
            : DefaultFirebaseOptions.currentPlatform,
      );
      final auth = FirebaseAuth.instanceFor(app: firebase);
      final firestore = FirebaseFirestore.instanceFor(app: firebase);
      // Sembast adalah cache ber-UID. Jangan membuat cache disk Firestore kedua.
      firestore.settings = const Settings(persistenceEnabled: false);
      if (pakaiEmulator) {
        await auth.useAuthEmulator(hostEmulator, 9099);
        firestore.useFirestoreEmulator(hostEmulator, 8080);
      }
      final akun = FirebaseAkunRepository(auth);
      final prefs = await SharedPreferences.getInstance();
      runApp(
        AkunApp(
          akun: akun,
          profilUntuk: (wali) => LocalProfilRepository(
            prefs,
            uid: wali.uid,
            uidAktif: () => akun.uidAktif,
            cloud: FirestoreProfilRepository(firestore, wali.uid),
            databaseUntuk: () => bukaDatabase(
              'numi-wali-v1-${base64Url.encode(utf8.encode(wali.uid))}',
            ),
          ),
        ),
      );
    } catch (_) {
      runApp(const NumiApp(home: LayananAkunScreen()));
    }
    return;
  }

  // Demo pengembangan dipilih eksplisit, terpisah dari cache akun wali.
  final repository = LocalNumiRepository(
    await SharedPreferences.getInstance(),
    database: await bukaDatabase(),
  );
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
