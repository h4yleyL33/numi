# Verifikasi rilis Numi

Eksekusi 17 November 2026 pada `codex/init-development`. Baseline checkout sebelum perubahan menghasilkan 138 tes lulus dan analyzer bersih. Run lama tetap tercatat di [verifikasi implementasi](../03-implementasi/VERIFIKASI.md).

## Cakupan backlog

| ID | Status | Implementasi atau bukti yang diperiksa | Sisa |
| --- | --- | --- | --- |
| I00 | Implemented & verified | PRD, pemetaan kurikulum, sumber UML/ERD, backlog, dan hasil ekstraksi MinerU lokal Bab I–III ditelusuri terhadap kode. | |
| I01 | Implemented & verified | Tes repository/controller memeriksa kegagalan simpan, state setelah commit, dan retry. | |
| I02 | Implemented & verified | Tes model, diagnostic, dan widget mencakup enam kelas, konfirmasi data usia lama, dan pergantian profil. | |
| I03 | Implemented & verified | Diagnostic dan mastery menahan pembahasan sampai hasil tersimpan. Hasil memakai snapshot soal dan respons pertama. | |
| I04 | Blocked by external dependency | Aplikasi Android dan Web terdaftar di `numi-imun`. Firebase Auth membuat URL otorisasi Google Web. SHA-1/SHA-256 debug dan klien OAuth Android terverifikasi. | Login Google interaktif, restart sesi, batal, serta pergantian akun pada perangkat uji. |
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
| Android | APK debug dan release berhasil dibangun untuk `id.ac.unpad.numi.numi`, min SDK 26 dan target 36. `apksigner verify` menerima kedua tanda tangan debug. ADB tidak menemukan perangkat. |
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

Android Emulator dipasang melalui SDK Manager dengan image Android 35 Google Play dan AVD `Numi_QA_API_35`. WHPX lolos pemeriksaan akselerasi. APK debug berhasil diinstal pada `emulator-5556`, proses aplikasi berjalan dan UI menampilkan **Masuk bersama wali**. Percobaan Google pertama mengalami timeout layanan Credential Manager saat boot awal. Percobaan kedua membuka aktivitas Google resmi dan mencapai formulir **Sign in - Google Accounts**. Pengujian masih menunggu pengguna memasukkan akun langsung di emulator sebelum keberhasilan Firebase Auth, persistensi sesi dan logout dapat diterima.
