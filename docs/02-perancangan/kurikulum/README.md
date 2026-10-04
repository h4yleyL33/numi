# Pemetaan Kurikulum Numi

Dokumen ini menjelaskan dari mana 12 topik di skill map Numi berasal, kenapa urutannya
seperti itu, dan bagaimana pembagian kelas kecil dan kelas besar disesuaikan dengan
Kurikulum Merdeka. Isinya dipakai langsung oleh aplikasi: daftar topik di
`app/lib/data/content/topics.dart` dibuat persis mengikuti tabel di bawah.

## Peta keputusan

| No | Temuan | Dasar | Keputusan |
|---|---|---|---|
| 1 | CP Matematika SD yang berlaku adalah Keputusan Kepala BSKAP No. 046/H/KR/2025 | Keputusan 2026 hanya mengubah CP Pendidikan Agama [1][2] | Semua topik diacu ke CP 046/2025 |
| 2 | CP dibagi per fase: A (kelas 1-2), B (kelas 3-4), C (kelas 5-6) | Struktur fase dalam CP [1][3] | Tiap topik diberi label fase |
| 3 | Proposal membatasi ruang lingkup ke numerasi dasar | Proposal Bab 1, bagian scope | Hanya elemen Bilangan yang diambil, ditambah makna tanda "=" dari elemen Aljabar |
| 4 | Pecahan setengah dan seperempat ada di Fase A, bukan kelas 4-6 | CP Fase A elemen Bilangan [3] | Pecahan sederhana masuk kelas kecil |
| 5 | Perkalian dan pembagian sampai 100 ada di Fase B (kelas 3-4) | CP Fase B elemen Bilangan [3] | Keduanya jadi pintu masuk kelas besar |
| 6 | Siswa SD belum bisa diberi soal yang sama untuk semua usia | Tahap operasional konkret Piaget, usia 7-11 [4] | Kelas kecil memakai soal visual dan benda, kelas besar memakai simbol dan soal cerita |
| 7 | Topik matematika saling bergantung | Hierarki belajar Gagne [5] | Tiap topik punya prasyarat, dan skill map membuka topik sesuai prasyaratnya |

## 1. Kurikulum yang dipakai

Dari penelusuran, CP yang berlaku untuk tahun ajaran 2025/2026 dan 2026/2027 adalah
Keputusan Kepala BSKAP No. 046/H/KR/2025, berlaku sejak 16 Juli 2025 [1]. Ada
keputusan perubahan tahun 2026, tetapi perubahannya hanya menyentuh mata pelajaran
Pendidikan Agama dan Budi Pekerti, sehingga CP Matematika tetap mengikuti keputusan
046/2025 [2].

Karena itu, semua topik di Numi diberi rujukan ke CP 046/2025, bukan ke CP lama
(Keputusan 008/2022 atau 032/2024). Kalau nanti dosen meminta rujukan kurikulum,
yang dicantumkan di doktek adalah keputusan 046/2025 ini.

## 2. Isi CP yang relevan

Ringkasan elemen Bilangan per fase, disarikan dari CP 046/2025 [3]:

| Fase | Kelas | Elemen Bilangan |
|---|---|---|
| A | 1-2 | Bilangan cacah sampai 100 (membaca, menulis, nilai tempat, membandingkan, mengurutkan, menyusun dan mengurai). Penjumlahan dan pengurangan dengan benda konkret sampai 20. Pecahan sebagai bagian dari keseluruhan: setengah dan seperempat. |
| B | 3-4 | Bilangan cacah sampai 10.000. Penjumlahan dan pengurangan sampai 1.000. Perkalian dan pembagian sampai 100 dengan benda, gambar, dan simbol. Kelipatan dan faktor. Membandingkan dan mengurutkan pecahan, pecahan senilai, pecahan sebagai desimal dan persen. |
| C | 5-6 | Bilangan cacah sampai 1.000.000. Keempat operasi hitung sampai 100.000. Masalah uang. KPK dan FPB. Membandingkan pecahan termasuk pecahan campuran, penjumlahan dan pengurangan pecahan, perkalian dan pembagian pecahan dengan bilangan asli. |

