# UML Numi

## Status revisi 29 Oktober 2026

Diagram pada `src/` mempertahankan struktur implementasi dan rancangan lama. Sebagian masih memuat perilaku kode seperti kelompok global, ambang 95, dan feedback mastery per butir; perilaku tersebut belum sesuai target kurikulum. Gunakan `target-v3-2026-10-29/` sebagai spesifikasi rancangan terbaru. Nama kelas target sengaja dibedakan dari kelas Dart yang tersedia. Kode aplikasi belum diperbarui dalam audit ini.

Rancangan target menambahkan usia 6–12 tahun, memisahkan bukti kemampuan dari akses materi, menyimpan respons dan checkpoint, menunda pembahasan tes sampai blok selesai, serta menetapkan siswa dan wali sebagai aktor aplikasi. Guru tetap validator di luar aplikasi selama belum ada portal guru. Klaim penguasaan seluruh Matematika SD tidak didukung cakupan MVP dua belas topik.

Catatan perubahan lama di bawah adalah riwayat keputusan. Pernyataan bahwa diagnostic harus diulang dari awal dan penyimpanan checkpoint tidak bermanfaat telah digantikan oleh rancangan target v3.

Sumber setiap diagram ada di `src/*.puml`. Hasil render ada di `png/` (untuk ditempel ke
doktek) dan `svg/` (bisa diperbesar tanpa pecah). Nama kelas, method, dan konstanta di
diagram sama persis dengan kode di `app/lib`, jadi kalau kode berubah, diagram yang terkait
juga harus diubah.

Use case diagram dan alur pengguna versi rapi ada juga di Figma, halaman `user flow`.

## Daftar diagram

| ID | Jenis | Isi | Use case | Kebutuhan |
|---|---|---|---|---|
| UCD-001 | Use case | Seluruh use case dan aktor | UC-001 s.d. UC-010 | semua FR |
| ACT-001 | Activity | Pendaftaran sampai skill map awal | UC-008, UC-001 | FR-001, FR-002 |
| ACT-002 | Activity | Lesson dan feedback | UC-003, UC-004, UC-010 | FR-004a, FR-004b, FR-005, FR-006 |
| ACT-003 | Activity | Mastery test | UC-005 | FR-007 |
| ACT-004 | Activity | Pembaruan XP, streak, lencana | UC-010 | FR-006, FR-008 |
| ACT-005 | Activity | Pemicu pesan maskot | UC-007 | FR-009 |
| SEQ-001 | Sequence | Diagnostic test adaptif | UC-001 | FR-001 |
| SEQ-002 | Sequence | Lesson dan feedback | UC-003, UC-004 | FR-004a, FR-004b, FR-005 |
| SEQ-003 | Sequence | Pesan maskot | UC-007 | FR-009 |
| SEQ-004 | Sequence | Pendaftaran | UC-008 | NFR-005, DATA-001 |
| SEQ-005 | Sequence | Mastery test | UC-005 | FR-007 |
| SEQ-006 | Sequence | Melihat progress | UC-006 | FR-008 |
| CLS-001 | Class | Model domain (entitas ERD) | semua | DATA-001 s.d. DATA-005 |
| CLS-002 | Class | Logika, state, repository | semua | FR-001 s.d. FR-009 |
| CLS-003 | Class | Lapisan tampilan | semua | NFR-001 |
| STM-001 | State | Status topik di skill map | UC-002, UC-005 | FR-002, FR-007 |
| STM-002 | State | Sesi soal | UC-003, UC-004 | FR-005 |
| STM-003 | State | Streak harian | UC-010, UC-007 | FR-006, FR-009 |
| STM-004 | State | Ekspresi maskot | UC-007 | FR-009 |
| CMP-001 | Component | Komponen sistem doktek 2.1 | semua | NFR-003 |
| DPL-001 | Deployment | APK, penyimpanan lokal, Firebase | semua | NFR-003, NFR-004 |
| PKG-001 | Package | Struktur folder `app/lib` | semua | - |
| ERD-001 | ERD | Skema data | semua | DATA-001 s.d. DATA-005 |

