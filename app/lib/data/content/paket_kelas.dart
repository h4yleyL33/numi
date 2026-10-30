import '../models/siswa.dart';

/// Titik awal sementara dari fokus kelas pada PPL 2.6.2.
/// shortcut: baru pemilihan topik awal, paket butir per skill menunggu validasi guru (I06).
class PaketKelas {
  const PaketKelas(this.kelas, this.topikAwal, this.fokus);

  final int kelas;
  final String topikAwal;
  final String fokus;

  static const daftar = [
    PaketKelas(1, 'T01', 'Membilang, menambah, dan mengambil benda'),
    PaketKelas(2, 'T02', 'Satuan, puluhan, dan pecahan sederhana'),
    PaketKelas(3, 'T06', 'Tambah-kurang sampai 1.000 dan kelompok sama banyak'),
    PaketKelas(4, 'T07', 'Kali-bagi dan pecahan senilai'),
    PaketKelas(5, 'T10', 'Operasi uang dan pengantar operasi pecahan'),
    PaketKelas(6, 'T11', 'Pecahan berbeda penyebut, KPK, dan FPB'),
  ];

  static PaketKelas untuk(int kelas) {
    KelompokKelas.dariKelas(kelas);
    return daftar[kelas - 1];
  }
}