Dari elemen Aljabar, yang diambil hanya bagian yang menyatu dengan soal hitung: makna
tanda "=" (Fase A) dan mencari bilangan yang belum diketahui dalam kalimat matematika
seperti `7 + ☐ = 12` (Fase B dan C). Elemen Pengukuran, Geometri, serta Analisis Data
dan Peluang tidak diambil karena di luar scope proposal.

Catatan untuk wireframe lama: contoh soal `2x + 4 = ?` belum sesuai CP SD, karena
variabel huruf baru dikenalkan di SMP. Bentuk yang sesuai untuk SD adalah kotak kosong,
misalnya `2 × ☐ + 4 = 14`.

## 3. Daftar topik skill map

| ID | Topik | Pulau di cerita | Fase | Kelompok | Prasyarat |
|---|---|---|---|---|---|
| T01 | Mengenal bilangan sampai 20 | Pulau Kerikil | A | Kecil | - |
| T02 | Bilangan sampai 100 dan nilai tempat | Pulau Kelapa | A | Kecil | T01 |
| T03 | Penjumlahan sampai 20 | Pulau Pelangi | A | Kecil | T01 |
| T04 | Pengurangan sampai 20 | Pulau Kabut | A | Kecil | T03 |
| T05 | Pecahan setengah dan seperempat | Pulau Semangka | A | Kecil | T02 |
| T06 | Penjumlahan dan pengurangan sampai 1.000 | Pulau Karang | B | Kecil | T02, T04 |
| T07 | Perkalian sampai 100 | Pulau Kupu-kupu | B | Besar | T06 |
| T08 | Pembagian sampai 100 | Pulau Pasar Apung | B | Besar | T07 |
| T09 | Pecahan senilai dan membandingkan pecahan | Pulau Kue | B | Besar | T05, T08 |
| T10 | Operasi hitung sampai 100.000 dan soal cerita | Pulau Pelabuhan | C | Besar | T08 |
| T11 | Penjumlahan dan pengurangan pecahan | Pulau Roti | C | Besar | T09 |
| T12 | KPK dan FPB | Pulau Mercusuar | C | Besar | T08 |

Prasyarat tidak dibuat lurus satu garis. Contohnya T05 (pecahan) hanya butuh T02
(nilai tempat), tidak perlu menunggu pengurangan selesai. Dengan begitu siswa yang
macet di satu topik masih punya topik lain yang terbuka, dan skill map terlihat
seperti peta bercabang.

## 4. Kenapa pembagian kelas kecil dan besar digeser

Proposal Bab 1 membagi materi seperti ini: kelas kecil (1-3) untuk pengenalan angka,
penjumlahan, dan pengurangan, lalu kelas besar (4-6) untuk perkalian, pembagian, dan
pecahan.

Setelah dicocokkan dengan CP, ada dua hal yang tidak pas. Pertama, pecahan setengah
dan seperempat sudah diajarkan di Fase A (kelas 1-2) [3], jadi kalau semua pecahan
ditaruh di kelas besar, anak kelas 1-2 kehilangan satu materi wajibnya. Kedua,
perkalian dan pembagian sampai 100 ada di Fase B, yang mencakup kelas 3 dan 4 [3].

Maka pembagiannya disesuaikan sedikit. Pecahan sederhana (T05) masuk kelas kecil dan
diajarkan secara visual dengan gambar kue yang dipotong. Pecahan lanjutan (T09, T11)
tetap di kelas besar. Perkalian (T07) jadi pintu masuk kelas besar. Pembagian besarnya
tetap sama dengan proposal, sehingga Bab 1 tidak perlu ditulis ulang, cukup ditambah
satu kalimat penjelas.

Kelompok belajar juga tidak ditentukan dari usia. Doktek bagian 2.2 menyebut usia
hanya data profil, dan kelompoknya ditentukan dari hasil diagnostic test. Numi
mengikuti itu: usia hanya dipakai untuk menentukan dari topik mana diagnostic test
dimulai, lalu kelompok diambil dari topik pertama yang belum dikuasai. Kalau topik itu
ada di T01 sampai T06, siswa masuk kelas kecil. Kalau di T07 sampai T12, masuk kelas
besar.

## 5. Bentuk soal per kelompok

