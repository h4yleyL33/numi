class AkunWali {
  const AkunWali({required this.uid, required this.nama});
  final String uid;
  final String nama;
}

enum HasilMasuk { berhasil, dibatalkan }

abstract interface class AkunRepository {
  String? get uidAktif;
  Stream<AkunWali?> get perubahanAkun;
  Future<HasilMasuk> masukGoogle();
  Future<void> keluar();
}
