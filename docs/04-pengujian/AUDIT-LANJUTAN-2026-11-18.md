# Audit lanjutan Numi — 18 November 2026

Audit ini mencakup autentikasi Android, pemisahan profil dua akun, aturan Firestore, pembacaan snapshot, checkpoint, generator mastery, dan alur rekomendasi. Ini bukan audit lengkap seluruh repositori. Temuan awal berikut dicatat sebelum kode diperbaiki; status tindak lanjut ada di bagian akhir.

## Hasil verifikasi

- Dua akun Google nyata pada emulator: akun kedua menampilkan daftar profil kosong. Setelah keluar dan masuk kembali ke akun pertama, profil Numi-QA dan rekomendasi checkpoint lesson 2/5 muncul kembali. Ini membuktikan pemisahan profil pada alur UI tersebut, bukan pengujian langsung permintaan lintas UID ke server produksi.
- Tujuh tes checkpoint/finalisasi terfokus lulus, termasuk restart, kegagalan penyimpanan, retry, dan pencegahan XP ganda.
- Probe aturan pada Auth/Firestore Emulator lokal lulus: aturan menolak akses lintas UID, tetapi menerima dua payload tidak sah secara semantik yang dijelaskan di bawah. Cloud tim tidak diberi payload audit tersebut.
- Probe generator deterministik Random(42), 1.000 pasangan lesson/mastery per topik untuk 12 topik: semua paket mastery berisi lima soal. Sebelas topik menghasilkan setidaknya satu pengulangan butir lesson dalam mastery. Pada T05 terdapat 829 pengulangan dari 5.000 butir mastery. Angka ini hasil simulasi, bukan pengukuran siswa.

## Temuan, urut prioritas

### 1. Tinggi — aturan cloud hanya memvalidasi bentuk luar data belajar

Lokasi: `firebase/firestore.rules:24`.

Reproduksi lokal: tulis sebagai pemilik profil, dengan revisi dasar sah, XP 999999999 dan bukti mastery tanpa sesi pendukung; server emulator menerima HTTP 200. Berikutnya, tulis `sesiLesson: [{id: 'checkpoint-tidak-lengkap'}]`; server juga menerima HTTP 200. List diperiksa tipenya, tetapi isi dan konsistensi antardata tidak diverifikasi. Aturan juga tidak membuktikan bahwa digest versi sesuai isi.

Dampak: pemilik atau klien bermasalah dapat mengirim progres palsu atau snapshot rusak ke akunnya sendiri. Ini tidak menunjukkan akses ke data akun lain.

Perbaikan yang dibutuhkan: tentukan batas kepercayaan progres, validasi struktur sesi dan referensi bukti pada batas server. Jika mastery harus dipercaya server, hitung/validasi hasil melalui proses server yang terotorisasi.

### 2. Sedang — satu profil cloud rusak menggagalkan sinkronisasi seluruh daftar

Lokasi: `app/lib/data/repositories/cloud_profil_repository.dart:48` dan `app/lib/data/repositories/local_profil_repository.dart:139`.

Jalur kode: `daftar()` memanggil parser untuk semua dokumen dalam satu ekspresi. Kegagalan parsing atau ketidakcocokan digest pada satu dokumen membatalkan seluruh hasil. Pemanggil menangkap semua error dan menampilkannya sebagai sinkronisasi tertunda. Payload checkpoint tidak lengkap pada temuan pertama menyediakan pemicu nyata untuk jalur ini; dampak UI ditentukan dari penelusuran kode, belum diinjeksi ke cloud tim.

Dampak: profil sehat ikut tidak tersinkron, sementara pengguna hanya diminta mencoba lagi tanpa mengetahui ada data rusak.

Perbaikan yang dibutuhkan: isolasi kegagalan per profil, pertahankan salinan lokal, dan bedakan data tidak valid dari kegagalan jaringan.

### 3. Sedang — mastery dapat mengulang soal lesson yang baru selesai

Lokasi: `app/lib/features/mastery/mastery_screen.dart:61`.