Skenario per use case (`ucs-001` s.d. `ucs-010`) menggambarkan spesifikasi UC-001 sampai
UC-010 sebagai diagram: jalur aktor dan sistem, prasyarat di awal, alur alternatif bertanda
catatan, dan pascakondisi di akhir. Di doktek dipakai sebagai Gambar 2.9 sampai 2.18. Semua
gambar doktek juga dikumpulkan di Figma, halaman `doktek gambar`.

## Render ulang

Butuh Java dan PlantUML. Di laptop ini keduanya ada di `D:\khalee\tools`, bersama Graphviz
sebagai mesin tata letak.

```bash
set GRAPHVIZ_DOT=D:\khalee\tools\graphviz\Graphviz-16.1.0-win64\bin\dot.exe
java -jar D:\khalee\tools\plantuml.jar -charset UTF-8 -tpng -o ..\png src\*.puml
```

## Perubahan dari doktek v1.1

| Temuan | Dasar | Tindakan |
|---|---|---|
| Pendaftaran dan login (NFR-005, DATA-001) belum punya use case | Setiap kebutuhan di RTM harus bisa ditelusuri ke use case (doktek bab 5) | UC-008 ditambahkan |
| FR-003 dan FR-006 tidak punya use case sendiri | Sama dengan di atas | UC-009 dan UC-010 dipisah sebagai include |
| UC-001 meng-include UC-004, jadi diagnostic memberi tahu benar atau salah | Tes penempatan mengukur kemampuan awal; membuka jawaban di tengah tes membuat siswa belajar selama tes dan hasilnya jadi lebih tinggi dari kemampuan sebenarnya | Diagnostic tanpa umpan balik, UC-001 tidak lagi include UC-004 |
| Doktek menyebut diagnostic yang terputus bisa dilanjutkan | Hasil yang baru separuh belum cukup untuk menentukan kelompok belajar, dan menyimpan posisi tengah tes menambah kerumitan tanpa manfaat berarti untuk tes sekitar 12 soal | Diagnostic yang terputus diulang dari awal |
| ERD belum punya tempat menyimpan hasil mastery test | FR-007 menuntut status topik berubah berdasarkan skor mastery | Entitas MasteryResult ditambahkan |
| Tabel Badge bernama sama dengan widget Flutter | Nama bentrok membuat impor ambigu | Di kode dinamai Lencana dan SiswaLencana, catatan di CLS-001 |
| Class diagram lama tidak memuat logika diagnostic, learning path, dan maskot | Diagram harus menggambarkan kode yang benar-benar ada | CLS-002 dan CLS-003 dibuat dari kode |

## Spesifikasi use case

Isi UC-001 sampai UC-007 mengikuti doktek bagian 1.8 dengan penyesuaian di atas.

### UC-001 Mengerjakan diagnostic test

- Aktor: Siswa
- Prasyarat: profil sudah terisi (UC-008).
- Alur utama: sistem memilih topik awal dari umur, lalu memberi dua soal per topik. Kalau
  keduanya benar, tes naik ke topik berikutnya. Kalau salah di topik awal, tes turun ke topik
  sebelumnya sampai menemukan topik yang dikuasai. Jawaban dicatat tanpa ditunjukkan benar
  atau salahnya.
- Alur alternatif: kalau siswa keluar di tengah tes, tes dimulai lagi dari awal saat aplikasi
  dibuka, karena hasil setengah jalan belum cukup untuk menentukan kelompok belajar.
- Pascakondisi: skill map awal dan kelompok belajar tersimpan (ACT-001, SEQ-001).

### UC-002 Melihat skill map

- Aktor: Siswa
- Prasyarat: diagnostic selesai.
- Alur utama: siswa membuka peta; sistem menampilkan 12 pulau dengan status terkunci, belum
  dikuasai, perlu latihan, atau dikuasai (STM-001), serta pulau yang disarankan (UC-009).
