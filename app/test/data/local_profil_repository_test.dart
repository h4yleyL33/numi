import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';

class _PreferensiTertunda extends Fake implements SharedPreferences {
  final isi = <String, String>{};
  Completer<void>? tunggu;
  bool gagal = false;
  @override
  String? getString(String key) => isi[key];
  @override
  Future<bool> setString(String key, String value) async {
    await tunggu?.future;
    if (gagal) return false;
    isi[key] = value;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  String? uid;

  LocalProfilRepository repo(String pemilik) =>
      LocalProfilRepository(prefs, uid: pemilik, uidAktif: () => uid);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    uid = 'wali-a';
  });

  test('tulis tertunda saat logout tidak diterbitkan ke akun baru', () async {
    final prefs = _PreferensiTertunda();
    final a = LocalProfilRepository(prefs, uid: 'wali-a', uidAktif: () => uid);
    prefs.tunggu = Completer<void>();
    final simpan = a.tambah(nama: 'Sari', kelas: 1);
    final pemeriksaan = expectLater(simpan, throwsStateError);
    await Future<void>.delayed(Duration.zero);
    uid = 'wali-b';
    prefs.tunggu!.complete();
    await pemeriksaan;
    final b = LocalProfilRepository(prefs, uid: 'wali-b', uidAktif: () => uid);
    expect(await b.daftar(), isEmpty);
  });

  test(
    'sesi profil yang sudah ditutup menolak akses dan simpan lama',
    () async {
      final a = repo('wali-a');
      final sari = await a.tambah(nama: 'Sari', kelas: 1);
      var aktif = true;
      final sesi = a.untukProfil(sari.id, masihAktif: () => aktif);
      final lama = await sesi.muat();
      aktif = false;
      await expectLater(sesi.simpan(lama.copyWith(xp: 120)), throwsStateError);
      await expectLater(sesi.muat(), throwsStateError);
      expect((await a.untukProfil(sari.id).muat()).xp, 0);
    },
  );

  test(
    'gagal tulis menahan perubahan dan antrean tetap bisa dipakai untuk retry',
    () async {
      final prefs = _PreferensiTertunda()..gagal = true;
      final a = LocalProfilRepository(
        prefs,
        uid: 'wali-a',
        uidAktif: () => uid,
      );
      await expectLater(a.tambah(nama: 'Sari', kelas: 1), throwsStateError);
      expect(await a.daftar(), isEmpty);
      prefs.gagal = false;
      await a.tambah(nama: 'Sari', kelas: 1);
      expect(await a.daftar(), hasLength(1));
    },
  );

  test(
    'tanpa login dan UID berbeda tidak dapat membuka daftar atau data profil',
    () async {
      final a = repo('wali-a');
      final anak = await a.tambah(nama: 'Sari', kelas: 2);
      uid = null;
      await expectLater(a.daftar(), throwsStateError);
      await expectLater(a.untukProfil(anak.id).muat(), throwsStateError);
      uid = 'wali-b';
      expect(await repo('wali-b').daftar(), isEmpty);
      await expectLater(a.daftar(), throwsStateError);
    },
  );

  test('dua profil mempertahankan riwayat sendiri saat kelas diubah dan data dimuat ulang', () async {
    final a = repo('wali-a');
    final sari = await a.tambah(nama: 'Sari', kelas: 2);
    final budi = await a.tambah(nama: 'Budi', kelas: 6);
    final dataSari = a.untukProfil(sari.id);
    await dataSari.simpan((await dataSari.muat()).copyWith(xp: 120));
    await a.ubah(sari.id, nama: 'Sari Baru', kelas: 3);
    final pulih = repo('wali-a');
    expect(await pulih.daftar(), hasLength(2));
    expect((await pulih.untukProfil(sari.id).muat()).xp, 120);
    expect((await pulih.untukProfil(sari.id).muat()).siswa!.kelas, 3);
    expect((await pulih.untukProfil(budi.id).muat()).xp, 0);
  });

  test(
    'data profil lain tidak dapat ditulis ke konteks profil aktif',
    () async {
      final a = repo('wali-a');
      final sari = await a.tambah(nama: 'Sari', kelas: 1);
      final budi = await a.tambah(nama: 'Budi', kelas: 4);
      await expectLater(
        a.untukProfil(sari.id).simpan(await a.untukProfil(budi.id).muat()),
        throwsStateError,
      );
    },
  );

  test(
    'penambahan serentak tidak saling menimpa dan nama/kelas tidak sah ditolak',
    () async {
      final a = repo('wali-a');
      await Future.wait([
        a.tambah(nama: 'Sari', kelas: 1),
        a.tambah(nama: 'Budi', kelas: 2),
      ]);
      expect(await a.daftar(), hasLength(2));
      await expectLater(a.tambah(nama: ' ', kelas: 1), throwsArgumentError);
      await expectLater(a.tambah(nama: 'Sari', kelas: 7), throwsRangeError);
    },
  );

  test('reset progres menjaga identitas profil dan profil saudara', () async {
    final a = repo('wali-a');
    final sari = await a.tambah(nama: 'Sari', kelas: 1);
    final budi = await a.tambah(nama: 'Budi', kelas: 4);
    final belajar = a.untukProfil(sari.id);
    await belajar.simpan((await belajar.muat()).copyWith(xp: 120));
    await belajar.hapus();
    expect((await belajar.muat()).siswa!.id, sari.id);
    expect((await belajar.muat()).xp, 0);
    expect((await a.untukProfil(budi.id).muat()).siswa!.id, budi.id);
  });

  test('cache rusak ditampilkan sebagai galat dan tidak ditimpa', () async {
    final a = repo('wali-a');
    await a.tambah(nama: 'Sari', kelas: 1);
    final key = prefs.getKeys().single;
    await prefs.setString(key, '{rusak');
    await expectLater(a.daftar(), throwsFormatException);
    await expectLater(a.tambah(nama: 'Budi', kelas: 2), throwsFormatException);
    expect(prefs.getString(key), '{rusak');
  });
}
