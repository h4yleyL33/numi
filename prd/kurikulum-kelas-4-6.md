# Kurikulum dan Tampilan Kelas Besar (Kelas 4-6)

Kelas besar mencakup topik T07 sampai T12. Acuannya Capaian Pembelajaran Matematika
Kurikulum Merdeka, Keputusan Kepala BSKAP No. 046/H/KR/2025, Fase B (kelas 3-4) dan Fase C
(kelas 5-6). Dasar pembagiannya ada di `docs/02-perancangan/kurikulum/README.md`.

## Siapa yang masuk kelas besar

Anak masuk kelas besar kalau diagnostic menunjukkan T01-T06 sudah dikuasai, sehingga topik
pertama yang belum dikuasai ada di T07-T12. Perkalian (T07) menjadi pintu masuk, karena di CP
perkalian dan pembagian sampai 100 berada di Fase B. Anak kelas 3 yang sudah kuat di
penjumlahan bisa langsung masuk ke sini.

## Capaian yang dikejar

| Fase | Kelas | Capaian |
|---|---|---|
| B | 3-4 | Perkalian dan pembagian sampai 100 dengan benda, gambar, dan simbol. Kelipatan dan faktor. Pecahan senilai, membandingkan dan mengurutkan pecahan. |
| C | 5-6 | Operasi hitung sampai 100.000 termasuk masalah uang. KPK dan FPB. Penjumlahan dan pengurangan pecahan. Mencari bilangan yang belum diketahui dalam kalimat matematika. |

## Topik dan isi lesson

| ID | Pulau | Tujuan pembelajaran | Contoh di Kenalan | Bentuk soal | Batas angka |
|---|---|---|---|---|---|
| T07 | Kupu-kupu | Perkalian sebagai penjumlahan berulang sampai 100 | 4 × 3 = 12 | pilihan, seret ke kotak, soal cerita, penjumlahan berulang | faktor ≤ 10 |
| T08 | Pasar Apung | Pembagian sebagai membagi rata, kebalikan perkalian | 12 : 3 = 4 | pilihan, seret ke kotak, soal cerita, kebalikan perkalian | hasil bulat, ≤ 100 |
| T09 | Kue | Pecahan senilai dan membandingkan pecahan | 1/2 = 2/4 | senilai, bandingkan, pecahan bergambar | penyebut ≤ 12 |
| T10 | Pelabuhan | Operasi hitung sampai 100.000 dan soal cerita uang | 3 × 12.500 = 37.500 | belanja, hitung, kembalian, perkalian | ≤ 100.000, kelipatan 500 untuk uang |
| T11 | Roti | Penjumlahan dan pengurangan pecahan | 1/4 + 2/4 = 3/4 | tambah, kurang, beda penyebut, soal cerita | penyebut ≤ 12, hasil ≤ 1 |
| T12 | Mercusuar | KPK dan FPB | KPK 4 dan 6 = 12 | KPK, FPB, soal cerita KPK, soal cerita FPB | ≤ 60 |

Prasyarat: T07 butuh T06; T08 butuh T07; T09 butuh T05 dan T08; T10 dan T12 butuh T08;
T11 butuh T09. Jadi setelah T08 dikuasai, anak punya tiga pulau terbuka (T09, T10, T12).

## Dari gambar ke simbol dan cerita

Kelas besar dimulai dari simbol, tetapi gambar tetap dipakai untuk memperkenalkan konsep baru.

| Topik | Gambar pembuka | Simbol | Cerita |
|---|---|---|---|
| T07 | 4 kelompok berisi 3 kupu-kupu | 4 × 3 = ☐ | "Ada 6 pot, tiap pot 5 bunga..." |
| T08 | 12 ikan dibagi ke 3 perahu | 12 : 3 = ☐ | "Bu Sari punya 48 kue, dibagi rata ke 6 piring..." |
| T09 | Dua roti sama besar, dipotong 2 dan 4 | 1/2 = ☐/4 | "Mana yang lebih banyak, 2/3 atau 3/4 pizza?" |
| T10 | Uang kertas dan koin | 25.000 - 18.500 | "Beli 3 buku seharga 12.500..." |
| T11 | Pita dipotong-potong | 2/5 + 1/5 | "Kakak minum 1/4 liter, adik 2/4 liter..." |
| T12 | Dua lampu berkedip tiap 4 dan 6 detik | KPK 4 dan 6 | "Kapan keduanya menyala bersamaan lagi?" |

## Soal cerita

Soal cerita adalah pembeda utama kelas besar (FR-004b). Aturan menulisnya:

- Paling banyak 3 kalimat, 35 kata.
- Memakai nama dan benda yang dekat dengan anak Indonesia: kue, uang jajan, angkot, kelereng,
  pasar, sawah. Nama tokoh bergiliran dan beragam (Sari, Budi, Made, Ucok, Ani, Yohanes).
- Angka yang ditanyakan selalu bisa dihitung tanpa kalkulator.
- Satu soal, satu operasi untuk T07-T08. Dua operasi baru dipakai di T10.
- Kata kunci operasi tidak ditebalkan, supaya anak membaca maknanya, bukan mencari kata
  "dibagi".
- Tombol suara tetap ada, tetapi tidak membaca otomatis.

## Aturan tampilan kelas besar

Turunan dari `kajian-ui-anak.md`. Dunia pulau dan maskot sama dengan kelas kecil; yang
berubah adalah kepadatan dan nada.

- Huruf soal 24 sp, isi 16 sp. Pilihan jawaban 72 dp tinggi, lebar penuh, paling banyak 4.
- Soal cerita boleh mengambil setengah layar atas; pilihan di setengah bawah.
- Jawaban angka besar (T10) memakai papan angka di layar, bukan keyboard sistem, supaya tidak
  ada tombol yang tidak dipakai.
- Numi muncul lebih jarang: di umpan balik salah dan di akhir sesi saja. Kalimatnya lebih
  ringkas dan tidak memakai bahasa bayi.
- Bilah progres berupa angka "3 dari 5" dan bilah tipis.
- Penjelasan jawaban salah memakai langkah: "12 : 3 artinya 12 dibagi 3 kelompok. 3 × 4 = 12,
  jadi jawabannya 4."

## Contoh soal

| Topik | Soal | Jawaban |
|---|---|---|
| T07 | `7 × ☐ = 42` | 6 |
| T08 | "Ada 56 kelereng dibagi rata ke 8 anak. Tiap anak dapat berapa?" | 7 |
| T09 | Mana yang lebih besar, `3/4` atau `5/8`? | 3/4 |
| T10 | "Made membawa Rp50.000. Ia membeli 2 buku seharga Rp17.500. Berapa kembaliannya?" | Rp15.000 |
| T11 | `3/8 + 2/8 = ?` | 5/8 |
| T12 | "Lampu merah berkedip tiap 6 detik, lampu biru tiap 9 detik. Setelah berapa detik keduanya berkedip bersamaan?" | 18 |

## Ukuran ketuntasan

Sama dengan kelas kecil: lesson 5 soal dengan minimal 3 benar, mastery test 5 soal dengan
skor 95. Untuk kelas besar ambang ini lebih masuk akal karena soalnya lebih sedikit unsur
motoriknya, sehingga salah karena meleset menekan lebih jarang terjadi.
