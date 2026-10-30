import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';

import '../models/data_belajar.dart';
import 'numi_repository.dart';

/// Menyimpan seluruh data belajar sebagai satu JSON di perangkat.
///
/// Demo tanpa UID memakai record terpisah dari cache akun wali.
class LocalNumiRepository implements NumiRepository {
  LocalNumiRepository(this._prefs, {this.database});

  static const _kunci = 'numi.data_belajar.v1';

  final SharedPreferences _prefs;
  final Database? database;
  final _record = StoreRef<String, String>('demo').record('belajar');

  @override
  Future<DataBelajar> muat() async {
    final db = database;
    final teks = db == null
        ? _prefs.getString(_kunci)
        : await _record.get(db) ?? _prefs.getString(_kunci);
    if (teks == null) return const DataBelajar();
    try {
      return DataBelajar.fromJson(jsonDecode(teks) as Map<String, dynamic>);
    } on FormatException {
      if (db != null) rethrow;
      return const DataBelajar();
    }
  }

  @override
  Future<void> simpan(DataBelajar data) async {
    final db = database;
    if (db != null) {
      await _record.put(db, jsonEncode(data.toJson()));
      return;
    }
    if (!await _prefs.setString(_kunci, jsonEncode(data.toJson()))) {
      throw StateError('Data belajar gagal disimpan di perangkat.');
    }
  }

  @override
  Future<void> hapus() async {
    final db = database;
    if (db != null) {
      // Tombstone mencegah data preferences lama muncul kembali setelah reset.
      await _record.put(db, jsonEncode(const DataBelajar().toJson()));
      return;
    }
    if (!await _prefs.remove(_kunci)) {
      throw StateError('Data belajar gagal dihapus dari perangkat.');
    }
  }
}
