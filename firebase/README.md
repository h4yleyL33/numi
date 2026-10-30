# Menyiapkan Firebase Numi

Status 30 Oktober 2026: proyek Firebase tim belum dibuat. Kode adapter Authentication sudah tersedia; tidak ada proyek, kredensial contoh, deployment, atau akses cloud yang dibuat oleh perubahan ini.

## Menjalankan sebelum proyek tersedia

Dari `app/`, gunakan demo pengembangan lokal:

```powershell
flutter run -d chrome --dart-define=NUMI_LOCAL_DEMO=true
```

Demo hanya berjalan pada build non-release dan memakai penyimpanan lama `numi.data_belajar.v1`. Cache akun wali memakai kunci lain. Build release selalu melalui autentikasi, walau flag demo diberikan. Menjalankan tanpa konfigurasi menampilkan Layanan akun belum tersedia dan tidak membaca profil belajar.

## Setelah proyek tim tersedia

1. Siapkan Android SDK/JDK dan perangkat uji Android API 26+. Lingkungan yang diperiksa saat ini belum memiliki Android SDK; build APK belum bisa dijalankan.
2. Buat proyek tim di Firebase Console dan aktifkan Authentication → Sign-in method → Google. Application ID Android yang dipakai repo saat ini adalah `id.ac.unpad.numi.numi`.
3. Daftarkan sidik sertifikat SHA-1 Android pada aplikasi Firebase. Siapkan sidik sertifikat build debug dan sertifikat rilis saat rilis benar-benar disiapkan. Konfigurasi SHA/provider mengikuti [dokumentasi autentikasi Firebase Flutter](https://firebase.google.com/docs/auth/flutter/federated-auth).
4. Pasang Firebase CLI dan FlutterFire CLI pada komputer pengembang, masuk ke akun tim, lalu dari `app/` jalankan perintah konfigurasi berikut dengan project ID yang benar:

```powershell
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project=PROJECT_ID_TIM --platforms=android,web
```

Perintah FlutterFire menghasilkan `lib/firebase_options.dart` dan menyesuaikan konfigurasi platform. Berkas pada repo sekarang adalah placeholder yang sengaja menolak inisialisasi. Ganti dengan hasil CLI, bukan nilai contoh. Alur ini mengikuti [panduan setup Firebase Flutter](https://firebase.google.com/docs/flutter/setup).

5. Untuk Android, pastikan konfigurasi Google dari aplikasi Firebase tersedia, termasuk `android/app/google-services.json` dan plugin Gradle Google Services yang sesuai hasil konfigurasi. Jika server OAuth client ID tidak tersedia dari konfigurasi Android, gunakan web OAuth client ID proyek yang benar melalui `--dart-define=NUMI_GOOGLE_SERVER_CLIENT_ID=...`. Mekanisme tersebut mengikuti [panduan plugin Google Sign-In Android](https://pub.dev/packages/google_sign_in_android). Jangan memasukkan client secret atau service-account key ke aplikasi.
6. Untuk web, pastikan authorized domains pada Authentication mencakup domain pengembangan/rilis yang dipakai. Adapter menggunakan popup Firebase; Android menggunakan plugin Google Sign-In, lalu credential Firebase. Tidak ada scope kontak, Drive, atau Calendar yang diminta.
7. Jalankan `flutter analyze`, `flutter test`, kemudian `flutter run` dan `flutter build apk --debug`. Periksa Google berhasil/batal/gagal, logout dan retry, dua akun wali, dua profil, serta pergantian akun ketika soal terbuka. Tes otomatis adapter memakai fake SDK; login nyata belum diverifikasi.

## Data dan Firestore

Data belajar saat ini tetap lokal per UID dan profil, setelah autentikasi Firebase. `LocalProfilRepository` tidak mengunggah data, menyinkronkan antarperangkat, atau mengklaim konfirmasi server. UI menyebutkan data tersimpan di perangkat ini. Data lama tanpa UID tidak otomatis dimiliki wali yang pertama masuk dan tidak diimpor diam-diam.

`firestore.rules` masih rancangan lama `users/{uid}` dan belum digunakan oleh adapter baru. Jangan memasangnya sebagai aturan final multi-profil. Tahap cloud harus menggunakan jalur `wali/{uid}/profil/{profilId}` dari doktek, aturan per subkoleksi, validasi data, dan tes emulator penolakan akses tanpa login/antarwali sebelum deployment. Menyiapkan Authentication tidak otomatis menyelesaikan aturan Firestore.

Database lokal kini dipisah per UID dan record memvalidasi pemilik/profil. SharedPreferences menjadi sumber migrasi cache ber-UID; salinan lama dipertahankan. Diagnostic, lesson dan mastery memakai snapshot soal, checkpoint respons, resume, dan finalisasi idempoten pada database Sembast. Bukti file Windows/browser serta batasnya ada di [CHECKPOINT-ALUR.md](../docs/03-implementasi/CHECKPOINT-ALUR.md). Proses mati Android, konflik dua perangkat, dan sinkronisasi masih bagian I08. Data lokal belum dienkripsi.
