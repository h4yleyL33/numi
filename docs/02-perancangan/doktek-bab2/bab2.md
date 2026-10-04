# 2. DESIGN / PERANCANGAN

Bab ini menerjemahkan kebutuhan di Bab 1 menjadi rancangan teknis. Setiap keputusan desain diberi kode kebutuhan (FR, NFR, DATA) dan kode use case (UC) supaya bisa ditelusuri sampai RTM di Bab 5. Seluruh diagram dibuat dengan PlantUML; sumbernya ada di repositori proyek pada folder `docs/02-perancangan/uml`, dan nama kelas, method, serta konstanta di diagram sama dengan kode aplikasi di `app/lib`.

Dibanding versi 1.1, bab ini memuat beberapa perubahan hasil penelusuran ulang kebutuhan. Ringkasannya ada di bagian 2.3.1.

## 2.1 Arsitektur Perangkat Lunak

Numi adalah aplikasi Android yang dibangun dengan Flutter dan disusun berlapis: lapisan tampilan, lapisan state, lapisan logika domain, dan lapisan data. Lapisan data diakses lewat satu kontrak, `NumiRepository`. Saat ini kontrak itu diisi oleh `LocalNumiRepository` yang menyimpan data di perangkat, sehingga aplikasi tetap bisa dipakai tanpa internet. Setelah proyek Firebase tim siap, kontrak yang sama diisi oleh `FirestoreNumiRepository` tanpa mengubah tampilan maupun logika. Dengan begitu pola Client-Server berbasis Backend-as-a-Service (BaaS) yang direncanakan sejak versi 1.0 tetap menjadi arah akhir, tetapi pengembangan tidak tertahan menunggu backend.

Pertimbangan pemilihan arsitektur ini adalah tim kecil (lima orang), jadwal satu semester (September sampai Desember 2026), kebutuhan agar progres tidak hilang saat aplikasi tertutup tiba-tiba (NFR-003), dan kebutuhan agar data anak tidak keluar dari perangkat sebelum ada autentikasi (NFR-005).

### Technology Stack

| Bagian | Pilihan | Alasan |
|---|---|---|
| Platform | Android (APK), minimal Android 7.0 | Perangkat yang paling banyak dipakai target pengguna (NFR-004) |
| Frontend | Flutter 3, Dart 3 | UI kustom kaya animasi (peta pulau, seret-lepas, maskot), satu basis kode bila nanti diperluas ke iOS |
| State management | Riverpod (`flutter_riverpod`) | Satu `NumiController` sebagai sumber state, mudah diuji tanpa tampilan |
| Penyimpanan lokal | `shared_preferences`, data disimpan sebagai JSON dengan kunci `numi.data_belajar.v1` | Progres tersimpan setiap aktivitas selesai (NFR-003) |
| Backend (rencana) | Firebase Authentication, Cloud Firestore, Cloud Functions, Cloud Messaging | Tanpa server sendiri, cocok untuk tugas kuliah, mendukung sinkronisasi |
| Animasi maskot | `CustomPainter` (berkedip, melayang, sayap mengepak, enam ekspresi) | Rive di versi 1.0 diganti agar tidak bergantung pada berkas animasi eksternal; bila tim membuat berkas Rive, ekspresinya mengikuti enam nama yang sama |
| Soal | Dibangkitkan dari templat per topik (`GeneratorSoal`) | Tim tidak perlu menulis ratusan soal, dan siswa tidak menghafal soal saat mengulang |

### Komponen Sistem

| Komponen | Fungsi | Letak di kode | Requirement Terkait |
|---|---|---|---|
| App Siswa (Flutter) | Antarmuka diagnostic test, skill map, lesson, mastery, progres, maskot | `features/*` | NFR-001, NFR-002 |
| Auth Service | Registrasi profil siswa (nama, umur); login Firebase menyusul | `features/onboarding`, Firebase Authentication | NFR-005, DATA-001 |
| Diagnostic Engine | Menyajikan dua soal per topik secara adaptif, menghitung hasil, menentukan kelompok belajar | `domain/diagnostic_engine.dart` | FR-001 |
| Skill Map Service | Menentukan status tiap topik dari hasil diagnostic, lesson, dan mastery test | `domain/skill_map_service.dart` | FR-002, FR-007 |
| Content Service | Menyediakan 12 topik, 24 lesson, 8 lencana, kalimat maskot, dan generator soal | `data/content/*` | FR-004a, FR-004b, DATA-002 |
| Learning Path Service | Memilih topik yang disarankan berikutnya | `domain/learning_path_service.dart` | FR-003 |
| Progress Service | Menghitung XP, level, streak, dan lencana | `domain/progress_service.dart` | FR-006, FR-008 |
| Companion Service | Memilih pesan maskot sesuai kondisi siswa | `domain/companion_service.dart` | FR-009 |
| Repository | Membaca dan menulis data belajar | `data/repositories/*` | NFR-003, DATA-001 s.d. DATA-005 |

