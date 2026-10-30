import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'akun_repository.dart';

/// Token hanya dipakai SDK dan tidak masuk model akun/profil atau cache belajar.
class FirebaseAkunRepository implements AkunRepository {
  FirebaseAkunRepository(this._auth, {GoogleSignIn? google, this.web = kIsWeb})
    : _google = google ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  final bool web;
  Future<void>? _inisialisasiGoogle;

  @override
  String? get uidAktif => _auth.currentUser?.uid;

  @override
  Stream<AkunWali?> get perubahanAkun => _auth.authStateChanges().map(
    (user) => user == null
        ? null
        : AkunWali(uid: user.uid, nama: user.displayName ?? 'Wali'),
  );

  @override
  Future<HasilMasuk> masukGoogle() async {
    try {
      if (web) {
        await _auth.signInWithPopup(
          GoogleAuthProvider()
            ..setCustomParameters({'prompt': 'select_account'}),
        );
      } else {
        const clientId = String.fromEnvironment('NUMI_GOOGLE_SERVER_CLIENT_ID');
        await (_inisialisasiGoogle ??= _google.initialize(
          serverClientId: clientId.isEmpty ? null : clientId,
        ));
        final user = await _google.authenticate();
        final token = user.authentication.idToken;
        if (token == null || token.isEmpty) {
          throw StateError('Google tidak mengembalikan identitas.');
        }
        await _auth.signInWithCredential(
          GoogleAuthProvider.credential(idToken: token),
        );
      }
      return HasilMasuk.berhasil;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return HasilMasuk.dibatalkan;
      }
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request' ||
          e.code == 'web-context-cancelled') {
        return HasilMasuk.dibatalkan;
      }
      rethrow;
    }
  }

  @override
  Future<void> keluar() async {
    // Akses Firebase ditutup dulu, walau pembersihan pilihan akun Google gagal.
    await _auth.signOut();
    if (!web && _inisialisasiGoogle != null) {
      try {
        await _google.signOut();
      } catch (_) {
        /* Firebase sudah keluar. */
      }
    }
  }
}
