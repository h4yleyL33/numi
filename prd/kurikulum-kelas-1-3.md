# Kurikulum dan Tampilan Kelas Kecil (Kelas 1-3)

Kelas kecil mencakup topik T01 sampai T06. Acuannya Capaian Pembelajaran Matematika
Kurikulum Merdeka, Keputusan Kepala BSKAP No. 046/H/KR/2025, Fase A (kelas 1-2) dan awal
Fase B (kelas 3). Pemetaan lengkap dan alasan pembagian ada di
`docs/02-perancangan/kurikulum/README.md`; berkas ini menurunkannya ke isi lesson, bentuk
soal, dan tampilan.

## Siapa yang masuk kelas kecil

Kelompok ditentukan dari diagnostic, bukan umur (doktek 2.2). Anak masuk kelas kecil kalau
topik pertama yang belum ia kuasai ada di T01-T06. Sebagian besar anak kelas 1-3 akan ada di
sini, tetapi anak kelas 4-6 yang belum kuat di penjumlahan dan pengurangan juga masuk. Karena
itu bahasa dan gambar dibuat ramah anak tanpa terlihat seperti aplikasi balita.

## Capaian yang dikejar

Disarikan dari CP 046/2025 elemen Bilangan (dan makna tanda "=" dari elemen Aljabar).

| Fase | Kelas | Capaian |
|---|---|---|
| A | 1-2 | Membaca, menulis, membandingkan, mengurutkan bilangan cacah sampai 100. Memahami nilai tempat puluhan dan satuan. Menjumlah dan mengurang sampai 20 dengan benda konkret. Mengenal setengah dan seperempat sebagai bagian dari keseluruhan. Memahami tanda "=" sebagai "sama banyak". |
| B (awal) | 3 | Bilangan cacah sampai 1.000. Penjumlahan dan pengurangan sampai 1.000 dengan dan tanpa menyimpan atau meminjam. |

## Topik dan isi lesson

Setiap topik punya dua lesson (Kenalan dan Latihan) lalu mastery test. Isi Kenalan diambil
dari `app/lib/data/content/daftar_lesson.dart`.

| ID | Pulau | Tujuan pembelajaran | Contoh di Kenalan | Bentuk soal | Batas angka |
|---|---|---|---|---|---|
| T01 | Kerikil | Membilang dan membandingkan banyak benda sampai 20 | 7 < 9 | hitung benda, bandingkan, urutkan, pasangkan, bilangan sesudah | 1-20 |
| T02 | Kelapa | Nilai tempat puluhan dan satuan sampai 100 | 47 = 40 + 7 | pilihan nilai tempat, urai ke kotak, bandingkan, pilih terbesar | 10-99 |
| T03 | Pelangi | Penjumlahan sampai 20 sebagai menggabungkan | 5 + 3 = 8 | hitung benda, seret ke kotak, pasangkan, pilihan | hasil ≤ 20 |
| T04 | Kabut | Pengurangan sampai 20 sebagai mengambil | 9 - 4 = 5 | hitung benda (dicoret), seret ke kotak, pasangkan, bandingkan | tidak pernah negatif |
| T05 | Semangka | Setengah dan seperempat dari satu benda | 1/2, 1/4 | pecahan bergambar, nama pecahan, bagian dari kumpulan, bandingkan | penyebut 2 dan 4 |
| T06 | Karang | Penjumlahan dan pengurangan sampai 1.000 per kolom | 245 + 132 = 377 | pilihan, seret ke kotak, bandingkan, soal cerita pendek | ≤ 1.000 |

T06 adalah jembatan ke kelas besar. Soal cerita mulai dikenalkan di sini, tetapi paling
panjang satu kalimat dan selalu dibacakan.

## Urutan konkret, gambar, simbol

Mengikuti pendekatan CPA (Bruner): tiap topik bergerak dari benda ke gambar ke lambang.

| Tahap | Di lesson Kenalan | Di lesson Latihan | Di mastery test |
|---|---|---|---|
| Konkret | Numi menyeret 5 kerang lalu 3 kerang ke satu keranjang | Soal hitung benda, benda bisa disentuh dan bergoyang | - |
| Gambar | Kerang diganti titik-titik | Soal pasangkan gambar dengan angka | Sebagian soal masih bergambar |
| Simbol | Muncul 5 + 3 = 8 di bawah gambar | Seret angka ke kotak `5 + ☐ = 8` | Pilihan angka dan kotak |

