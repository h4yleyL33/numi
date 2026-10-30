import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_belajar.dart';
import 'numi_repository.dart';

/// Menyimpan seluruh data belajar sebagai satu JSON di perangkat.
///
/// Disimpan pada akhir aktivitas. Checkpoint per respons dan jaminan pemulihan
/// setelah proses berhenti memerlukan adapter durabel tersendiri (NFR-003).
class LocalNumiRepository implements NumiRepository {
  LocalNumiRepository(this._prefs);

  static const _kunci = 'numi.data_belajar.v1';

  final SharedPreferences _prefs;

  @override
  Future<DataBelajar> muat() async {
    final teks = _prefs.getString(_kunci);
    if (teks == null) return const DataBelajar();
    try {
      return DataBelajar.fromJson(jsonDecode(teks) as Map<String, dynamic>);
    } on FormatException {
      return const DataBelajar();
    }
  }

  @override
  Future<void> simpan(DataBelajar data) async {
    if (!await _prefs.setString(_kunci, jsonEncode(data.toJson()))) {
      throw StateError('Data belajar gagal disimpan di perangkat.');
    }
  }

  @override
  Future<void> hapus() async {
    if (!await _prefs.remove(_kunci)) {
      throw StateError('Data belajar gagal dihapus dari perangkat.');
    }
  }
}
