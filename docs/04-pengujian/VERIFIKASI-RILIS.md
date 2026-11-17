# Verifikasi rilis Numi

Eksekusi 17 November 2026 pada `codex/init-development`. Baseline checkout sebelum perubahan menghasilkan 138 tes lulus dan analyzer bersih. Run lama tetap tercatat di [verifikasi implementasi](../03-implementasi/VERIFIKASI.md).

## Cakupan backlog

| ID | Status | Implementasi atau bukti yang diperiksa | Sisa |
| --- | --- | --- | --- |
| I00 | Implemented & verified | PRD, pemetaan kurikulum, sumber UML/ERD, backlog, dan hasil ekstraksi MinerU lokal Bab I–III ditelusuri terhadap kode. | |
| I01 | Implemented & verified | Tes repository/controller memeriksa kegagalan simpan, state setelah commit, dan retry. | |
| I02 | Implemented & verified | Tes model, diagnostic, dan widget mencakup enam kelas, konfirmasi data usia lama, dan pergantian profil. | |
| I03 | Implemented & verified | Diagnostic dan mastery menahan pembahasan sampai hasil tersimpan. Hasil memakai snapshot soal dan respons pertama. | |
| I04 | Partially implemented | Login Google Android nyata, persistensi setelah force-stop, pembatalan, logout dan login ulang teruji pada emulator Android 35. SHA-1/SHA-256 debug dan OAuth terverifikasi. | Pergantian dua akun, login Web interaktif dan build release pada perangkat. |
| I05 | Partially implemented | Sembast dipisah per UID. Aturan emulator menolak baca, daftar, dan tulis lintas UID. Sinkronisasi memakai persetujuan wali. | Staging, migrasi demo, dan siklus penghapusan cloud. |
| I06 | Partially implemented | Dua butir pengantar per kelas, 12 topik dengan generator, metadata kompetensi, versi, kunci dan pembahasan. Tes memeriksa 4.800 butir dari 12 topik dan dua tingkat. | Paket lesson dan bank soal enam kelas, pemeriksaan sumber kurikulum per butir dan persetujuan guru. Semua konten berstatus `PENDING_EDUCATOR_REVIEW`. |
| I07 | Partially implemented | Bukti kemampuan, akses, dan XP terpisah. Tes domain memastikan topik yang belum diukur tidak menjadi bukti mastery. | Graf dan bukti per subketerampilan serta validasi kebijakan bersama guru. |
| I08 | Partially implemented | Checkpoint tiga alur, finalisasi lokal idempoten, retry cloud dan deteksi konflik berbasis revisi. | Penyelesaian konflik dari UI, skema subkoleksi, pengujian dua perangkat fisik dan proses Android dihentikan. |
| I09 | Partially implemented | MAIN menggunakan rekomendasi yang ada. Kegagalan mastery memprioritaskan pengulangan lesson latihan. | Pembaca soal dan audit bantuan/aksesibilitas seluruh bentuk soal di perangkat. |
| I10 | Partially implemented | Ambang 5/5, pembahasan setelah commit, menghindari ID butir paket mastery sebelumnya, dan jadwal periksa ulang setelah lima hari. | Kesepadanan soal, hasil retensi dan kebijakan reward untuk pilot guru. |
| I11 | Partially implemented | Laporan wali lewat gerbang menampilkan data kemampuan per topik, tes penempatan terakhir, mastery, aktivitas dan langkah berikutnya. | Riwayat beberapa percobaan diagnostic secara terstruktur dan verifikasi dengan wali. |
| I12 | Blocked by external dependency | Jalur build dan tes otomatis tersedia. | Runtime Android, login nyata, Firestore staging, penandatanganan distribusi, validasi pendidik, dan pilot siswa. |

## Menjalankan ulang

| Pemeriksaan | Bukti eksekusi |
| --- | --- |
| Flutter | Analyzer bersih dan suite unit, domain, state, repository dan widget lulus 144/144 pada checkout aktif dan snapshot Git tanpa redesign lokal. Tes widget mencakup gerbang wali dan tampilan progres pada lebar 390 dp. |
| Firebase Security Rules | Lulus pada Firestore dan Auth Emulator. Akun B ditolak membaca, mendaftar, mengubah atau menghapus profil akun A. Tulis anonim, kelas tidak sah, UID salah, dan revisi usang ditolak. |
| FlutterFire di Chrome | `NUMI_FIREBASE_LULUS`. SDK mengirim checkpoint lesson dengan butir pasangan ke Firestore Emulator, memulihkannya di database kedua, lalu penolakan antar-UID dikonfirmasi. |
| Proses penulis Windows | 3/3 lulus. Snapshot, jawaban pertama, posisi, versi dan urutan dipulihkan setelah penulis dihentikan. |
| Firebase tim | Aplikasi Android dan Web terdaftar. Endpoint Auth menghasilkan URL otorisasi Google. API Firestore mengembalikan 403 karena belum diaktifkan. |
| Android | APK debug dan release dibangun untuk `id.ac.unpad.numi.numi`, min SDK 26 dan target 36. Tanda tangan debug valid. APK debug diuji pada emulator Android 35 Google Play, termasuk login, profil, diagnostic, offline dan force-stop. |
| Web | Build aplikasi dengan konfigurasi SDK Web tim lulus. |