Anak usia 7 sampai 11 tahun berada di tahap operasional konkret: mereka bisa bernalar
logis, tetapi masih butuh benda atau gambar yang nyata [4]. Pendekatan konkret,
gambar, lalu simbol (CPA) yang dipakai di banyak kurikulum matematika dasar juga
bertumpu pada gagasan ini [6]. Karena itu bentuk soal dibedakan:

| Bentuk soal | Kelas kecil | Kelas besar | Contoh |
|---|---|---|---|
| Hitung benda | ya | - | "Ada berapa apel?" dengan gambar apel |
| Seret ke kotak | ya | ya | `8 + ☐ = 13`, kartu angka diseret ke kotak |
| Pasangkan | ya | - | tarik garis dari `3 + 2` ke `5` |
| Bandingkan | ya | ya | pilih `<`, `=`, atau `>` |
| Pecahan bergambar | ya | ya | "Bagian yang diwarnai adalah?" |
| Pilihan angka | ya | ya | `6 × 7 = ?` |
| Soal cerita | - | ya | "Bu Sari punya 48 kue, dibagi rata ke 6 piring..." |

Soal tidak ditulis satu per satu, tetapi dibangkitkan dari templat per topik. Satu
templat berisi bentuk kalimat dan batas angka, lalu aplikasi mengisi angkanya secara
acak dengan aturan yang menjaga kesesuaian CP (misalnya pengurangan di T04 tidak pernah
menghasilkan bilangan negatif). Cara ini disebut pembangkitan soal otomatis [7]. Dengan
tim lima orang dan satu semester, templat lebih masuk akal daripada menulis ratusan soal,
dan siswa tidak menghafal soal yang sama saat mengulang latihan.

## 6. Ambang ketuntasan

State diagram di doktek memakai ambang mastery test skor 95. Dengan 5 soal per mastery
test, itu berarti siswa harus benar semua. Nilai ini dipertahankan di aplikasi
(`AppConfig.masteryThreshold`) agar sesuai doktek. Sebagai bahan diskusi tim: model
mastery learning Bloom umumnya memakai ambang 80 sampai 90 persen [8], dan untuk anak
kelas 1, lima dari lima bisa terasa berat. Kalau tim sepakat menurunkannya, cukup
ubah satu konstanta itu dan state diagram di doktek.

## Rujukan

Periksa sendiri judul, penerbit, dan tahun setiap rujukan sebelum dimasukkan ke daftar
pustaka. Beberapa di antaranya diambil dari ringkasan situs pendidikan, bukan dari
dokumen asli.

1. Keputusan Kepala BSKAP Kemendikdasmen No. 046/H/KR/2025 tentang Capaian Pembelajaran pada PAUD, Jenjang Pendidikan Dasar, dan Jenjang Pendidikan Menengah. Dokumen resmi di Ruang GTK: https://guru.kemendikdasmen.go.id/dokumen/74r6Yln0zK. Dipakai di bagian 1.
2. Ringkasan perubahan CP tahun 2026 (Keputusan No. 020 Tahun 2026), pembelajaranmendalam.com, 2025. Dipakai di bagian 1. Perlu dicocokkan dengan salinan resmi.
3. Ringkasan CP Matematika SD/MI berdasarkan Keputusan BSKAP 046/H/KR/2025, kepalasekolah.id. Dipakai di bagian 2, 3, dan 4. Cocokkan kalimatnya dengan dokumen resmi [1] sebelum dikutip.
4. Piaget, J. (1952). The Origins of Intelligence in Children. International Universities Press. Dipakai di bagian 5.
5. Gagne, R. M. (1985). The Conditions of Learning and Theory of Instruction (4th ed.). Holt, Rinehart and Winston. Dipakai di peta keputusan nomor 7.
6. Bruner, J. S. (1966). Toward a Theory of Instruction. Harvard University Press. Asal gagasan enaktif, ikonik, simbolik yang menjadi dasar pendekatan CPA. Dipakai di bagian 5.
7. Gierl, M. J., & Haladyna, T. M. (Eds.). (2012). Automatic Item Generation: Theory and Practice. Routledge. Dipakai di bagian 5.
8. Bloom, B. S. (1968). Learning for Mastery. Evaluation Comment, 1(2). Dipakai di bagian 6.