Daftar `hindari` hanya berisi soal sesi mastery sebelumnya, tanpa soal lesson yang baru dikerjakan. Probe generator di atas membuktikan pengulangan, termasuk 829/5.000 butir pada T05.

Dampak: jawaban bisa terbantu ingatan dari latihan barusan sehingga bukti kemampuan menjadi kurang kuat.

Perbaikan yang dibutuhkan: sertakan butir latihan terbaru dalam pengecualian mastery, lalu pastikan jumlah dan kesepadanan variasi tetap memadai.

### 4. Sedang — rekomendasi remedial membuka hasil lesson lama

Lokasi: `app/lib/domain/learning_path_service.dart:87`, `app/lib/features/lesson/lesson_screen.dart:63` dan `app/lib/features/skill_map/topik_sheet.dart`.

Jalur kode: sesudah mastery gagal dan kedua lesson sebelumnya selesai, rekomendasi memilih lesson latihan terakhir. Membuka lesson itu menemukan sesi selesai lalu menampilkan ringkasan sebelumnya. Pengguna masih harus memilih Latihan lagi untuk memulai remedial. Temuan ini berasal dari penelusuran alur kode; skenario mastery gagal tersebut belum diuji menyeluruh di Android pada audit ini.

Dampak: rekomendasi berlatih membawa anak ke hasil lama dan menambah langkah yang membingungkan.

Perbaikan yang dibutuhkan: saat membuka rekomendasi remedial, tawarkan tindakan mulai ulang yang jelas tanpa menimpa checkpoint yang belum selesai.

### 5. Sedang — konflik sinkronisasi belum memiliki penyelesaian melalui UI

Lokasi: `app/lib/data/repositories/local_profil_repository.dart:136` dan `app/lib/features/account/akun_app.dart:184`.

Jika salinan lokal dan cloud sama-sama berubah dari revisi dasar, repository mempertahankan keduanya dan mengembalikan konflik. UI hanya memberi pesan; tidak tersedia tindakan memilih, menggabungkan, atau menyalin versi. Menekan sinkronisasi kembali tanpa perubahan keadaan akan menghasilkan konflik yang sama. Ini keterbatasan yang sudah tercatat pada verifikasi rilis.

Dampak: data tidak ditimpa, tetapi pengguna tidak dapat menuntaskan sinkronisasi lewat aplikasi.

Perbaikan yang dibutuhkan: sediakan pemulihan konflik dengan pratinjau dan cadangan sebelum pilihan pengguna diterapkan.

## Pemeriksaan UX dan persiapan rilis yang masih terbuka

- Peta saat ini menampilkan rekomendasi sebagai teks dan pulau yang dapat diketuk, tanpa tombol langsung untuk menjalankan rekomendasi. Catatan I09 pada VERIFIKASI-RILIS.md yang menyebut MAIN tidak lagi mencerminkan implementasi UI saat ini.
- Konten masih berstatus PENDING_EDUCATOR_REVIEW (`app/lib/data/content/paket_kelas.dart:14`). Persetujuan pendidik dan pilot siswa belum selesai.
- Build release masih memakai signing debug (`app/android/app/build.gradle.kts:40`). Artefak tersebut cocok untuk QA, belum untuk distribusi produksi.
- Mastery lengkap, force-stop mastery dan XP pada perangkat, login Web interaktif, serta penggunaan di dua perangkat fisik masih perlu diuji. Uji dua akun pada satu emulator sudah diselesaikan untuk alur pemilihan profil dan pemulihan checkpoint.

## Bukti lokal sementara

Probe ada di lokasi yang diabaikan Git: `.cache/firestore-audit.test.mjs`, `.cache/numi-audit-rules.log`, `.cache/numi-audit-checkpoint.log`, dan `app/.dart_tool/numi_audit_generator.dart`. Berkas tersebut dapat hilang saat cache dibersihkan; hasil dan batas pengujian dirangkum dalam dokumen ini.

## Tindak lanjut implementasi