![CMP-001 Component diagram](../uml/png/cmp-001-komponen.png)

![DPL-001 Deployment diagram](../uml/png/dpl-001-deployment.png)

![PKG-001 Package diagram struktur folder app/lib](../uml/png/pkg-001-paket.png)

## 2.2 Rancangan UI/UX

Rancangan visual lengkap (aset, layar, use case diagram, dan alur pengguna) ada di Figma: https://www.figma.com/design/yNC8dWGVTz3wedUvSwIAMW/numi. Halaman `asset` berisi warna, tipografi, maskot, pulau, komponen, dan lencana; halaman `ui` berisi layar aplikasi; halaman `user flow` berisi use case diagram dan alur pengguna.

### Dunia dan cerita

Numi memakai cerita Samudra Angka. Ada dua belas pulau di lautan malam, dan setiap pulau mewakili satu topik numerasi. Kabut Lupa memadamkan mercusuar semua pulau, dan Numi, kunang-kunang penjaga cahaya, meminta bantuan siswa untuk menyalakannya kembali. Setiap unsur cerita punya padanan di aplikasi, sehingga cerita tidak sekadar hiasan.

| Di cerita | Di aplikasi | Kebutuhan |
|---|---|---|
| Membaca peta sebelum berlayar | Diagnostic test | FR-001 |
| Pulau gelap, redup, terang | Status topik di skill map | FR-002 |
| Numi melayang di atas satu pulau | Rekomendasi learning path | FR-003 |
| Mengumpulkan cahaya di pulau | Lesson dan XP | FR-004a, FR-004b, FR-006 |
| Menyalakan mercusuar | Mastery test lulus | FR-007 |
| Nyala api Numi | Streak harian | FR-006 |
| Numi mengantuk saat apinya redup | Pengingat streak | FR-009 |
| Lencana penjelajah | Badge | FR-006 |

Kunang-kunang dipilih karena gagasan "cahaya yang tumbuh" mudah dipahami anak: makin banyak belajar, makin terang. Kegagalan digambarkan sebagai cahaya yang belum menyala, bukan hukuman (NFR-001). Latar malam juga membuat status pulau mudah dibedakan sekilas.

### Maskot

| Ekspresi | Dipakai saat |
|---|---|
| Senang | Sapaan harian, splash, form profil |
| Berpikir | Pembuka diagnostic, poin penjelasan lesson |
| Semangat | Jawaban salah, lesson atau mastery belum berhasil |
| Sedih | Siswa tidak aktif 3 hari atau lebih |
| Mengantuk | Streak terancam putus |
| Bangga | Lesson selesai, mercusuar menyala, lencana baru |

Maskot tidak pernah memarahi. Saat siswa salah, ekspresi yang dipakai adalah semangat, bukan sedih (FR-009, NFR-001).

### User Flow Utama

1. Onboarding. Siswa melihat tiga layar cerita, lalu mengisi nama dan memilih umur 6 sampai 12 (UC-008). Umur hanya data profil dan titik awal diagnostic, bukan penentu materi.
2. Diagnostic test. Sistem memulai dari topik yang sesuai umur, memberi dua soal per topik, naik bila keduanya benar dan turun bila salah, paling banyak enam topik. Jawaban tidak ditunjukkan benar atau salahnya (UC-001).
3. Hasil diagnostic. Sistem menyusun skill map awal dan menentukan kelompok belajar dari topik pertama yang belum dikuasai: T01-T06 kelas kecil, T07-T12 kelas besar.
4. Skill map. Siswa melihat 12 pulau dengan status terkunci, belum dikuasai, perlu latihan, atau dikuasai (UC-002).
5. Learning path. Numi melayang di atas pulau yang disarankan (UC-009).
6. Lesson. Setiap pulau punya dua lesson: Kenalan (penjelasan maskot lalu 5 soal) dan Latihan (5 soal). Setiap jawaban langsung diberi umpan balik (UC-003, UC-004).
7. Mastery test. Setelah kedua lesson selesai, siswa mengerjakan 5 soal. Skor 95 ke atas menyalakan mercusuar dan membuka pulau yang prasyaratnya lengkap (UC-005).
8. Progres dan maskot. Siswa melihat level, XP, streak, dan lencana; orang tua melihat rincian per topik. Numi menyapa saat aplikasi dibuka, mengingatkan saat streak terancam, atau mengajak kembali setelah lama tidak aktif (UC-006, UC-007, UC-010).

### Pemetaan kurikulum

