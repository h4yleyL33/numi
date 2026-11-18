import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';

import '../models/data_belajar.dart';
import '../models/siswa.dart';
import 'cloud_profil_repository.dart';
import 'numi_repository.dart';
import 'profil_repository.dart';

/// Cache lokal dipisahkan per UID; data legacy tanpa pemilik tidak dibaca di sini.
/// Database menjadi sumber utama; preferences hanya sumber migrasi cache ber-UID.
class LocalProfilRepository implements ProfilRepository {
  LocalProfilRepository(
    this._prefs, {
    required this.uid,
    required this.uidAktif,
    this.database,
    this.databaseUntuk,
    this.cloud,
  }) {
    if (uid.isEmpty) throw ArgumentError('UID wali wajib diisi.');
  }

  final SharedPreferences _prefs;
  final Database? database;
  final Future<Database> Function()? databaseUntuk;
  final CloudProfilRepository? cloud;
  Database? _terbuka;

  Future<Database?> _db() async {
    if (database != null) return database;
    final buka = databaseUntuk;
    if (buka == null) return null;
    return _terbuka ??= await buka();
  }

  final _store = StoreRef<String, String>('wali');
  final _metadata = stringMapStoreFactory.store('sinkron-profil');
  final String uid;
  final String? Function() uidAktif;
  Future<void> _antrean = Future.value();
  String get _kunci => 'numi.wali.v1.${base64Url.encode(utf8.encode(uid))}';
  String get _kunciIzinCloud => '$_kunci.izinCloud';
  bool get cloudAktif => _prefs.getBool(_kunciIzinCloud) ?? false;
  Future<HasilSinkronProfil>? _sinkronBerjalan;
  HasilSinkronProfil hasilSinkron = HasilSinkronProfil.lokal;
  final _konflik = <String, KonflikProfil>{};
  List<KonflikProfil> get konflik => List.unmodifiable(_konflik.values);

  Future<void> aturCloud(bool aktif) async {
    _periksaAkun();
    if (!await _prefs.setBool(_kunciIzinCloud, aktif)) {
      throw StateError('Izin sinkronisasi belum tersimpan.');
    }
  }

  void kirimKeCloud() {
    if (cloudAktif && uidAktif() == uid) {
      unawaited(sinkron(tarik: false));
    }
  }

  Future<HasilSinkronProfil> sinkron({required bool tarik}) async {
    // Mode tarik hanya dipanggil ketika layar pemilih profil menahan navigasi.
    if (tarik && _sinkronBerjalan != null) await _sinkronBerjalan;
    return _sinkronBerjalan ??= _jalankanSinkron(tarik)
        .then((hasil) => hasilSinkron = hasil)
        .whenComplete(() => _sinkronBerjalan = null);
  }