1. Validasi cloud diperketat, tetapi penilaian tepercaya oleh server masih terbuka. Rules kini menolak checkpoint lesson/mastery tanpa bidang wajib, diagnostic tanpa struktur luar yang sesuai, serta XP positif tanpa catatan finalisasi. Uji mencakup 24 slot lesson, 12 mastery dan diagnostic enam blok agar tidak melampaui batas evaluator. Isi butir/respons, digest, batas XP berdasarkan jumlah percobaan dan keberadaan hasil mastery bagi bukti awal divalidasi aplikasi saat menerima maupun mengirim snapshot. Klien yang dimodifikasi tetap dapat mengirim catatan palsu yang konsisten; validasi ini tidak boleh dianggap bukti pengerjaan oleh server.
2. Profil cloud tidak valid dipisahkan per dokumen. Profil sehat tetap disinkronkan; profil tidak valid tidak dihapus atau ditimpa otomatis. UI membedakan kondisi ini dari sinkronisasi tertunda.
3. Generator membandingkan isi butir selain ID, tanpa dipengaruhi urutan opsi, tingkat atau ID acak. Mastery mengecualikan butir kedua lesson tersimpan dan mastery sebelumnya. Simulasi 100 siklus per topik pada 12 topik menghasilkan paket lima soal tanpa pengulangan isi terhadap paket-paket tersebut. Ini belum membuktikan kesepadanan tingkat kesulitan; validasi pendidik tetap diperlukan.
4. Membuka lesson yang direkomendasikan sebagai remedial memulai sesi baru jika sesi lama sudah selesai. Checkpoint yang belum selesai tetap dilanjutkan. Tes widget memastikan hasil lama tidak menambah XP lagi.
5. Tombol Selesaikan konflik menampilkan ringkasan kedua versi dan pilihan cloud/perangkat. Kedua snapshot dicadangkan di database privat perangkat sebelum perubahan. Pilihan usang ditolak jika versi berubah. Tes repository mencakup kedua pilihan, perubahan revisi dan cadangan; tes widget mencakup pratinjau, pembatalan dan penerapan cloud. Belum ada tombol memulihkan cadangan tersebut; data cadangan dapat diambil melalui prosedur dukungan teknis.

Suite lengkap lulus 152 tes pada pemeriksaan implementasi. Pemeriksaan terfokus terakhir generator dan snapshot cloud lulus 32 tes, termasuk tambahan penerimaan XP latihan berulang. Analyzer bersih. Nomor tes bukan klaim bahwa pengujian Android menyeluruh sudah selesai.

APK debug QA berhasil dibangun. Build harness Web juga berhasil menggunakan path output absolut; percobaan path relatif sebelumnya gagal menulis shader pada Windows. SDK FlutterFire di Chrome menghasilkan NUMI_FIREBASE_LULUS: unggah checkpoint, pemulihan ke database lokal kedua dan penolakan lintas UID. Percobaan awal koneksi Web timeout; percobaan terakhir memakai long polling pada harness dan menjalankan suite aturan REST sebelum SDK pada emulator yang sama. Pengaturan transport aplikasi produksi tidak diubah.

Instalasi APK terbaru belum terverifikasi: AVD cold boot headless mengalami restart SystemServer oleh Watchdog dan layanan PackageManager/Storage belum siap pada percobaan instalasi. AVD QA yang dijalankan untuk pemeriksaan ini ditutup tanpa menghapus data. Pengujian APK baru dan mastery lengkap di Android tetap terbuka. Build Android juga mengeluarkan peringatan kompatibilitas Kotlin Gradle Plugin pada firebase_auth/firebase_core untuk versi Flutter mendatang; build saat ini tetap lulus.

Penguatan aturan dan indeks kemudian berhasil dideploy ke numi-imun sesuai izin Firestore sebelumnya. Pemeriksaan sesudah deployment dibatasi pada dokumen QA yang sama: satu diagnostic, dua jawaban lesson, XP 0, digest valid dan waktu pembaruan server tetap 2026-11-18T05:14:49.582911Z. Akses anonim ditolak HTTP 403. Data QA tidak diubah oleh deployment atau pembacaan verifikasi tersebut.
