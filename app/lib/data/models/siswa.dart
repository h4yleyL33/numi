/// Kelompok belajar ditentukan dari hasil diagnostic test, bukan dari usia
/// (doktek bagian 2.2).
enum KelompokBelajar {
  kecil('Kelas Kecil', 'Belajar lewat gambar dan benda'),
  besar('Kelas Besar', 'Belajar lewat simbol dan soal cerita');

  const KelompokBelajar(this.label, this.gaya);
  final String label;
  final String gaya;
}

/// Entitas Siswa (DATA-001).
class Siswa {
  const Siswa({
    required this.id,
    required this.nama,
    required this.usia,
    required this.dibuatPada,
    this.kelompokBelajar,
  });

  final String id;
  final String nama;
  final int usia;
  final KelompokBelajar? kelompokBelajar;
  final DateTime dibuatPada;

  String get namaPanggilan => nama.trim().split(RegExp(r'\s+')).first;

  Siswa copyWith({String? nama, int? usia, KelompokBelajar? kelompokBelajar}) {
    return Siswa(
      id: id,
      nama: nama ?? this.nama,
      usia: usia ?? this.usia,
      kelompokBelajar: kelompokBelajar ?? this.kelompokBelajar,
      dibuatPada: dibuatPada,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'usia': usia,
        'kelompokBelajar': kelompokBelajar?.name,
        'dibuatPada': dibuatPada.toIso8601String(),
      };

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(
        id: json['id'] as String,
        nama: json['nama'] as String,
        usia: json['usia'] as int,
        kelompokBelajar: json['kelompokBelajar'] == null
            ? null
            : KelompokBelajar.values.byName(json['kelompokBelajar'] as String),
        dibuatPada: DateTime.parse(json['dibuatPada'] as String),
      );
}
