# Kajian UI/UX untuk Anak 6-12 Tahun

Kajian ini menjawab satu pertanyaan: tampilan seperti apa yang bisa dipakai anak SD sendiri
tanpa dibantu orang dewasa (NFR-001). Hasilnya berupa aturan desain di bagian 6, yang menjadi
dasar redesign di `redesign-ui.md`.

## Peta keputusan

| No | Temuan | Dasar | Keputusan untuk Numi |
|---|---|---|---|
| 1 | Anak jarang membaca instruksi, mereka langsung mencoba | NN/g [1] | Instruksi diganti contoh bergerak dan suara, bukan paragraf |
| 2 | Anak 6-8 tahun masih belajar membaca | Kurikulum Fase A, bahasa Indonesia [8] | Semua soal kelas kecil punya tombol suara; kalimat paling banyak 8 kata |
| 3 | Jari anak kurang tepat menekan target kecil dan sering meleset | Anthony dkk. [3] | Target sentuh 64 dp kelas kecil, 48 dp kelas besar, jarak antartombol minimal 16 dp |
| 4 | Banyak pilihan sekaligus memperberat beban kognitif | Sweller [5] | Satu tombol utama per layar |
| 5 | Anak usia ini butuh benda dan gambar nyata untuk bernalar | Piaget [6], Bruner [7] | Kelas kecil memakai benda yang bisa diseret dan dihitung |
| 6 | Motivasi bertahan kalau anak merasa mampu, punya pilihan, dan dihargai | Teori determinasi diri [9] | Lencana karena usaha, bukan peringkat; tanpa leaderboard |
| 7 | Anak sulit membedakan iklan dan isi, dan rentan pola gelap | NN/g [1], UU PDP [10] | Tanpa iklan, tanpa tautan keluar, pengaturan dikunci gerbang orang tua |
| 8 | Data pribadi anak butuh persetujuan orang tua | UU PDP pasal 25 [10] | Data tetap di perangkat sampai wali menyetujui sinkronisasi |
| 9 | Anak 9-12 tahun tidak mau dianggap "anak kecil" | NN/g [1] | Kelas besar memakai gaya lebih ringkas, maskot lebih jarang muncul |

## 1. Dua kelompok yang berbeda

Rentang 6-12 tahun terlalu lebar untuk satu gaya tampilan. Nielsen Norman Group membagi
pengguna anak ke kelompok 3-5, 6-8, dan 9-12 tahun, dan menemukan perbedaan perilaku yang
besar antarkelompok [1]. Numi memakai pembagian yang hampir sama dengan kelompok belajar:

| Aspek | Kelas kecil (umumnya 6-8 tahun) | Kelas besar (umumnya 9-12 tahun) |
|---|---|---|
| Membaca | Baru lancar suku kata dan kalimat pendek | Lancar, bisa membaca soal cerita 2-3 kalimat |
| Motorik | Menekan dan menyeret masih kurang tepat | Sudah tepat, bisa mengetik angka |
| Perhatian | 5-10 menit per sesi | 10-20 menit per sesi |
| Cara berpikir | Butuh benda yang dilihat dan dipegang | Mulai nyaman dengan simbol |
| Yang disukai | Karakter, suara, animasi, warna cerah | Tantangan, koleksi, rasa "sudah besar" |
| Yang dihindari | Teks panjang, menu bertingkat | Tampilan yang terlihat kekanak-kanakan |

Kelompok di Numi tidak ditentukan dari umur, tetapi dari hasil diagnostic (doktek 2.2).
Anak 10 tahun yang masih lemah di penjumlahan akan masuk kelas kecil. Karena itu tampilan
kelas kecil tidak boleh terasa seperti aplikasi balita, supaya anak yang lebih tua tidak malu
memakainya. Caranya: maskot dan dunia pulau sama untuk kedua kelompok, yang berbeda hanya
bentuk soal, besar huruf, dan banyaknya bantuan.

## 2. Membaca dan instruksi

Anak jarang membaca petunjuk; mereka mencoba dulu, lalu menyerah kalau tidak berhasil [1].
Untuk anak yang baru belajar membaca, satu kalimat petunjuk pun bisa jadi hambatan.