Materi mengacu ke Capaian Pembelajaran Matematika Kurikulum Merdeka, Keputusan Kepala BSKAP No. 046/H/KR/2025, elemen Bilangan, ditambah makna tanda "=" dari elemen Aljabar. Elemen Pengukuran, Geometri, serta Analisis Data dan Peluang di luar lingkup (Bab 1.3).

| ID | Topik | Pulau | Fase | Kelompok | Prasyarat |
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

Dibanding pembagian di Bab 1.3, ada dua penyesuaian. Pecahan setengah dan seperempat masuk kelas kecil karena di CP diajarkan di Fase A (kelas 1-2), dan perkalian menjadi pintu masuk kelas besar karena berada di Fase B. Pembagian besarnya tetap sama: kelas kecil untuk bilangan, penjumlahan, dan pengurangan; kelas besar untuk perkalian, pembagian, dan pecahan lanjutan. Prasyarat dibuat bercabang (hierarki belajar Gagne) supaya siswa yang macet di satu topik masih punya topik lain yang terbuka.

### Bentuk soal per kelompok

Anak usia 7-11 tahun berada di tahap operasional konkret (Piaget) dan masih butuh benda atau gambar. Karena itu bentuk soal dibedakan mengikuti pendekatan konkret, gambar, simbol (Bruner).

| Bentuk soal | Kelas kecil | Kelas besar | Contoh |
|---|---|---|---|
| Hitung benda | ya | - | "Ada berapa apel?" dengan gambar apel |
| Seret ke kotak | ya | ya | 8 + ☐ = 13, kartu angka diseret ke kotak |
| Pasangkan | ya | - | 3 + 2 dipasangkan dengan 5 |
| Bandingkan | ya | ya | pilih <, =, atau > |
| Pecahan bergambar | ya | ya | "Bagian yang diwarnai adalah?" |
| Pilihan angka | ya | ya | 6 × 7 = ? |
| Soal cerita | - | ya | "Bu Sari punya 48 kue, dibagi rata ke 6 piring..." |

Soal di SD tidak memakai variabel huruf. Bentuk 2x + 4 = ? di wireframe lama diganti kotak kosong, misalnya 2 × ☐ + 4 = 14.

### Prinsip tampilan

| Prinsip | Penerapan | Kebutuhan |
|---|---|---|
| Satu layar, satu tombol utama | Tombol utama besar di bawah; tombol lain berupa ikon kecil | NFR-001 |
| Target sentuh besar | Minimal 64 dp untuk kelas kecil, 48 dp untuk kelas besar | NFR-001 |
| Teks pendek | Instruksi paling banyak 8 kata untuk kelas kecil | NFR-001 |
| Status tidak hanya warna | Pulau terkunci memakai kabut dan gembok, pulau dikuasai memakai mercusuar menyala | FR-002 |
| Salah tidak dihukum | Tanpa nyawa dan tanpa buzzer; Numi memakai ekspresi semangat | FR-005, FR-009 |
| Latar mudah dibaca | Latar malam di peta, latar krem di layar soal | NFR-001 |
| Aman untuk anak | Tanpa iklan, tanpa tautan keluar, tanpa leaderboard | NFR-006 |

Kajian UI untuk anak dan rancangan ulang layar yang lebih ringkas ada di folder `prd/` repositori (PRD, kajian UI anak, kurikulum kelas 1-3 dan 4-6, serta mockup).

### Palet warna

| Peran | Warna |
|---|---|
| Malam (latar peta) | #1B1F4B |
| Laut | #243B8F |
| Cahaya (aksen utama) | #FFB547 |
| Cahaya muda | #FFD98A |
| Krem (latar soal) | #FFF8EC |
| Tinta (teks) | #232347 |
| Benar | #2EBD8E |
| Salah | #FF6B6B |

## 2.3 UML Design

Diagram disusun per jenis. Kolom use case dan kebutuhan di setiap diagram dipakai untuk traceability di bagian 2.6.

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
| CMP-001 | Component | Komponen sistem (bagian 2.1) | semua | NFR-003 |
| DPL-001 | Deployment | APK, penyimpanan lokal, Firebase | semua | NFR-003, NFR-004 |
| PKG-001 | Package | Struktur folder app/lib | semua | - |
| ERD-001 | ERD | Skema data (bagian 2.4) | semua | DATA-001 s.d. DATA-005 |

### 2.3.1 Perubahan dari versi 1.1