Dari folder `app/`:

```powershell
flutter pub get
flutter analyze --no-pub
flutter test --no-pub --reporter expanded
dart run tool/verifikasi_checkpoint_proses.dart
```

Perintah build Android/Web dan emulator Firebase ada di [panduan Firebase](../../firebase/README.md). Probe proses memutus proses penulis pada host. Firestore Emulator memakai akun sintetis dan database terpisah dari proyek tim.

## Pembaruan 18 November 2026

Firebase CLI mengembalikan SHA-1 dan SHA-256 yang cocok dengan sertifikat debug pada APK QA. Konfigurasi Android baru memuat klien OAuth untuk package `id.ac.unpad.numi.numi` dengan SHA-1 terdaftar serta klien OAuth Web. Build debug dan release QA lulus. `apksigner` memverifikasi kedua tanda tangan, dan resource `default_web_client_id` ada pada kedua APK. Pemeriksaan Firestore proyek tim kembali menghasilkan HTTP 403 karena API belum aktif.

Android Emulator dipasang melalui SDK Manager dengan image Android 35 Google Play dan AVD `Numi_QA_API_35`. WHPX lolos pemeriksaan akselerasi. APK debug berhasil diinstal pada `emulator-5556`, proses aplikasi berjalan dan UI menampilkan **Masuk bersama wali**. Percobaan Google pertama mengalami timeout layanan Credential Manager saat boot awal. Percobaan kedua membuka aktivitas Google resmi dan mencapai formulir **Sign in - Google Accounts**.

Pengguna kemudian menyelesaikan login Google langsung pada emulator. Pemilihan akun melalui tombol Numi berhasil membuka **Pilih profil anak**. Penghentian proses dan pembukaan ulang mempertahankan sesi. Logout mengembalikan layar masuk. Pembatalan pemilih Google menampilkan **Masuk dibatalkan. Silakan coba lagi.** dan login ulang berhasil.

Profil sintetis `Numi-QA`, kelas 1, dibuat lewat form dan konfirmasi. Respons pertama diagnostic (7 kerang, benar) tersimpan. Setelah force-stop dan pemilihan ulang profil, **Lanjutkan pemetaan** memulihkan soal 2/12 dengan snapshot 12 kerang. Respons kedua sengaja salah menghasilkan 1/2 dan **Perlu latihan** pada T01. Topik lain tetap **Belum dicoba**. Hasil membuka peta dan lesson **Ayo membilang**.

Wi-Fi serta data seluler emulator dimatikan untuk pengujian lesson. Materi tersedia dan respons 9 < 17 menghasilkan umpan balik benar. Setelah force-stop saat pembahasan, sesi wali dan profil dapat dibuka saat offline. Peta merekomendasikan lesson tersimpan dengan 1/5 jawaban. Pembahasan dan tombol Lanjut pulih. Ditemukan simbol pilihan kembali menjadi tanda tanya saat resume, sehingga pemulihan pilihan dari respons tersimpan ditambahkan pada tampilan soal. Koneksi emulator kemudian diaktifkan kembali.

Setelah perbaikan, tujuh tes terfokus pemulihan diagnostic/lesson/mastery lulus, analyzer bersih, dan suite lengkap lulus 145/145. Tes regresi baru memastikan respons pertama tampil saat pembahasan dipulihkan dan interaksi tetap terkunci.

APK debug yang diperbarui dipasang dengan `adb install -r`. Data profil dan checkpoint sebelumnya tetap dapat dibuka. Pembahasan yang sama kini menampilkan **9 < 17**, **Hebat!**, dan **Lanjut**, sehingga cacat tanda tanya terselesaikan pada emulator Android. Skenario mastery lengkap, finalisasi XP pada perangkat, pergantian dua akun, cloud staging dan pengujian APK release pada perangkat masih terbuka.
