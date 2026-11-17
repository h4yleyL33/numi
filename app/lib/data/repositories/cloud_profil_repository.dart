import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../models/data_belajar.dart';

Object? _urutkanBidang(Object? nilai) {
  if (nilai is Map<String, dynamic>) {
    final kunci = nilai.keys.toList()..sort();
    return {for (final key in kunci) key: _urutkanBidang(nilai[key])};
  }
  if (nilai is List) return nilai.map(_urutkanBidang).toList();
  return nilai;
}

String sidikDataBelajar(DataBelajar data) => sha256
    .convert(utf8.encode(jsonEncode(_urutkanBidang(data.toJson()))))
    .toString();

abstract interface class CloudProfilRepository {
  Future<Map<String, DataBelajar>> daftar();
  Future<bool> simpan(DataBelajar data, {required String? versiDasar});
}

class FirestoreProfilRepository implements CloudProfilRepository {
  FirestoreProfilRepository(this._firestore, this.uid);

  final FirebaseFirestore _firestore;
  final String uid;

  CollectionReference<Map<String, dynamic>> get _profil =>
      _firestore.collection('wali').doc(uid).collection('profil');

  DataBelajar _baca(String id, Map<String, dynamic> isi) {
    final data = DataBelajar.fromJson(
      Map<String, dynamic>.from(isi['data'] as Map),
    );
    if (data.siswa?.id != id ||
        data.siswa?.waliUid != uid ||
        isi['versi'] != sidikDataBelajar(data)) {
      throw const FormatException('Snapshot cloud tidak sesuai dengan profil.');
    }
    return data;
  }

  @override
  Future<Map<String, DataBelajar>> daftar() async {
    final hasil = await _profil.get(const GetOptions(source: Source.server));
    return {for (final dok in hasil.docs) dok.id: _baca(dok.id, dok.data())};
  }

  @override
  Future<bool> simpan(DataBelajar data, {required String? versiDasar}) {
    final siswa = data.siswa;
    if (siswa == null || siswa.waliUid != uid) {
      throw ArgumentError('Data bukan milik wali aktif.');
    }
    final ref = _profil.doc(siswa.id);
    final isi = data.toJson();
    final versi = sidikDataBelajar(data);
    return _firestore.runTransaction((txn) async {
      final aktual = (await txn.get(ref)).data()?['versi'];
      if (aktual == versi) return true;
      if (aktual != versiDasar) return false;
      txn.set(_profil.parent!, {'uid': uid, 'versi': 1});
      txn.set(ref, {'versi': versi, 'dasar': versiDasar, 'data': isi});
      return true;
    });
  }
}
