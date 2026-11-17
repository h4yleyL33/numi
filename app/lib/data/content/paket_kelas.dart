import '../models/siswa.dart';
import '../models/soal.dart';

/// Paket pengantar pengembangan dari fokus kelas pada PPL 2.6.2.
/// Butir draft belum menjadi konten terbit atau bank asesmen tervalidasi.
class PaketKelas {
  const PaketKelas(this.kelas, this.topikAwal, this.fokus);

  final int kelas;
  final String topikAwal;
  final String fokus;
  String get id => 'kelas-$kelas-pengantar';
  String get versi => '$id-v1';
  String get statusValidasi => 'PENDING_EDUCATOR_REVIEW';
  String get skillId => '$topikAwal-jangkar';
  List<String> get prasyarat => switch (kelas) {
    1 => const [],
    2 => const ['T01'],
    3 => const ['T02', 'T04'],
    4 => const ['T06'],
    5 => const ['T08'],
    6 => const ['T09'],
    _ => const [],
  };

  List<Soal> get butirAwal {
    final data = switch (kelas) {
      1 => const [
        (
          'Ada berapa kerang?',
          '🐚',
          7,
          ['6', '7', '8'],
          '7',
          'Hitung setiap kerang satu kali.',
        ),
        (
          'Ada berapa kerang?',
          '🐚',
          12,
          ['10', '11', '12'],
          '12',
          'Ada dua belas kerang.',
        ),
      ],
      2 => const [
        (
          'Nilai angka 4 pada 47?',
          '',
          0,
          ['4', '40', '7'],
          '40',
          'Angka 4 menempati puluhan: nilainya 40.',
        ),
        (
          '63 terdiri dari berapa puluhan?',
          '',
          0,
          ['3', '6', '60'],
          '6',
          '63 terdiri dari 6 puluhan dan 3 satuan.',
        ),
      ],
      3 => const [
        (
          '245 + 132 = ?',
          '',
          0,
          ['367', '377', '387'],
          '377',
          'Jumlahkan satuan, puluhan, lalu ratusan: hasilnya 377.',
        ),
        (
          '420 − 150 = ?',
          '',
          0,
          ['250', '270', '370'],
          '270',
          '420 dikurangi 100 menjadi 320, lalu dikurangi 50 menjadi 270.',
        ),
      ],
      4 => const [
        (
          'Ada 6 piring, masing-masing 7 kue. Berapa kue semuanya?',
          '',
          0,
          ['36', '42', '48'],
          '42',
          '6 kelompok berisi 7 adalah 6 × 7 = 42.',
        ),
        (
          '8 × 9 = ?',
          '',
          0,
          ['63', '72', '81'],
          '72',
          '8 kelompok berisi 9 menghasilkan 72.',
        ),
      ],
      5 => const [
        (
          'Sari punya Rp20.000. Ia membeli buku Rp12.500. Berapa sisanya?',
          '',
          0,
          ['Rp7.500', 'Rp8.500', 'Rp12.500'],
          'Rp7.500',
          '20.000 − 12.500 = 7.500.',
        ),
        (
          'Dua pensil masing-masing Rp3.500. Berapa harga semuanya?',
          '',
          0,
          ['Rp5.000', 'Rp7.000', 'Rp8.000'],
          'Rp7.000',
          '2 × 3.500 = 7.000.',
        ),
      ],
      6 => const [
        (
          '1/2 + 1/3 = ?',
          '',
          0,
          ['2/5', '5/6', '1/6'],
          '5/6',
          '1/2 = 3/6 dan 1/3 = 2/6; jumlahnya 5/6.',
        ),
        (
          '3/4 − 1/6 = ?',
          '',
          0,
          ['2/2', '7/12', '2/10'],
          '7/12',
          '3/4 = 9/12 dan 1/6 = 2/12; selisihnya 7/12.',
        ),
      ],
      _ => throw RangeError.range(kelas, 1, 6, 'kelas'),
    };
    return [
      for (final (i, d) in data.indexed)
        Soal(
          id: '$id-${i + 1}',
          topikId: topikAwal,
          skillId: skillId,
          versi: versi,
          jenis: kelas == 1 ? JenisSoal.hitungBenda : JenisSoal.pilihanGanda,
          pertanyaan: d.$1,
          benda: d.$2.isEmpty ? null : d.$2,
          jumlahBenda: d.$3,
          pilihan: d.$4,
          jawabanBenar: d.$5,
          penjelasan: d.$6,
        ),
    ];
  }

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
