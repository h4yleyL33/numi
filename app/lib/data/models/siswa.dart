/// Kategori konten lama; bukan kelompok kelas atau label kemampuan siswa.
enum KelompokBelajar {
  kecil('Kelas Kecil', 'Belajar lewat gambar dan benda'),
  besar('Kelas Besar', 'Belajar lewat simbol dan soal cerita');

  const KelompokBelajar(this.label, this.gaya);
  final String label;
  final String gaya;
}

/// Kelompok profil diturunkan dari kelas sekolah, bukan skor diagnostic.
enum KelompokKelas {
  faseA('Kelas 1–2', 'Fase A'),
  faseB('Kelas 3–4', 'Fase B'),
  faseC('Kelas 5–6', 'Fase C');

  const KelompokKelas(this.label, this.fase);
  final String label;
  final String fase;

  static KelompokKelas dariKelas(int kelas) {
    if (kelas < 1 || kelas > 6) throw RangeError.range(kelas, 1, 6, 'kelas');
    return values[(kelas - 1) ~/ 2];
  }
}

/// Entitas Siswa (DATA-001).
class Siswa {
  const Siswa({
    required this.id,
    required this.nama,
    this.kelas,
    this.usia,
    required this.dibuatPada,
    this.kelompokBelajar,
  });

  final String id;
  final String nama;
  final int? kelas;

  /// Dipertahankan hanya untuk membaca data lama, tidak dikonversi ke kelas.
  final int? usia;
  final KelompokBelajar? kelompokBelajar;
  final DateTime dibuatPada;

  bool get perluKonfirmasiKelas => kelas == null || kelas! < 1 || kelas! > 6;
  KelompokKelas? get kelompokKelas =>
      perluKonfirmasiKelas ? null : KelompokKelas.dariKelas(kelas!);

  String get namaPanggilan => nama.trim().split(RegExp(r'\s+')).first;

  Siswa copyWith({
    String? nama,
    int? kelas,
    int? usia,
    KelompokBelajar? kelompokBelajar,
  }) {
    return Siswa(
      id: id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      usia: usia ?? this.usia,
      kelompokBelajar: kelompokBelajar ?? this.kelompokBelajar,
      dibuatPada: dibuatPada,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'kelas': kelas,
    'usia': usia,
    'kelompokBelajar': kelompokBelajar?.name,
    'dibuatPada': dibuatPada.toIso8601String(),
  };

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(
    id: json['id'] as String,
    nama: json['nama'] as String,
    kelas: json['kelas'] as int?,
    usia: json['usia'] as int?,
    kelompokBelajar: json['kelompokBelajar'] == null
        ? null
        : KelompokBelajar.values.byName(json['kelompokBelajar'] as String),
    dibuatPada: DateTime.parse(json['dibuatPada'] as String),
  );
}