| Temuan | Dasar | Tindakan |
|---|---|---|
| Pendaftaran dan login (NFR-005, DATA-001) belum punya use case | Setiap kebutuhan di RTM harus bisa ditelusuri ke use case | UC-008 ditambahkan |
| FR-003 dan FR-006 tidak punya use case sendiri | Sama dengan di atas | UC-009 dan UC-010 dipisah sebagai include |
| UC-001 meng-include UC-004, sehingga diagnostic memberi tahu benar atau salah | Tes penempatan mengukur kemampuan awal; membuka jawaban di tengah tes membuat siswa belajar selama tes dan hasilnya lebih tinggi dari kemampuan sebenarnya | Diagnostic tanpa umpan balik, UC-001 tidak lagi include UC-004 |
| Versi 1.1 menyebut diagnostic yang terputus bisa dilanjutkan | Hasil setengah jalan belum cukup untuk menentukan kelompok belajar, dan menyimpan posisi tengah tes menambah kerumitan untuk tes sekitar 12 soal | Diagnostic yang terputus diulang dari awal |
| ERD belum punya tempat menyimpan hasil mastery test | FR-007 menuntut status topik berubah berdasarkan skor mastery | Entitas MasteryResult ditambahkan |
| Tabel Badge bernama sama dengan widget Flutter | Nama bentrok membuat impor ambigu | Di kode dinamai Lencana dan SiswaLencana |
| Class diagram lama tidak memuat logika diagnostic, learning path, dan maskot | Diagram harus menggambarkan kode yang benar-benar ada | CLS-002 dan CLS-003 dibuat dari kode |
| Orang tua belum menjadi aktor | Bab 1.2 menyebut orang tua ingin mengetahui perkembangan anak | Orang Tua / Wali menjadi aktor UC-006 dan UC-008 |

### 2.3.2 Use Case Diagram

![UCD-001 Use case diagram](../uml/png/ucd-001-use-case.png)

| Use Case ID | Nama Use Case | Actor | Deskripsi Singkat |
|---|---|---|---|
| UC-001 | Mengerjakan Diagnostic Test | Siswa | Siswa mengerjakan tes adaptif untuk mengukur kemampuan awal |
| UC-002 | Melihat Skill Map | Siswa | Siswa melihat status 12 pulau |
| UC-003 | Mengerjakan Lesson | Siswa | Siswa mengikuti lesson sesuai kelompok belajar |
| UC-004 | Menerima Feedback | Siswa (dipicu sistem) | Sistem memberi umpan balik atas jawaban lesson dan mastery |
| UC-005 | Mengerjakan Mastery Test | Siswa | Siswa memvalidasi penguasaan satu topik |
| UC-006 | Melihat Progress Belajar | Siswa, Orang Tua / Wali | Melihat level, XP, streak, lencana, dan status topik |
| UC-007 | Menerima Pesan Maskot | Siswa, Penjadwal Notifikasi | Numi menampilkan pesan motivasi atau pengingat |
| UC-008 | Mendaftar dan Mengisi Profil | Siswa, Orang Tua / Wali | Mengisi nama dan umur setelah cerita pembuka |
| UC-009 | Melihat Rekomendasi Learning Path | Siswa | Sistem menandai pulau yang sebaiknya dikerjakan berikutnya (include dari UC-002) |
| UC-010 | Memperoleh XP, Streak, dan Lencana | Siswa | Sistem memperbarui reward setelah aktivitas (include dari UC-003 dan UC-005) |

Spesifikasi use case:

**UC-001 Mengerjakan Diagnostic Test**

- Aktor: Siswa
- Prasyarat: profil sudah terisi (UC-008).
- Alur utama: sistem memilih topik awal dari umur, lalu memberi dua soal per topik. Kalau keduanya benar, tes naik ke topik berikutnya. Kalau salah di topik awal, tes turun ke topik sebelumnya sampai menemukan topik yang dikuasai. Jawaban dicatat tanpa ditunjukkan benar atau salahnya.
- Alur alternatif: kalau siswa keluar di tengah tes, tes dimulai lagi dari awal saat aplikasi dibuka.
- Pascakondisi: skill map awal dan kelompok belajar tersimpan (ACT-001, SEQ-001).

**UC-002 Melihat Skill Map**

- Aktor: Siswa
- Prasyarat: diagnostic selesai.
- Alur utama: siswa membuka peta; sistem menampilkan 12 pulau dengan status terkunci, belum dikuasai, perlu latihan, atau dikuasai (STM-001), serta pulau yang disarankan (UC-009).
- Alur alternatif: pulau terkunci menampilkan daftar pulau prasyarat.
- Pascakondisi: siswa tahu topik yang perlu dipelajari.

**UC-003 Mengerjakan Lesson**

- Aktor: Siswa
- Prasyarat: topik tidak terkunci.
- Alur utama: siswa memilih lesson, membaca penjelasan maskot (lesson Kenalan), lalu mengerjakan lima soal sesuai kelompok belajarnya. Setiap soal memanggil UC-004.
- Alur alternatif: kalau benar kurang dari tiga, lesson belum selesai dan sistem menawarkan mengulang dengan soal baru.
- Pascakondisi: progres lesson, XP, dan streak tersimpan (UC-010).