  Future<HasilSinkronProfil> _jalankanSinkron(bool tarik) async {
    final server = cloud;
    if (server == null || !cloudAktif || uidAktif() != uid) {
      return HasilSinkronProfil.lokal;
    }
    try {
      final db = await _db();
      if (db == null) return HasilSinkronProfil.tertunda;
      final lokal = await _baca();
      final hasilCloud = await server.daftar();
      final remote = hasilCloud.profil;
      _konflik.clear();
      var konflik = false;
      var adaPembaruanCloud = false;
      for (final id in {...lokal.keys, ...remote.keys}) {
        _periksaAkun();
        if (!cloudAktif) return HasilSinkronProfil.lokal;
        // Snapshot rusak bukan profil yang dihapus; jangan unggah menimpanya.
        if (hasilCloud.tidakValid.contains(id)) continue;
        final data = lokal[id];
        final dataCloud = remote[id];
        final versiLokal = data == null ? null : sidikDataBelajar(data);
        final versiCloud = dataCloud == null
            ? null
            : sidikDataBelajar(dataCloud);
        final record = _metadata.record(id);
        final metadata = await record.get(db);
        final sedangDikirim = metadata?['dikirim'];
        final dasar = sedangDikirim != null && sedangDikirim == versiCloud
            ? versiCloud
            : metadata?['dasar'] as String?;

        if (versiLokal == versiCloud) {
          await record.put(db, {'dasar': versiCloud});
        } else if (dataCloud != null && (data == null || versiLokal == dasar)) {
          if (!tarik) {
            adaPembaruanCloud = true;
            continue;
          }
          final dipulihkan = await db.transaction((txn) async {
            final profil = _urai(
              await _store.record(uid).get(txn) ?? _prefs.getString(_kunci),
            );
            final terkini = profil[id];
            if ((terkini == null ? null : sidikDataBelajar(terkini)) !=
                versiLokal) {
              return false;
            }
            if (!cloudAktif) return false;
            profil[id] = dataCloud;
            await _store.record(uid).put(txn, _enkode(profil));
            await record.put(txn, {'dasar': versiCloud});
            return true;
          });
          konflik = konflik || !dipulihkan;
        } else if (data != null && versiCloud == dasar) {
          await record.put(db, {'dasar': dasar, 'dikirim': versiLokal});
          _periksaAkun();
          if (!cloudAktif) return HasilSinkronProfil.lokal;
          if (await server.simpan(data, versiDasar: dasar)) {
            await record.put(db, {'dasar': versiLokal});
          } else {
            konflik = true;
          }
        } else {
          konflik = true;
          if (data != null && dataCloud != null) {
            _konflik[id] = KonflikProfil(data, dataCloud);
          }
        }
      }
      if (hasilCloud.tidakValid.isNotEmpty) {
        return HasilSinkronProfil.dataTidakValid;
      }
      if (konflik) return HasilSinkronProfil.konflik;
      if (adaPembaruanCloud) return HasilSinkronProfil.tertunda;
      return HasilSinkronProfil.selesai;
    } on FormatException {
      return HasilSinkronProfil.dataTidakValid;
    } catch (_) {
      return HasilSinkronProfil.tertunda;
    }
  }

  Future<HasilSinkronProfil> selesaikanKonflik(
    KonflikProfil pilihan, {
    required bool gunakanCloud,
  }) async {
    if (_sinkronBerjalan != null) await _sinkronBerjalan;
    return _sinkronBerjalan = _selesaikanKonflik(pilihan, gunakanCloud)
        .then((hasil) => hasilSinkron = hasil)
        .whenComplete(() => _sinkronBerjalan = null);
  }

  Future<HasilSinkronProfil> _selesaikanKonflik(
    KonflikProfil pilihan,
    bool gunakanCloud,
  ) async {
    _periksaAkun();
    final server = cloud;
    final db = await _db();
    if (!cloudAktif ||
        server == null ||
        db == null ||
        pilihan.lokal.siswa?.waliUid != uid ||
        pilihan.cloud.siswa?.waliUid != uid) {
      throw StateError('Sinkronisasi atau akun sudah berubah.');
    }
    final id = pilihan.lokal.siswa!.id;
    final versiLokal = sidikDataBelajar(pilihan.lokal);
    final versiCloud = sidikDataBelajar(pilihan.cloud);
    final terbaru = (await server.daftar()).profil[id];
    _periksaAkun();
    if (terbaru == null || sidikDataBelajar(terbaru) != versiCloud) {
      throw StateError('Versi cloud berubah. Sinkronkan lagi sebelum memilih.');
    }
    final record = _metadata.record(id);
    await db.transaction((txn) async {
      _periksaAkun();
      if (!cloudAktif) throw StateError('Sinkronisasi sudah dimatikan.');
      final profil = _urai(
        await _store.record(uid).get(txn) ?? _prefs.getString(_kunci),
      );
      final lokal = profil[id];
      if (lokal == null || sidikDataBelajar(lokal) != versiLokal) {
        throw StateError(
          'Versi perangkat berubah. Sinkronkan lagi sebelum memilih.',
        );
      }
      await stringMapStoreFactory
          .store('cadangan-konflik')
          .record('$id-${DateTime.now().microsecondsSinceEpoch}')
          .put(txn, {
            'lokal': pilihan.lokal.toJson(),
            'cloud': pilihan.cloud.toJson(),
          });
      if (gunakanCloud) {
        profil[id] = terbaru;
        await _store.record(uid).put(txn, _enkode(profil));
        await record.put(txn, {'dasar': versiCloud});
      } else {
        await record.put(txn, {'dasar': versiCloud, 'dikirim': versiLokal});
      }
    });
    if (!gunakanCloud) {
      _periksaAkun();
      if (!cloudAktif) throw StateError('Sinkronisasi sudah dimatikan.');
      if (!await server.simpan(pilihan.lokal, versiDasar: versiCloud)) {
        throw StateError(
          'Versi cloud berubah. Sinkronkan lagi sebelum memilih.',
        );
      }
      await record.put(db, {'dasar': versiLokal});
    }
    return _jalankanSinkron(true);
  }

