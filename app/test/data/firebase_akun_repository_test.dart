import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:numi/data/repositories/akun_repository.dart';
import 'package:numi/data/repositories/firebase_akun_repository.dart';

class _User extends Fake implements User {
  @override
  String get uid => 'wali-a';
  @override
  String? get displayName => 'Wali';
}

class _Credential extends Fake implements UserCredential {}

class _Firebase extends Fake implements FirebaseAuth {
  User? user;
  FirebaseAuthException? galat;
  int kredensialDiterima = 0;
  @override
  User? get currentUser => user;
  @override
  Stream<User?> authStateChanges() => Stream.value(user);
  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async {
    if (galat != null) throw galat!;
    user = _User();
    return _Credential();
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (galat != null) throw galat!;
    kredensialDiterima++;
    user = _User();
    return _Credential();
  }

  @override
  Future<void> signOut() async => user = null;
}

class _GoogleUser extends Fake implements GoogleSignInAccount {
  _GoogleUser(this.token);
  final String? token;
  @override
  GoogleSignInAuthentication get authentication =>
      GoogleSignInAuthentication(idToken: token);
}

class _Google extends Fake implements GoogleSignIn {
  int inisialisasi = 0;
  bool batal = false;
  bool gagalKeluar = false;
  String? token = 'token-khusus-pengujian';
  @override
  Future<void> initialize({
    String? clientId,
    String? serverClientId,
    String? nonce,
    String? hostedDomain,
  }) async {
    inisialisasi++;
  }

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const [],
  }) async {
    if (batal) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
      );
    }
    return _GoogleUser(token);
  }

  @override
  Future<void> signOut() async {
    if (gagalKeluar) throw StateError('Pembersihan Google gagal');
  }
}

void main() {
  test('batal popup web dibedakan dari galat jaringan', () async {
    final firebase = _Firebase()
      ..galat = FirebaseAuthException(code: 'popup-closed-by-user');
    final repo = FirebaseAkunRepository(firebase, web: true);
    expect(await repo.masukGoogle(), HasilMasuk.dibatalkan);
    expect(repo.uidAktif, isNull);
    firebase.galat = FirebaseAuthException(code: 'network-request-failed');
    await expectLater(
      repo.masukGoogle(),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('batal native tidak membentuk sesi Firebase', () async {
    final firebase = _Firebase();
    final google = _Google()..batal = true;
    final repo = FirebaseAkunRepository(firebase, google: google, web: false);
    expect(await repo.masukGoogle(), HasilMasuk.dibatalkan);
    expect(firebase.kredensialDiterima, 0);
    expect(repo.uidAktif, isNull);
  });

  test('token kosong ditolak sebelum membentuk sesi Firebase', () async {
    final firebase = _Firebase();
    final repo = FirebaseAkunRepository(
      firebase,
      google: _Google()..token = null,
      web: false,
    );
    await expectLater(repo.masukGoogle(), throwsStateError);
    expect(firebase.kredensialDiterima, 0);
  });

  test(
    'native memakai identitas Firebase dan menginisialisasi Google sekali',
    () async {
      final firebase = _Firebase();
      final google = _Google();
      final repo = FirebaseAkunRepository(firebase, google: google, web: false);
      expect(await repo.masukGoogle(), HasilMasuk.berhasil);
      expect(repo.uidAktif, 'wali-a');
      final akun = await repo.perubahanAkun.first;
      expect(akun!.uid, 'wali-a');
      expect(akun.nama, 'Wali');
      await repo.keluar();
      await repo.masukGoogle();
      expect(google.inisialisasi, 1);
    },
  );

  test(
    'kegagalan pembersihan Google tidak membiarkan Firebase tetap masuk',
    () async {
      final firebase = _Firebase();
      final google = _Google()..gagalKeluar = true;
      final repo = FirebaseAkunRepository(firebase, google: google, web: false);
      await repo.masukGoogle();
      await repo.keluar();
      expect(repo.uidAktif, isNull);
      expect(await repo.perubahanAkun.first, isNull);
    },
  );
}
