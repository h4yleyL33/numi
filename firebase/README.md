# Firebase Numi

Proyek tim yang sudah ada adalah `numi-imun`. Aplikasi Android `id.ac.unpad.numi.numi` dan Web telah didaftarkan pada 17 November 2026. Konfigurasi SDK disimpan lokal. Login Google Android telah diuji pada emulator Android 35 dengan akun wali nyata. Pengujian interaktif Web dan perpindahan dua akun masih terbuka.

## Android

Dari root repositori, unduh konfigurasi Android untuk build lokal.

```powershell
firebase apps:sdkconfig ANDROID '1:262282560966:android:45eaa8dfe92a15af4cdec7' --project numi-imun --out app/android/app/google-services.json
cd app
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub
flutter build apk --release --no-pub
```

Flutter memakai Android SDK 36 dan JDK 21 pada mesin yang diverifikasi. Gradle memproses `google-services.json` ketika berkas tersedia. APK release saat ini ditandatangani dengan sertifikat debug untuk QA internal.

Pada 18 November 2026, Firebase CLI mengonfirmasi SHA-1 dan SHA-256 sertifikat debug sudah terdaftar untuk aplikasi Numi Android. Konfigurasi terbaru memuat klien OAuth Android untuk package dan sertifikat tersebut serta klien OAuth Web. Kedua APK QA dibangun ulang dan tanda tangan serta resource OAuth-nya diverifikasi. Untuk distribusi, daftarkan sidik jari sertifikat rilis atau Play App Signing yang benar. Pada perangkat Android, uji login, batal, tutup aplikasi, buka kembali, logout, dan pilih akun berbeda. [Panduan Google Sign-In Android](https://firebase.google.com/docs/auth/android/google-signin).

AVD lokal `Numi_QA_API_35` memakai Android 35 dengan Google Play. Pada `emulator-5556`, pengguna memasukkan akun langsung pada Google. Login Numi membuka pemilih profil, sesi bertahan setelah proses aplikasi dihentikan, logout kembali ke layar masuk, dan pembatalan pemilih akun menampilkan pesan yang sesuai. Login ulang berhasil. Profil sintetis `Numi-QA`, kelas 1, dipakai untuk pengujian belajar. Pengujian berikutnya mencakup akun kedua dan APK release pada perangkat.

## Web

Dari root repositori, bentuk berkas pengaturan yang dipakai oleh Dart.

```powershell
$hasil = firebase apps:sdkconfig WEB '1:262282560966:web:0003e6768be493834cdec7' --project numi-imun --json
if ($LASTEXITCODE -ne 0) { throw 'Konfigurasi Web belum diperoleh.' }
$cfg = ($hasil | ConvertFrom-Json).result.sdkConfig
[ordered]@{
  NUMI_FIREBASE_API_KEY = $cfg.apiKey
  NUMI_FIREBASE_APP_ID = $cfg.appId
  NUMI_FIREBASE_PROJECT_ID = $cfg.projectId
  NUMI_FIREBASE_SENDER_ID = $cfg.messagingSenderId
  NUMI_FIREBASE_AUTH_DOMAIN = $cfg.authDomain
} | ConvertTo-Json | Set-Content app/firebase-web.local.json -Encoding utf8NoBOM
cd app
flutter run -d chrome --dart-define-from-file=firebase-web.local.json
flutter build web --dart-define-from-file=firebase-web.local.json
```

Domain yang membuka popup login harus terdaftar di Firebase Auth. Konfigurasi SDK lokal diabaikan Git. Credential privat dikelola di luar repositori. [Panduan setup FlutterFire](https://firebase.google.com/docs/flutter/setup).

## Data dan sinkronisasi

Sembast tetap menyimpan respons pertama, snapshot butir, checkpoint dan finalisasi lokal. Kunci database dipisah per UID. Firebase Auth mengelola sesi wali. Tombol **Sinkronisasi** pada pemilih profil meminta persetujuan di perangkat sebelum mengirim nama panggilan, kelas, jawaban, dan progres. Sesudah persetujuan, aplikasi mencoba mengirim perubahan tiap 30 detik selama sesi akun aktif. Gunakan **Sinkronkan sekarang** dari pemilih profil untuk mengambil pembaruan sebelum membuka profil. Mematikan sinkronisasi menghentikan pengiriman berikutnya dari perangkat.

Cloud memakai `wali/{uid}` dan `wali/{uid}/profil/{profilId}`. Setiap profil memiliki snapshot `DataBelajar` dan sidik revisi. Transaksi Firestore membandingkan revisi dasar. Sembast mencatat sidik kiriman sebelum transaksi sehingga respons commit yang hilang dapat dicocokkan saat mencoba lagi. Jika kedua perangkat mengubah profil dari revisi yang sama, aplikasi melaporkan konflik dan menyimpan kedua salinan. Reset progres dari ruang wali menjadi revisi baru dan ikut terkirim jika sinkronisasi aktif.

Implementasi saat ini memakai satu dokumen per profil agar seluruh snapshot dapat dipulihkan secara atomik. Riwayat panjang akan mencapai batas ukuran dokumen Firestore. Rancangan subkoleksi sesi/respons, penggabungan konflik, penghapusan cloud permanen, dan validasi server atas bukti mastery/reward masih terbuka. Data demo tanpa UID tetap milik demo. [Batas ukuran Firestore](https://firebase.google.com/docs/firestore/quotas).

## Emulator lokal

Dari root, gunakan JDK 21 dan Node.js 22 atau lebih baru.

```powershell
firebase emulators:exec --only auth,firestore --project demo-numi --config firebase/firebase.json "node --test firebase/firestore.rules.test.mjs"
firebase emulators:start --only auth,firestore --project demo-numi --config firebase/firebase.json
```

Dengan emulator berjalan, dari terminal lain di folder `app` jalankan:

```powershell
flutter run -d chrome -t tool/verifikasi_firebase_emulator.dart
```

Layar menampilkan `NUMI_FIREBASE_LULUS` setelah mengunggah checkpoint lesson, memulihkannya di database lokal kedua, dan membuktikan penolakan antar-UID. Untuk emulator Android, targetkan perangkat dan gunakan `--dart-define=NUMI_FIREBASE_EMULATOR_HOST=10.0.2.2`. Harness membuat akun anonim di emulator dengan proyek `demo-numi`.

Firestore API proyek tim melaporkan HTTP 403 karena layanan masih nonaktif saat diperiksa. Untuk staging, aktifkan Cloud Firestore, pilih lokasi database, kemudian pasang aturan dan pengecualian indeks setelah pengujian dan persetujuan deployment. Hasil emulator tidak mencakup Firestore proyek tim.