Anak tidak melompat langsung ke simbol. Kalau dua soal simbol berturut-turut salah, soal
berikutnya kembali ke versi bergambar (aturan ini perlu ditambah di `generator_soal.dart`,
ditandai sebagai pekerjaan minggu 4-9).

## Bentuk soal dan tampilannya

| Bentuk | Cara menjawab | Tampilan | Catatan aksesibilitas |
|---|---|---|---|
| Hitung benda | Ketuk angka yang benar dari 3 pilihan | Benda (apel, kerang, ikan) tersusun dalam baris 5, bukan acak | Susunan per 5 membantu anak melihat kelompok |
| Seret ke kotak | Seret kartu angka ke kotak kosong | Kotak putus-putus berdenyut pelan | Toleransi lepas 40 dp, kartu kembali sendiri bila meleset |
| Pasangkan | Ketuk kiri lalu kanan | Garis muncul di antara pasangan | Tidak perlu menarik garis, cukup dua ketukan |
| Bandingkan | Ketuk `<`, `=`, `>` | Simbol diberi buaya kecil yang "memakan" angka lebih besar | Tiga tombol 96 dp |
| Pecahan bergambar | Ketuk pecahan yang sesuai | Kue atau semangka dipotong, bagian diwarnai | Bagian diwarnai juga diberi pola garis |
| Pilihan angka | Ketuk satu dari 3-4 angka | Kartu besar 96 × 96 dp | Paling banyak 4 pilihan |

Jumlah pilihan dibatasi 3 untuk T01-T04 supaya layar tidak penuh, 4 untuk T05-T06.

## Aturan tampilan kelas kecil

Turunan dari `kajian-ui-anak.md`.

- Satu soal per layar. Hanya ada soal, pilihan jawaban, tombol suara, dan tombol Cek.
- Tombol Cek baru muncul setelah anak memilih jawaban. Sebelum itu yang tampil hanya soal,
  jadi anak tidak tergoda menekan Cek tanpa menjawab.
- Soal dibacakan otomatis. Tombol suara 56 dp di kiri atas untuk mengulang.
- Huruf soal 32 sp, Nunito ExtraBold. Angka di kartu 40 sp.
- Latar krem `#FFF8EC` di layar soal supaya tulisan mudah dibaca; latar malam hanya di peta.
- Bilah progres berupa 5 titik cahaya, bukan angka "3/5".
- Numi muncul di setiap umpan balik, ukuran 88 dp, dengan kalimat paling banyak 6 kata.

## Contoh soal

| Topik | Soal (dibacakan) | Tampilan | Jawaban |
|---|---|---|---|
| T01 | "Ada berapa ikan?" | 8 ikan dalam dua baris (5 dan 3) | 8 |
| T02 | "Seret angka ke kotak." | `63 = ☐ + 3` dengan kartu 6, 60, 30 | 60 |
| T03 | "Berapa jumlahnya?" | 4 apel + 3 apel | 7 |
| T04 | "Ada 9 kerang. Diambil 4. Sisa berapa?" | 9 kerang, 4 dicoret | 5 |
| T05 | "Bagian yang diwarnai?" | kue dipotong 4, satu diwarnai | 1/4 |
| T06 | "Ibu punya 250 manik. Beli 120 lagi. Jadi berapa?" | kalimat + gambar manik kecil | 370 |

## Ukuran ketuntasan

| Aktivitas | Jumlah soal | Lulus |
|---|---|---|
| Lesson | 5 | minimal 3 benar (`AppConfig.minBenarLesson`) |
| Mastery test | 5 | skor 95 atau lebih (`AppConfig.masteryThreshold`) |

Catatan untuk tim: untuk kelas kecil, 5 dari 5 cukup berat. Bloom memakai ambang 80-90%.
Kalau uji pengguna di minggu 10 menunjukkan banyak anak kelas 1 gagal di mastery, usulan
paling sederhana adalah ambang 80 (4 dari 5) khusus kelas kecil.
