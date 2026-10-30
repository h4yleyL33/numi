import 'package:firebase_core/firebase_core.dart';

/// Diganti oleh `flutterfire configure` setelah proyek Firebase tim tersedia.
/// Tidak memakai project ID atau kunci contoh yang dapat tersambung tanpa sengaja.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'Firebase Numi belum dikonfigurasi. Jalankan flutterfire configure.',
  );
}
