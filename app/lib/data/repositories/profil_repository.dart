import '../models/siswa.dart';
import 'numi_repository.dart';

/// Satu instance terikat pada UID wali yang terautentikasi.
abstract interface class ProfilRepository {
  Future<List<Siswa>> daftar();
  Future<Siswa> tambah({required String nama, required int kelas});
  Future<void> ubah(String id, {required String nama, required int kelas});
  NumiRepository untukProfil(String id, {bool Function()? masihAktif});
}
