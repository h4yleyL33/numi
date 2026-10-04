import 'siswa.dart';

/// Fase Kurikulum Merdeka menurut CP BSKAP 046/H/KR/2025.
enum Fase {
  a('Fase A', 'Kelas 1-2'),
  b('Fase B', 'Kelas 3-4'),
  c('Fase C', 'Kelas 5-6');

  const Fase(this.label, this.kelas);
  final String label;
  final String kelas;
}

/// Entitas Topik. Satu topik digambarkan sebagai satu pulau di peta.
class Topik {
  const Topik({
    required this.id,
    required this.urutan,
    required this.nama,
    required this.namaPulau,
    required this.ikon,
    required this.fase,
    required this.kelompok,
    required this.prasyarat,
    required this.capaian,
  });

  final String id;

  /// Urutan belajar yang disarankan, dipakai diagnostic dan learning path.
  final int urutan;
  final String nama;
  final String namaPulau;
  final String ikon;
  final Fase fase;
  final KelompokBelajar kelompok;
  final List<String> prasyarat;

  /// Kalimat CP yang menjadi dasar topik ini.
  final String capaian;
}
