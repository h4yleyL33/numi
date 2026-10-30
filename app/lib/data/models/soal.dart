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

  Map<String, dynamic> toJson() => {
    'id': id,
    'skillId': skillId,
    'versi': versi,
    'topikId': topikId,
    'jenis': jenis.name,
    'tingkat': tingkat,
    'pertanyaan': pertanyaan,
    'kalimat': kalimat,
    'benda': benda,
    'jumlahBenda': jumlahBenda,
    'jumlahBenda2': jumlahBenda2,
    'jumlahDicoret': jumlahDicoret,
    'gambarPecahan': gambarPecahan == null
        ? null
        : [gambarPecahan!.pembilang, gambarPecahan!.penyebut],
    'pilihan': pilihan,
    'jawabanBenar': jawabanBenar,
    'pasangan': pasangan.map((p) => [p.kiri, p.kanan]).toList(),
    'penjelasan': penjelasan,
  };

  factory Soal.fromJson(Map<String, dynamic> j) => Soal(
    id: j['id'] as String,
    skillId: j['skillId'] as String?,
    versi: j['versi'] as String,
    topikId: j['topikId'] as String,
    jenis: JenisSoal.values.byName(j['jenis'] as String),
    tingkat: j['tingkat'] as int,
    pertanyaan: j['pertanyaan'] as String,
    kalimat: j['kalimat'] as String?,
    benda: j['benda'] as String?,
    jumlahBenda: j['jumlahBenda'] as int,
    jumlahBenda2: j['jumlahBenda2'] as int,
    jumlahDicoret: j['jumlahDicoret'] as int,
    gambarPecahan: j['gambarPecahan'] == null
        ? null
        : Pecahan(
            (j['gambarPecahan'] as List)[0] as int,
            (j['gambarPecahan'] as List)[1] as int,
          ),
    pilihan: List<String>.from(j['pilihan'] as List),
    jawabanBenar: j['jawabanBenar'] as String,
    pasangan: (j['pasangan'] as List)
        .map((p) => PasanganSoal((p as List)[0] as String, p[1] as String))
        .toList(),
    penjelasan: j['penjelasan'] as String,
  );
}