Turunannya untuk Numi:

- Setiap soal kelas kecil punya tombol suara di kiri atas. Soal dibacakan otomatis sekali saat
  muncul, lalu bisa diulang dengan menekan tombol itu. Untuk MVP cukup memakai text-to-speech
  bawaan Android (paket `flutter_tts`), tidak perlu rekaman suara.
- Kalimat instruksi paling banyak 8 kata: "Ada berapa apel?", "Seret angka ke kotak."
- Cara menjawab dicontohkan dengan animasi tangan sekali di soal pertama tiap bentuk soal,
  bukan dengan teks.
- Angka ditulis dengan angka (7), bukan huruf (tujuh), kecuali soal memang tentang membaca
  lambang bilangan.

## 3. Sentuhan dan ukuran

Anak lebih sering meleset saat menekan target kecil dan saat menyeret dibanding orang dewasa
[3]. Pedoman Material Design menyarankan target minimal 48 dp untuk orang dewasa [4]; untuk
anak yang lebih kecil ukuran itu kurang.

| Elemen | Kelas kecil | Kelas besar |
|---|---|---|
| Tombol utama | tinggi 72 dp, lebar penuh | tinggi 56 dp, lebar penuh |
| Pilihan jawaban | 96 × 96 dp, paling banyak 4 | 72 dp tinggi, paling banyak 4 |
| Ikon sekunder (kembali, suara) | 56 dp | 48 dp |
| Jarak antartarget | 16 dp | 12 dp |
| Huruf soal | 32 sp | 24 sp |
| Huruf isi | 20 sp | 16 sp |

Seret-lepas diberi toleransi: kartu angka yang dilepas dalam jarak 40 dp dari kotak dianggap
masuk dan langsung "menempel" ke kotak. Tidak ada gerakan yang butuh dua jari, usap cepat,
atau tekan lama, kecuali gerbang orang tua yang memang sengaja dibuat sulit untuk anak.

## 4. Sedikit pilihan, satu tujuan per layar

Teori beban kognitif menjelaskan bahwa memori kerja terbatas, dan setiap elemen yang tidak
membantu tugas utama ikut memakan kapasitas itu [5]. Untuk anak, kapasitas ini lebih kecil
lagi. Layar yang memuat banyak tombol (dua lesson, mastery, legenda, statistik, tab, hapus
data) membuat anak bingung harus mulai dari mana, atau menekan acak.

Aturan yang dipakai:

- Satu layar, satu tombol utama yang besar dan bercahaya.
- Tombol lain hanya ikon kecil di pojok, paling banyak dua (kembali dan suara).
- Navigasi bawah dihapus. Peta adalah rumah; progres dibuka dengan mengetuk api streak atau
  bintang XP di bagian atas peta.
- Pilihan yang jarang dipakai anak (hapus data, rincian per topik) dipindah ke ruang orang
  tua.

## 5. Motivasi, umpan balik, dan kegagalan

Gamifikasi yang baik mendukung tiga kebutuhan dasar: merasa mampu, merasa punya pilihan,
dan merasa terhubung [9]. Poin dan peringkat yang membandingkan anak dengan anak lain bisa
menurunkan motivasi anak yang tertinggal, karena itu leaderboard sudah dikeluarkan dari
lingkup sejak doktek 1.3.

| Situasi | Yang dilakukan Numi | Yang dihindari |
|---|---|---|
| Jawaban benar | Banner hijau, suara "ting", +10 XP terbang ke bintang | Animasi panjang yang menahan anak lebih dari 1,5 detik |
| Jawaban salah | Banner kuning lembut, jawaban benar ditunjukkan dengan gambar, Numi ekspresi semangat | Merah besar, buzzer, nyawa berkurang, kata "SALAH" |
| Lesson belum lulus | "Hampir! Coba lagi dengan soal baru" | Mengunci pulau atau menunggu waktu |
| Lama tidak aktif | Numi sedih yang mengajak, sekali sehari | Notifikasi bertubi-tubi, rasa bersalah |
| Lencana | Diberikan karena usaha (rajin, teliti) dan capaian | Lencana yang hanya bisa didapat dengan membayar atau bersaing |

