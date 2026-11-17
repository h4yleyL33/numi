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

  Map<String, String> toJson() => {'kiri': kiri, 'kanan': kanan};

  factory PasanganSoal.fromJson(Object? nilai) => switch (nilai) {
    [final String kiri, final String kanan] => PasanganSoal(kiri, kanan),
    {'kiri': final String kiri, 'kanan': final String kanan} => PasanganSoal(
      kiri,
      kanan,
    ),
    _ => throw const FormatException('Pasangan soal tidak sah.'),
  };
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
  String get kompetensiId => skillId ?? '$topikId-jangkar';
  String get statusValidasi => 'PENDING_EDUCATOR_REVIEW';

  bool periksa(String jawaban) => jawaban.trim() == jawabanBenar;

  Map<String, dynamic> toJson() => {
    'id': id,
    'skillId': skillId,
    'versi': versi,
    'statusValidasi': statusValidasi,
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
    'pasangan': pasangan.map((p) => p.toJson()).toList(),
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
    pasangan: (j['pasangan'] as List).map(PasanganSoal.fromJson).toList(),
    penjelasan: j['penjelasan'] as String,
  );
}