**UC-004 Menerima Feedback**

- Aktor: Siswa (dipicu sistem)
- Prasyarat: siswa menekan Cek Jawaban di lesson atau mastery test.
- Alur utama: sistem menampilkan banner hijau dengan +10 XP bila benar, atau banner berisi jawaban benar dan penjelasan bila salah.
- Pascakondisi: siswa tahu letak kesalahannya.

**UC-005 Mengerjakan Mastery Test**

- Aktor: Siswa
- Prasyarat: kedua lesson topik sudah selesai.
- Alur utama: siswa mengerjakan lima soal tingkat 2; sistem menghitung skor.
- Alur alternatif: skor di bawah 95, status tetap perlu latihan.
- Pascakondisi: skor 95 atau lebih mengubah status menjadi dikuasai dan membuka topik yang prasyaratnya lengkap (ACT-003, SEQ-005).

**UC-006 Melihat Progress Belajar**

- Aktor: Siswa, Orang Tua / Wali
- Prasyarat: siswa sudah terdaftar.
- Alur utama: sistem menampilkan level, XP, streak tujuh hari, statistik, dan lencana.
- Alur alternatif: orang tua membuka bagian "Untuk orang tua" untuk melihat status tiap topik dan persentase jawaban benar.
- Pascakondisi: pengguna mengetahui capaian belajar.

**UC-007 Menerima Pesan Maskot**

- Aktor: Siswa, Penjadwal Notifikasi
- Prasyarat: diagnostic selesai.
- Alur utama: saat aplikasi dibuka, sistem memeriksa aktivitas terakhir dan streak, memilih pesan sambutan, streak terancam, atau lama tidak aktif, lalu Numi muncul dengan balon kata.
- Alur alternatif: kalau pesan jenis yang sama sudah muncul hari ini, tidak ada pesan.
- Pascakondisi: pesan tersimpan dan ditandai dibaca (ACT-005, SEQ-003).

**UC-008 Mendaftar dan Mengisi Profil**

- Aktor: Siswa, Orang Tua / Wali
- Prasyarat: aplikasi baru dipasang atau data sudah dihapus.
- Alur utama: siswa melihat tiga layar cerita, lalu mengisi nama dan memilih umur 6 sampai 12.
- Pascakondisi: profil tersimpan, siswa diarahkan ke diagnostic (SEQ-004).

**UC-009 Melihat Rekomendasi Learning Path**

- Aktor: Siswa
- Prasyarat: bagian dari UC-002.
- Alur utama: sistem memilih topik yang sedang dilatih, atau topik terbuka dengan urutan paling awal, lalu Numi melayang di atas pulau itu.
- Pascakondisi: siswa tahu pulau mana yang sebaiknya dikerjakan berikutnya.

**UC-010 Memperoleh XP, Streak, dan Lencana**

- Aktor: Siswa
- Prasyarat: bagian dari UC-003 atau UC-005.
- Alur utama: sistem menambah XP, mencatat hari aktif, memeriksa delapan syarat lencana dan kenaikan level, lalu memilih pesan maskot (ACT-004).
- Pascakondisi: XP, streak, dan lencana baru tersimpan.

### 2.3.3 Activity Diagram

![ACT-001 Pendaftaran sampai skill map awal](../uml/png/act-001-pendaftaran-diagnostic.png)

![ACT-002 Lesson dan feedback](../uml/png/act-002-lesson.png)

![ACT-003 Mastery test](../uml/png/act-003-mastery.png)

![ACT-004 Pembaruan XP, streak, dan lencana](../uml/png/act-004-gamifikasi.png)

![ACT-005 Pemicu pesan maskot](../uml/png/act-005-pesan-maskot.png)

### 2.3.4 Sequence Diagram

![SEQ-001 Mengerjakan diagnostic test (UC-001)](../uml/png/seq-001-diagnostic.png)

![SEQ-002 Mengerjakan lesson dan feedback (UC-003, UC-004)](../uml/png/seq-002-lesson-feedback.png)

![SEQ-003 Pesan maskot (UC-007)](../uml/png/seq-003-pesan-maskot.png)

![SEQ-004 Pendaftaran (UC-008)](../uml/png/seq-004-pendaftaran.png)

![SEQ-005 Mastery test (UC-005)](../uml/png/seq-005-mastery.png)

![SEQ-006 Melihat progress (UC-006)](../uml/png/seq-006-progress.png)

### 2.3.5 Class Diagram

![CLS-001 Model domain](../uml/png/cls-001-domain.png)

![CLS-002 Logika, state, dan repository](../uml/png/cls-002-aplikasi.png)

![CLS-003 Lapisan tampilan](../uml/png/cls-003-tampilan.png)

### 2.3.6 State Diagram