Catatan: doktek UC-004 menyebut banner merah untuk jawaban salah. Redesign menyarankan warna
koral muda (#FFE1E1 dengan teks #B23A3A) agar tidak terasa seperti hukuman. Perubahan ini
cukup di `banner_umpan_balik.dart` dan dicatat sebagai revisi UC-004.

## 6. Aturan desain Numi

Daftar periksa untuk setiap layar di Figma dan di kode.

1. Hanya ada satu tombol utama.
2. Ukuran mengikuti tabel bagian 3 sesuai kelompok.
3. Instruksi paling banyak 8 kata (kelas kecil) atau 2 kalimat (kelas besar).
4. Ada tombol suara di setiap soal kelas kecil.
5. Status selalu punya bentuk atau ikon, tidak hanya warna. Contoh: pulau terkunci memakai
   gembok dan kabut, pulau dikuasai memakai mercusuar menyala.
6. Kontras teks minimal 4,5:1 (WCAG AA). Teks putih di atas `#1B1F4B` aman; teks putih di atas
   `#FFB547` tidak, jadi tombol kuning memakai teks `#2A2350`.
7. Salah tidak dihukum, maskot tidak pernah memarahi.
8. Pengaturan dan data ada di balik gerbang orang tua.
9. Tidak ada iklan, tautan keluar, atau pembelian.
10. Animasi pendek (di bawah 1,5 detik) dan tidak menahan tombol berikutnya.

## 7. Cara menguji

Uji pengguna dilakukan di minggu 10-11 dengan 5 anak kelas kecil dan 5 anak kelas besar,
didampingi orang tua yang hanya mengamati. Pengamat mencatat:

- Apakah anak bisa menyelesaikan satu lesson tanpa bertanya (NFR-001).
- Berapa kali anak menekan tempat yang bukan tombol.
- Di layar mana anak berhenti atau melihat ke orang tua.
- Ekspresi anak saat salah menjawab.

Metode ini mengikuti cara NN/g mengamati anak tanpa banyak bertanya, karena anak cenderung
menjawab apa yang menurutnya ingin didengar orang dewasa [1][2].

## Rujukan

Periksa sendiri judul, penerbit, dan tahun setiap rujukan sebelum dimasukkan ke daftar
pustaka doktek.

1. Sherwin, K., & Nielsen, J. (2019). Children's UX: Usability Issues in Designing for Young People. Nielsen Norman Group. https://www.nngroup.com/articles/childrens-websites-usability-issues/
2. Hourcade, J. P. (2015). Child-Computer Interaction. CreateSpace. Versi awal: Foundations and Trends in Human-Computer Interaction, 1(4), 2008.
3. Anthony, L., Brown, Q., Nias, J., Tate, B., & Mohan, S. (2012). Interaction and recognition challenges in interpreting children's touch and gesture input on mobile devices. Proceedings of ACM ITS 2012, 225-234.
4. Google. Material Design 3: Accessibility, touch and pointer targets. https://m3.material.io/foundations/designing/structure
5. Sweller, J. (1988). Cognitive load during problem solving: Effects on learning. Cognitive Science, 12(2), 257-285.
6. Piaget, J. (1952). The Origins of Intelligence in Children. International Universities Press.
7. Bruner, J. S. (1966). Toward a Theory of Instruction. Harvard University Press.
8. Keputusan Kepala BSKAP No. 046/H/KR/2025 tentang Capaian Pembelajaran, CP Bahasa Indonesia Fase A.
9. Ryan, R. M., & Deci, E. L. (2000). Self-determination theory and the facilitation of intrinsic motivation, social development, and well-being. American Psychologist, 55(1), 68-78.
10. Undang-Undang Republik Indonesia Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi, pasal 25 tentang data pribadi anak.
11. W3C. (2018). Web Content Accessibility Guidelines (WCAG) 2.1, kriteria 1.4.1 dan 1.4.3.
