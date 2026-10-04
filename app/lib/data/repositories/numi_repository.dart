import '../models/data_belajar.dart';

/// Pintu penyimpanan data belajar.
///
/// Aplikasi hanya bergantung pada kontrak ini. Saat ini implementasinya
/// LocalNumiRepository (penyimpanan di perangkat). Setelah proyek Firebase tim
/// dibuat, cukup tambahkan FirestoreNumiRepository yang memenuhi kontrak yang
/// sama, tanpa mengubah layar maupun logika belajar.
abstract interface class NumiRepository {
  Future<DataBelajar> muat();
  Future<void> simpan(DataBelajar data);
  Future<void> hapus();
}