![STM-001 Status topik di skill map](../uml/png/stm-001-status-topik.png)

![STM-002 Sesi soal](../uml/png/stm-002-sesi-soal.png)

![STM-003 Streak harian](../uml/png/stm-003-streak.png)

![STM-004 Ekspresi maskot](../uml/png/stm-004-ekspresi-maskot.png)

### 2.3.7 Aturan belajar

Angka-angka yang dipakai diagram di atas dikumpulkan di satu berkas, `app/lib/core/config/app_config.dart`, supaya mudah diubah tim.

| Aturan | Nilai |
|---|---|
| Soal per lesson | 5 |
| Benar minimal agar lesson selesai | 3 |
| Soal mastery test | 5 |
| Ambang lulus mastery test | 95 |
| Soal diagnostic per topik | 2 |
| Topik maksimal yang diuji saat diagnostic | 6 |
| XP per jawaban benar | 10 |
| XP lesson selesai | 20 |
| XP mastery lulus | 50 |
| XP per level | 100 |
| Batas lesson cepat (lencana Cepat) | 2 menit |

Catatan: ambang 95 dengan 5 soal berarti siswa harus benar semua. Model mastery learning Bloom umumnya memakai ambang 80-90 persen. Nilai 95 dipertahankan sesuai state diagram, dan akan ditinjau setelah uji pengguna.

## 2.4 Database Design / ERD

![ERD-001 Entity relationship diagram](../uml/png/erd-001.png)

| Entitas | Atribut Utama | Relasi | Data Req. |
|---|---|---|---|
| Siswa | id_siswa (PK), nama, usia, kelompok_belajar, dibuat_pada | 1-N ke SkillMap, DiagnosticResult, LessonProgress, MasteryResult, Jawaban, Siswa_Badge, StreakLog, CompanionMessage | DATA-001 |
| Topik | id_topik (PK), urutan, nama_topik, nama_pulau, fase_kurikulum_merdeka, kelompok | 1-N ke Lesson, Soal, SkillMap; N-N ke dirinya lewat Prasyarat_Topik | DATA-002 |
| Prasyarat_Topik | id_topik (PK, FK), id_prasyarat (PK, FK) | N-1 ke Topik (dua kali) | DATA-002 |
| Lesson | id_lesson (PK), id_topik (FK), judul, tipe (kenalan/latihan) | N-1 ke Topik | DATA-002 |
| Soal | id_soal (PK), id_topik (FK), jenis_latihan, tingkat_kesulitan, jawaban_benar | N-1 ke Topik | DATA-002 |
| SkillMap | id_siswa (PK, FK), id_topik (PK, FK), status, diperbarui | N-1 ke Siswa dan Topik | DATA-003 |
| DiagnosticResult | id_siswa (PK, FK), id_topik (PK, FK), benar, total, status_penguasaan | N-1 ke Siswa dan Topik | DATA-003 |
| LessonProgress | id_siswa (PK, FK), id_lesson (PK, FK), selesai, skor_terbaik, jumlah_percobaan, waktu | N-1 ke Siswa dan Lesson | DATA-004 |
| MasteryResult | id_mastery (PK), id_siswa (FK), id_topik (FK), skor, lulus, waktu | N-1 ke Siswa dan Topik | DATA-003 |
| Jawaban | id_jawaban (PK), id_siswa (FK), id_soal (FK), jawaban, benar_salah, konteks, waktu | N-1 ke Siswa dan Soal | DATA-005 |
| Badge | id_badge (PK), nama, ikon, syarat_perolehan | N-N ke Siswa lewat Siswa_Badge | DATA-004 |
| Siswa_Badge | id_siswa (PK, FK), id_badge (PK, FK), waktu_diperoleh | N-1 ke Siswa dan Badge | DATA-004 |
| StreakLog | id_siswa (PK, FK), tanggal (PK), jumlah_aktivitas | N-1 ke Siswa | DATA-004 |
| CompanionMessage | id_pesan (PK), id_siswa (FK), jenis_trigger, isi_pesan, ekspresi, waktu_kirim, dibaca | N-1 ke Siswa | FR-009 |

Nilai yang dibatasi:

| Atribut | Nilai yang diizinkan |
|---|---|
| Siswa.kelompok_belajar | kecil, besar |
| SkillMap.status | terkunci, belumDikuasai, perluLatihan, mastered (ditampilkan "Dikuasai") |
| Lesson.tipe | kenalan, latihan |
| Soal.jenis_latihan | hitungBenda, pilihanGanda, seretKeKotak, pasangkan, bandingkan, pecahanGambar, soalCerita |
| Jawaban.konteks | diagnostic, lesson, mastery |
| CompanionMessage.jenis_trigger | sambutan, streakTerancam, lamaTidakAktif, lessonSelesai, lessonGagal, masteryLulus, masteryGagal, badgeBaru, levelNaik |
| CompanionMessage.ekspresi | senang, berpikir, semangat, sedih, mengantuk, bangga |

