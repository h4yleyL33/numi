import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_belajar.dart';
import 'numi_repository.dart';

/// Menyimpan seluruh data belajar sebagai satu JSON di perangkat.
///
/// Disimpan setiap kali satu aktivitas selesai, sehingga progres tidak hilang
/// walau aplikasi tertutup tiba-tiba (NFR-003).
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
  Future<void> simpan(DataBelajar data) => _prefs.setString(_kunci, jsonEncode(data.toJson()));

  @override
  Future<void> hapus() => _prefs.remove(_kunci);
}
