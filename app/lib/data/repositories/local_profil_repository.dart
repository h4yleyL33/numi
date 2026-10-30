import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_belajar.dart';
import '../models/siswa.dart';
import 'numi_repository.dart';
import 'profil_repository.dart';

/// Cache lokal dipisahkan per UID; data legacy tanpa pemilik tidak dibaca di sini.
/// shortcut: belum sinkronisasi/durabilitas checkpoint, lengkapi adapter pada I08.
class LocalProfilRepository implements ProfilRepository {
  LocalProfilRepository(
    this._prefs, {
    required this.uid,
    required this.uidAktif,
  }) {
    if (uid.isEmpty) throw ArgumentError('UID wali wajib diisi.');
  }

  final SharedPreferences _prefs;
  final String uid;
  final String? Function() uidAktif;
  Future<void> _antrean = Future.value();
  String get _kunci => 'numi.wali.v1.${base64Url.encode(utf8.encode(uid))}';

  void _periksaAkun() {
    if (uidAktif() != uid) throw StateError('Sesi akun sudah berubah.');
  }

  Map<String, DataBelajar> _baca() {
    _periksaAkun();
    final teks = _prefs.getString(_kunci);
    if (teks == null) return {};
    final json = jsonDecode(teks) as Map<String, dynamic>;
    if (json['uid'] != uid || json['versi'] != 1) {
      throw const FormatException('Pemilik atau versi cache tidak sesuai.');
    }
    final profil = (json['profil'] as Map<String, dynamic>).map(
      (id, data) => MapEntry(
        id,
        DataBelajar.fromJson(Map<String, dynamic>.from(data as Map)),
      ),
    );
    for (final e in profil.entries) {
      if (e.value.siswa?.id != e.key || e.value.siswa?.waliUid != uid) {
        throw const FormatException('Identitas profil tidak sesuai.');
      }
    }
    return profil;
  }

  Future<T> _ubah<T>(T Function(Map<String, DataBelajar>) operasi) {
    final hasil = _antrean.then((_) async {
      final profil = _baca();
      final hasil = operasi(profil);
      _periksaAkun();
      final tersimpan = await _prefs.setString(
        _kunci,
        jsonEncode({
          'versi': 1,
          'uid': uid,
          'profil': profil.map((id, data) => MapEntry(id, data.toJson())),
        }),
      );
      if (!tersimpan) throw StateError('Profil belum tersimpan di perangkat.');
      _periksaAkun();
      return hasil;
    });
    _antrean = hasil.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return hasil;
  }

  @override
  Future<List<Siswa>> daftar() async =>
      _baca().values.map((d) => d.siswa!).toList();

  void _validasi(String nama, int kelas) {
    if (nama.trim().isEmpty || nama.trim().length > 30) {
      throw ArgumentError('Nama panggilan harus berisi 1 sampai 30 karakter.');
    }
    KelompokKelas.dariKelas(kelas);
  }

  @override
  Future<Siswa> tambah({required String nama, required int kelas}) =>
      _ubah((profil) {
        _validasi(nama, kelas);
        final waktu = DateTime.now();
        var nomor = waktu.microsecondsSinceEpoch;
        while (profil.containsKey('profil-$nomor')) {
          nomor++;
        }
        final siswa = Siswa(
          id: 'profil-$nomor',
          waliUid: uid,
          nama: nama.trim(),
          kelas: kelas,
          dibuatPada: waktu,
        );
        profil[siswa.id] = DataBelajar(siswa: siswa);
        return siswa;
      });

  @override
  Future<void> ubah(String id, {required String nama, required int kelas}) =>
      _ubah((profil) {
        _validasi(nama, kelas);
        final lama = profil[id];
        if (lama == null) throw StateError('Profil tidak ditemukan.');
        profil[id] = lama.copyWith(
          siswa: lama.siswa!.copyWith(nama: nama.trim(), kelas: kelas),
        );
      });

  @override
  NumiRepository untukProfil(String id, {bool Function()? masihAktif}) =>
      _DataProfilRepository(this, id, masihAktif ?? () => true);
}

class _DataProfilRepository implements NumiRepository {
  _DataProfilRepository(this.pemilik, this.id, this.masihAktif);
  final LocalProfilRepository pemilik;
  final String id;
  final bool Function() masihAktif;

  void _periksa() {
    if (!masihAktif()) throw StateError('Sesi profil sudah ditutup.');
    pemilik._periksaAkun();
  }

  @override
  Future<DataBelajar> muat() async {
    _periksa();
    final data = pemilik._baca()[id];
    if (data == null) throw StateError('Profil tidak ditemukan.');
    return data;
  }

  @override
  Future<void> simpan(DataBelajar data) async {
    _periksa();
    if (data.siswa?.id != id || data.siswa?.waliUid != pemilik.uid) {
      throw StateError('Data bukan milik profil aktif.');
    }
    await pemilik._ubah<void>((profil) {
      _periksa();
      if (!profil.containsKey(id)) throw StateError('Profil tidak ditemukan.');
      profil[id] = data;
    });
    _periksa();
  }

  @override
  Future<void> hapus() async {
    _periksa();
    await pemilik._ubah<void>((profil) {
      _periksa();
      final siswa = profil[id]?.siswa;
      if (siswa == null) throw StateError('Profil tidak ditemukan.');
      profil[id] = DataBelajar(siswa: siswa);
    });
    _periksa();
  }
}