Penyimpanan fisik. Saat ini seluruh data milik satu siswa disimpan sebagai satu dokumen JSON di perangkat (`DataBelajar`, kunci `numi.data_belajar.v1`), dengan riwayat jawaban dibatasi 300 entri agar tidak membengkak. Topik, lesson, lencana, dan templat soal adalah konten tetap di dalam aplikasi. Saat Firebase diaktifkan, struktur yang sama dipetakan ke Firestore: satu dokumen `users/{uid}` per siswa dengan subkoleksi `skillMap`, `diagnosticResult`, `lessonProgress`, `masteryResult`, `jawaban`, `siswaBadge`, `streakLog`, dan `companionMessage`; konten belajar di koleksi `konten/{id_topik}` yang hanya bisa dibaca aplikasi. Rancangan aturan keamanannya ada di `firebase/firestore.rules`.

## 2.5 API Design

Rancangan API Numi mengikuti arsitektur Flutter-Firebase pada bagian 2.1. Aplikasi memakai Firebase Authentication untuk sesi pengguna, Cloud Firestore untuk membaca data, Cloud Functions callable untuk perhitungan dan perubahan data belajar, serta Firebase Cloud Messaging (FCM) untuk pengingat maskot. "Endpoint" Firestore di bawah berarti path koleksi atau dokumen, bukan URL REST; pemanggilan Cloud Functions dilakukan melalui Firebase SDK. Seluruh kontrak ini adalah rancangan integrasi Firebase. Implementasi saat ini masih memakai `LocalNumiRepository`; endpoint yang benar-benar terpasang dicatat di bagian 3.3.

Konvensi: {uid} adalah ID akun dari sesi Firebase Authentication. Semua operasi data siswa memakai uid dari sesi, bukan uid bebas dari klien. Konten soal yang dikirim ke aplikasi tidak memuat jawaban benar. Nilai, status skill map, XP, streak, dan badge dihitung serta ditulis oleh layanan tepercaya agar tidak bisa diubah langsung oleh klien.

| API | Method | Endpoint | Input | Output | Autentikasi | Keterangan |
|---|---|---|---|---|---|---|
| API-01 Autentikasi akun siswa/wali (NFR-005) | daftar/masuk melalui Firebase Authentication SDK | Firebase Authentication | kredensial sesuai metode login yang dipilih tim | uid dan sesi | tidak diperlukan saat masuk; sesi valid wajib untuk API-02 s.d. API-12 | metode kredensial dan alur pendampingan wali ditetapkan saat integrasi, tanpa menyimpan kata sandi di Firestore |
| API-02 Simpan/baca profil siswa (DATA-001, UC-008) | set/get melalui Firestore SDK | users/{uid} | nama dan usia; kelompok_belajar tidak boleh ditentukan klien | profil siswa, termasuk kelompok_belajar setelah diagnostic | pemilik uid | usia adalah data profil, kelompok belajar ditentukan dari hasil diagnostic |
| API-03 Ambil soal diagnostic (FR-001, UC-001) | POST (callable) | getDiagnosticQuestions | permintaan mulai tes dan konteks profil | id_soal, id_topik, konten, jenis latihan, pilihan jawaban tanpa jawaban_benar | pemilik uid | soal diambil adaptif, dua per topik |
| API-04 Kirim hasil diagnostic (FR-001, FR-002, FR-003; DATA-003) | POST (callable) | submitDiagnostic | ID sesi tes dan daftar {id_soal, jawaban} | skor per topik, kelompok_belajar, skill map awal, rekomendasi | pemilik uid | jawaban benar tidak dibuka selama tes; tes yang terputus diulang dari awal |
| API-05 Baca skill map (FR-002, UC-002) | query/get melalui Firestore SDK | users/{uid}/skillMap/{id_topik} | uid dari sesi | status 12 topik | pemilik uid | perubahan status hanya berasal dari API-04 atau API-10 |
| API-06 Ambil learning path (FR-003, UC-009) | POST (callable) | getLearningPath | konteks siswa dan skill map | id_topik yang disarankan dan alasan singkat | pemilik uid | topik terkunci tidak direkomendasikan |
| API-07 Ambil konten lesson (FR-004a, FR-004b; DATA-002) | get/query melalui Firestore SDK | konten/{id_topik}/lessons/{id_lesson} | id_topik dan id_lesson | materi, tipe, templat soal tanpa kunci jawaban | sesi valid; hanya tim yang bisa menulis | penyajian dibedakan untuk kelas kecil dan kelas besar |
| API-08 Periksa jawaban latihan (FR-005, UC-004; DATA-005) | POST (callable) | checkLessonAnswer | id_lesson, id_soal, jawaban, ID percobaan | benar/salah, penjelasan bila salah | pemilik uid | respons 2 detik atau kurang (NFR-002); tidak dipakai untuk diagnostic |
| API-09 Selesaikan lesson (FR-006, FR-008; UC-003, UC-010) | POST (callable) | completeLesson | id_lesson dan ID percobaan | status selesai, skor, XP, streak, badge baru | pemilik uid | ditulis atomik; ID percobaan mencegah XP ganda bila dikirim ulang |
| API-10 Kirim mastery test (FR-007, UC-005) | POST (callable) | submitMastery | id_topik, ID sesi, daftar {id_soal, jawaban} | skor, lulus/tidak, skill map terbaru | pemilik uid | hanya tersedia setelah kedua lesson selesai; ambang 95 |
| API-11 Baca progres (FR-006, FR-008; UC-006) | get/query melalui Firestore SDK | users/{uid}/lessonProgress, siswaBadge, streakLog | uid dari sesi | lesson selesai, XP/level, streak, badge | pemilik uid | listener Firestore agar tampilan mengikuti data |
| API-12 Pengingat maskot (FR-009, UC-007) | trigger terjadwal Cloud Function, kirim lewat FCM | sendCompanionReminder dan users/{uid}/companionMessage/{id_pesan} | status streak, aktivitas terakhir, token perangkat | pesan tersimpan dan notifikasi bila diizinkan | hanya layanan tepercaya | satu pesan per jenis per hari |