- Alur alternatif: pulau terkunci menampilkan daftar pulau prasyarat.
- Pascakondisi: siswa tahu topik yang perlu dipelajari.

### UC-003 Mengerjakan lesson

- Aktor: Siswa
- Prasyarat: topik tidak terkunci.
- Alur utama: siswa memilih lesson, membaca penjelasan maskot (lesson kenalan), lalu
  mengerjakan lima soal sesuai kelompok belajarnya. Setiap soal memanggil UC-004.
- Alur alternatif: kalau benar kurang dari tiga, lesson belum selesai dan sistem menawarkan
  mengulang dengan soal baru.
- Pascakondisi: progres lesson, XP, dan streak tersimpan (UC-010).

### UC-004 Menerima feedback

- Aktor: Siswa (dipicu sistem)
- Prasyarat: siswa menekan Cek Jawaban di lesson atau mastery test.
- Alur utama: sistem menampilkan banner hijau dengan +10 XP bila benar, atau banner merah
  berisi jawaban benar dan penjelasan bila salah.
- Pascakondisi: siswa tahu letak kesalahannya.

### UC-005 Mengerjakan mastery test

- Aktor: Siswa
- Prasyarat: kedua lesson topik sudah selesai.
- Alur utama: siswa mengerjakan lima soal tingkat 2; sistem menghitung skor.
- Alur alternatif: skor di bawah 95, status tetap perlu latihan.
- Pascakondisi: skor 95 atau lebih mengubah status menjadi dikuasai dan membuka topik yang
  prasyaratnya lengkap (ACT-003, SEQ-005).

### UC-006 Melihat progress belajar

- Aktor: Siswa, Orang Tua / Wali
- Prasyarat: siswa sudah terdaftar.
- Alur utama: sistem menampilkan level, XP, streak tujuh hari, statistik, dan lencana.
- Alur alternatif: orang tua membuka bagian "Untuk orang tua" untuk melihat status tiap topik
  dan persentase jawaban benar.
- Pascakondisi: pengguna mengetahui capaian belajar.

### UC-007 Menerima pesan maskot

- Aktor: Siswa, Penjadwal Notifikasi
- Prasyarat: diagnostic selesai.
- Alur utama: saat aplikasi dibuka, sistem memeriksa aktivitas terakhir dan streak, memilih
  pesan sambutan, streak terancam, atau lama tidak aktif, lalu Numi muncul dengan balon kata.
- Alur alternatif: kalau pesan jenis yang sama sudah muncul hari ini, tidak ada pesan.
- Pascakondisi: pesan tersimpan dan ditandai dibaca (ACT-005, SEQ-003).

### UC-008 Mendaftar dan mengisi profil

- Aktor: Siswa, Orang Tua / Wali
- Prasyarat: aplikasi baru dipasang atau data sudah dihapus.
- Alur utama: siswa melihat tiga layar cerita, lalu mengisi nama dan memilih umur 6 sampai 12.
- Pascakondisi: profil tersimpan, siswa diarahkan ke diagnostic (SEQ-004).

### UC-009 Melihat rekomendasi learning path

- Aktor: Siswa
- Prasyarat: bagian dari UC-002.
- Alur utama: sistem memilih topik yang sedang dilatih, atau topik terbuka dengan urutan
  paling awal, lalu Numi melayang di atas pulau itu.
- Pascakondisi: siswa tahu pulau mana yang sebaiknya dikerjakan berikutnya.

### UC-010 Memperoleh XP, streak, dan lencana

- Aktor: Siswa
- Prasyarat: bagian dari UC-003 atau UC-005.
- Alur utama: sistem menambah XP, mencatat hari aktif, memeriksa delapan syarat lencana dan
  kenaikan level, lalu memilih pesan maskot (ACT-004).
- Pascakondisi: XP, streak, dan lencana baru tersimpan.
