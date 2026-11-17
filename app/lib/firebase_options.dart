import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    // Android membaca resources yang dihasilkan plugin Google Services.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) return null;
    if (kIsWeb) {
      const apiKey = String.fromEnvironment('NUMI_FIREBASE_API_KEY');
      const appId = String.fromEnvironment('NUMI_FIREBASE_APP_ID');
      const projectId = String.fromEnvironment('NUMI_FIREBASE_PROJECT_ID');
      const senderId = String.fromEnvironment('NUMI_FIREBASE_SENDER_ID');
      const authDomain = String.fromEnvironment('NUMI_FIREBASE_AUTH_DOMAIN');
      if ([
        apiKey,
        appId,
        projectId,
        senderId,
        authDomain,
      ].every((nilai) => nilai.isNotEmpty)) {
        return const FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: senderId,
          projectId: projectId,
          authDomain: authDomain,
        );
      }
    }
    throw UnsupportedError('Konfigurasi Firebase Numi belum tersedia.');
  }

  static const emulator = FirebaseOptions(
    apiKey: 'demo-numi-key',
    appId: '1:1234567890:web:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'demo-numi',
  );
}