Aturan umum: akses ke users/{uid} dibatasi pada pemilik akun; konten belajar hanya-baca bagi aplikasi. Input tidak valid ditolak, sesi tidak sah menghasilkan UNAUTHENTICATED/PERMISSION_DENIED, prasyarat yang belum terpenuhi menghasilkan FAILED_PRECONDITION, dan gangguan jaringan bisa dicoba ulang dengan ID sesi atau percobaan yang sama. Rancangan `firebase/firestore.rules` saat ini masih mengizinkan pemilik akun menulis subkoleksinya sendiri; setelah Cloud Functions aktif, penulisan DiagnosticResult, SkillMap, MasteryResult, progres, XP, streak, dan badge dipersempit hanya untuk Functions.

## 2.6 Traceability Awal

| Requirement | Use Case | Design Artifact | Implementasi | Catatan |
|---|---|---|---|---|
| FR-001 Diagnostic Test | UC-001 | ACT-001, SEQ-001, CLS-002 | features/diagnostic, domain/diagnostic_engine.dart | Tes adaptif dua soal per topik tanpa umpan balik; menentukan kelompok belajar |
| FR-002 Skill Map | UC-002 | STM-001, CLS-001, CLS-002 | features/skill_map, domain/skill_map_service.dart | Status terkunci, belum dikuasai, perlu latihan, dikuasai |
| FR-003 Personalized Learning Path | UC-009 | SEQ-001, CLS-002 | domain/learning_path_service.dart | Numi melayang di atas pulau yang disarankan |
| FR-004a Lesson Kelas Kecil | UC-003 | ACT-002, SEQ-002, CLS-003 | features/lesson, features/quiz, data/content/generator_soal.dart | Soal visual: hitung benda, seret, pasangkan |
| FR-004b Lesson Kelas Besar | UC-003 | ACT-002, SEQ-002, CLS-003 | features/lesson, features/quiz, data/content/generator_soal.dart | Soal simbol dan soal cerita |
| FR-005 Instant Feedback | UC-004 | SEQ-002, STM-002 | features/feedback | Banner benar atau salah dengan penjelasan |
| FR-006 Gamification | UC-010 | ACT-004, STM-003 | domain/progress_service.dart | XP, level, streak, 8 lencana, tanpa leaderboard |
| FR-007 Mastery Test | UC-005 | ACT-003, SEQ-005, STM-001 | features/mastery | Skor 95 menyalakan mercusuar |
| FR-008 Progress Tracking | UC-006 | SEQ-006, ACT-004 | features/progress | Ringkasan untuk anak, rincian untuk orang tua |
| FR-009 Maskot / Companion | UC-007 | ACT-005, SEQ-003, STM-004 | features/mascot, domain/companion_service.dart | Satu pesan per jenis per hari |
| NFR-003 Reliability | semua | CMP-001, DPL-001 | data/repositories/local_numi_repository.dart | Data tersimpan setiap aktivitas selesai |
| NFR-005 Security | UC-008 | SEQ-004, DPL-001 | features/onboarding, firebase/firestore.rules | Data di perangkat; akses Firestore hanya pemilik uid |
| DATA-001 s.d. DATA-005 | semua | ERD-001, CLS-001 | data/models | Entitas sama dengan ERD |