  void _periksaAkun() {
    if (uidAktif() != uid) throw StateError('Sesi akun sudah berubah.');
  }

  Map<String, DataBelajar> _urai(String? teks) {
    _periksaAkun();
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

  Future<Map<String, DataBelajar>> _baca() async {
    _periksaAkun();
    final db = await _db();
    final teks = db == null
        ? _prefs.getString(_kunci)
        : await _store.record(uid).get(db) ?? _prefs.getString(_kunci);
    return _urai(teks);
  }

  String _enkode(Map<String, DataBelajar> profil) => jsonEncode({
    'versi': 1,
    'uid': uid,
    'profil': profil.map((id, data) => MapEntry(id, data.toJson())),
  });

  Future<T> _ubah<T>(T Function(Map<String, DataBelajar>) operasi) {
    final hasil = _antrean.then((_) async {
      _periksaAkun();
      final db = await _db();
      if (db != null) {
        final hasil = await db.transaction((txn) async {
          final profil = _urai(
            await _store.record(uid).get(txn) ?? _prefs.getString(_kunci),
          );
          final hasil = operasi(profil);
          _periksaAkun();
          await _store.record(uid).put(txn, _enkode(profil));
          return hasil;
        });
        _periksaAkun();
        return hasil;
      }
      final profil = await _baca();
      final hasil = operasi(profil);
      _periksaAkun();
      final tersimpan = await _prefs.setString(_kunci, _enkode(profil));
      if (!tersimpan) throw StateError('Profil belum tersimpan di perangkat.');
      _periksaAkun();
      return hasil;
    });
    _antrean = hasil.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return hasil;
  }

  @override
  Future<List<Siswa>> daftar() async =>
      (await _baca()).values.map((d) => d.siswa!).toList();

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

enum HasilSinkronProfil { lokal, selesai, tertunda, konflik, dataTidakValid }

class KonflikProfil {
  const KonflikProfil(this.lokal, this.cloud);
  final DataBelajar lokal;
  final DataBelajar cloud;
}

class _DataProfilRepository implements NumiRepository {
  _DataProfilRepository(this.pemilik, this.id, this.masihAktif);
  final LocalProfilRepository pemilik;
  final String id;
  final bool Function() masihAktif;
  String? _terakhir;

  void _periksa() {
    if (!masihAktif()) throw StateError('Sesi profil sudah ditutup.');
    pemilik._periksaAkun();
  }

  @override
  Future<DataBelajar> muat() async {
    _periksa();
    final data = (await pemilik._baca())[id];
    if (data == null) throw StateError('Profil tidak ditemukan.');
    _periksa();
    _terakhir = jsonEncode(data.toJson());
    return data;
  }

  @override
  Future<void> simpan(DataBelajar data) async {
    _periksa();
    final sebelum = _terakhir;
    if (data.siswa?.id != id || data.siswa?.waliUid != pemilik.uid) {
      throw StateError('Data bukan milik profil aktif.');
    }
    await pemilik._ubah<void>((profil) {
      _periksa();
      if (!profil.containsKey(id)) throw StateError('Profil tidak ditemukan.');
      final aktual = jsonEncode(profil[id]!.toJson());
      if (sebelum == null ||
          (aktual != sebelum && aktual != jsonEncode(data.toJson()))) {
        throw StateError('Data berubah pada sesi lain. Buka ulang profil.');
      }
      profil[id] = data;
    });
    _periksa();
    _terakhir = jsonEncode(data.toJson());
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
