import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../../core/config/app_config.dart';
import '../models/bukti_skill.dart';
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
  Future<DaftarProfilCloud> daftar();
  Future<bool> simpan(DataBelajar data, {required String? versiDasar});
}

class DaftarProfilCloud {
  const DaftarProfilCloud(this.profil, {this.tidakValid = const {}});

  final Map<String, DataBelajar> profil;
  final Set<String> tidakValid;

  factory DaftarProfilCloud.urai(
    String uid,
    Map<String, Map<String, dynamic>> dokumen,
  ) {
    final profil = <String, DataBelajar>{};
    final tidakValid = <String>{};
    for (final e in dokumen.entries) {
      try {
        final data = DataBelajar.fromJson(
          Map<String, dynamic>.from(e.value['data'] as Map),
        );
        final maksXp =
            data.progresLesson.values.fold<int>(
              0,
              (n, l) =>
                  n +
                  l.jumlahPercobaan *
                      (AppConfig.soalPerLesson * AppConfig.xpPerBenar +
                          AppConfig.xpLessonSelesai),
            ) +
            data.hasilMastery.length *
                (AppConfig.soalMastery * AppConfig.xpPerBenar +
                    AppConfig.xpMasteryLulus);
        if (data.siswa?.id != e.key ||
            data.siswa?.waliUid != uid ||
            e.value['versi'] != sidikDataBelajar(data) ||
            data.xp < 0 ||
            data.xp > maksXp ||
            data.progresLesson.values.any((l) => l.jumlahPercobaan < 1) ||
            data.buktiSkill.values.any(
              (b) =>
                  b.status == StatusBukti.buktiAwal &&
                  !data.hasilMastery.any(
                    (h) => h.topikId == b.topikId && h.lulus && h.skor == 100,
                  ),
            )) {
          throw const FormatException('Snapshot cloud tidak sesuai profil.');
        }
        profil[e.key] = data;
      } on FormatException {
        tidakValid.add(e.key);
      } on TypeError {
        tidakValid.add(e.key);
      } on ArgumentError {
        tidakValid.add(e.key);
      } on StateError {
        tidakValid.add(e.key);
      }
    }
    return DaftarProfilCloud(profil, tidakValid: tidakValid);
  }
}

class FirestoreProfilRepository implements CloudProfilRepository {
  FirestoreProfilRepository(this._firestore, this.uid);

  final FirebaseFirestore _firestore;
  final String uid;

  CollectionReference<Map<String, dynamic>> get _profil =>
      _firestore.collection('wali').doc(uid).collection('profil');

  @override
  Future<DaftarProfilCloud> daftar() async {
    final hasil = await _profil.get(const GetOptions(source: Source.server));
    return DaftarProfilCloud.urai(uid, {
      for (final dok in hasil.docs) dok.id: dok.data(),
    });
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
    if (DaftarProfilCloud.urai(uid, {
      siswa.id: {'data': isi, 'versi': versi},
    }).tidakValid.isNotEmpty) {
      throw const FormatException(
        'Data belajar belum sesuai untuk sinkronisasi.',
      );
    }
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
