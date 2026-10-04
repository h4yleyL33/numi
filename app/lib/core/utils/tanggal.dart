/// Tanggal disimpan sebagai teks `yyyy-mm-dd` supaya streak dihitung per hari
/// kalender, bukan per 24 jam.
String kunciTanggal(DateTime waktu) {
  final t = DateTime(waktu.year, waktu.month, waktu.day);
  final bulan = t.month.toString().padLeft(2, '0');
  final hari = t.day.toString().padLeft(2, '0');
  return '${t.year}-$bulan-$hari';
}

DateTime dariKunciTanggal(String kunci) {
  final bagian = kunci.split('-').map(int.parse).toList();
  return DateTime(bagian[0], bagian[1], bagian[2]);
}

int selisihHari(DateTime dari, DateTime ke) {
  final a = DateTime(dari.year, dari.month, dari.day);
  final b = DateTime(ke.year, ke.month, ke.day);
  return b.difference(a).inHours ~/ 24;
}

/// 12500 menjadi "12.500", mengikuti penulisan angka di buku pelajaran SD.
String formatAngka(int angka) {
  final teks = angka.abs().toString();
  final hasil = StringBuffer();
  for (var i = 0; i < teks.length; i++) {
    if (i > 0 && (teks.length - i) % 3 == 0) hasil.write('.');
    hasil.write(teks[i]);
  }
  return angka < 0 ? '-$hasil' : hasil.toString();
}
