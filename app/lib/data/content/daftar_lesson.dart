import '../models/lesson.dart';

// Setiap topik punya dua lesson: Kenalan (penjelasan maskot lalu 5 soal) dan
// Latihan (5 soal langsung). Mastery test terbuka setelah keduanya selesai.

class _IsiKenalan {
  const _IsiKenalan(this.judul, this.penjelasan, this.contoh);
  final String judul;
  final List<String> penjelasan;
  final String contoh;
}

const _kenalan = <String, _IsiKenalan>{
  'T01': _IsiKenalan('Ayo membilang', [
    'Membilang artinya menghitung benda satu per satu.',
    'Sentuh bendanya sambil menyebut angkanya: satu, dua, tiga...',
    'Angka yang lebih besar berarti bendanya lebih banyak.',
  ], '7 < 9'),
  'T02': _IsiKenalan('Puluhan dan satuan', [
    'Sepuluh satuan bisa dikumpulkan menjadi satu puluhan.',
    'Pada 47, angka 4 berarti 4 puluhan atau 40, angka 7 berarti 7 satuan.',
    'Jadi 47 sama dengan 40 + 7.',
  ], '47 = 40 + 7'),
  'T03': _IsiKenalan('Menggabungkan benda', [
    'Menjumlahkan berarti menggabungkan dua kelompok benda.',
    'Hitung kelompok pertama, lalu lanjutkan menghitung kelompok kedua.',
    'Tanda = artinya kedua sisi sama banyak.',
  ], '5 + 3 = 8'),
  'T04': _IsiKenalan('Mengambil benda', [
    'Mengurangi berarti mengambil sebagian benda.',
    'Hitung dulu semua benda, lalu coret yang diambil.',
    'Sisanya adalah hasil pengurangan.',
  ], '9 - 4 = 5'),
  'T05': _IsiKenalan('Membagi sama besar', [
    'Kalau satu kue dibagi dua sama besar, tiap bagian disebut setengah.',
    'Kalau dibagi empat sama besar, tiap bagian disebut seperempat.',
    'Setengah ditulis 1/2, seperempat ditulis 1/4.',
  ], '1/2  1/4'),
  'T06': _IsiKenalan('Menjumlah bilangan besar', [
    'Jumlahkan satuan dengan satuan, puluhan dengan puluhan, ratusan dengan ratusan.',
    'Kalau satuan lebih dari 9, simpan satu puluhan ke kolom sebelah.',
    'Pengurangan juga dikerjakan per kolom dari kanan.',
  ], '245 + 132 = 377'),
  'T07': _IsiKenalan('Penjumlahan berulang', [
    'Perkalian adalah penjumlahan berulang.',
    '4 × 3 artinya ada 4 kelompok, tiap kelompok berisi 3.',
    'Jadi 4 × 3 = 3 + 3 + 3 + 3 = 12.',
  ], '4 × 3 = 12'),
  'T08': _IsiKenalan('Membagi rata', [
    'Pembagian artinya membagi rata ke beberapa kelompok.',
    '12 : 3 artinya 12 benda dibagi rata ke 3 kelompok.',
    'Pembagian adalah kebalikan perkalian: 3 × 4 = 12, maka 12 : 3 = 4.',
  ], '12 : 3 = 4'),
  'T09': _IsiKenalan('Pecahan yang sama besar', [
    'Pecahan senilai punya nilai sama walau angkanya berbeda.',
    'Kalikan pembilang dan penyebut dengan angka yang sama: 1/2 = 2/4.',
    'Untuk membandingkan, samakan dulu penyebutnya.',
  ], '1/2 = 2/4'),
  'T10': _IsiKenalan('Soal cerita', [
    'Baca ceritanya pelan-pelan dan cari angka yang penting.',
    'Tentukan operasinya: ditambah, dikurangi, dikali, atau dibagi.',
    'Periksa lagi apakah jawabanmu masuk akal.',
  ], '3 × 12.500 = 37.500'),
  'T11': _IsiKenalan('Menjumlah pecahan', [
    'Pecahan hanya bisa dijumlah kalau penyebutnya sama.',
    'Kalau penyebutnya sama, jumlahkan pembilangnya saja.',
    'Kalau berbeda, ubah dulu ke pecahan senilai.',
  ], '1/4 + 2/4 = 3/4'),
  'T12': _IsiKenalan('Kelipatan dan faktor', [
    'KPK adalah kelipatan persekutuan terkecil dari dua bilangan.',
    'FPB adalah faktor persekutuan terbesar dari dua bilangan.',
    'KPK dipakai untuk mencari kapan dua kejadian terjadi bersamaan lagi.',
  ], 'KPK 4 dan 6 = 12'),
};

List<Lesson> lessonUntuk(String topikId) {
  final isi = _kenalan[topikId]!;
  return [
    Lesson(
      id: '$topikId-L1',
      topikId: topikId,
      judul: isi.judul,
      tipe: TipeLesson.kenalan,
      penjelasan: isi.penjelasan,
      contoh: isi.contoh,
    ),
    Lesson(
      id: '$topikId-L2',
      topikId: topikId,
      judul: 'Latihan',
      tipe: TipeLesson.latihan,
    ),
  ];
}
