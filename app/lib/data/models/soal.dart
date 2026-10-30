/// Bentuk soal. Kelas kecil lebih banyak memakai bentuk bergambar, kelas besar
/// memakai simbol dan soal cerita (FR-004a, FR-004b).
enum JenisSoal {
  hitungBenda,
  pilihanGanda,
  seretKeKotak,
  pasangkan,
  bandingkan,
  pecahanGambar,
  soalCerita,
}

class Pecahan {
  const Pecahan(this.pembilang, this.penyebut);
  final int pembilang;
  final int penyebut;

  @override
  String toString() => '$pembilang/$penyebut';
}

class PasanganSoal {
  const PasanganSoal(this.kiri, this.kanan);
  final String kiri;
  final String kanan;
}

/// Entitas Soal (DATA-002). Soal dibangkitkan dari templat di GeneratorSoal.
class Soal {
  const Soal({
    required this.id,
    required this.topikId,
    required this.jenis,
    required this.pertanyaan,
    required this.jawabanBenar,
    required this.penjelasan,
    this.tingkat = 1,
    this.kalimat,
    this.benda,
    this.jumlahBenda = 0,
    this.jumlahBenda2 = 0,
    this.jumlahDicoret = 0,
    this.gambarPecahan,
    this.pilihan = const [],
    this.pasangan = const [],
    this.skillId,
    this.versi = 'generator-v1',
  });

  final String id;
  final String? skillId;
  final String versi;
  final String topikId;
  final JenisSoal jenis;
  final int tingkat;
  final String pertanyaan;

  /// Kalimat matematika. Kotak kosong ditulis sebagai ☐, token dipisah spasi.
  final String? kalimat;

  /// Emoji benda untuk soal hitung benda.
  final String? benda;
  final int jumlahBenda;

  /// Kelompok benda kedua untuk soal penjumlahan bergambar.
  final int jumlahBenda2;

  /// Banyak benda yang dicoret untuk soal pengurangan bergambar.
  final int jumlahDicoret;
  final Pecahan? gambarPecahan;
  final List<String> pilihan;
  final String jawabanBenar;
  final List<PasanganSoal> pasangan;
  final String penjelasan;

  bool periksa(String jawaban) => jawaban.trim() == jawabanBenar;
}
