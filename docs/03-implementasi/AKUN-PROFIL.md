# Implementasi akun wali dan profil

Tanggal: 30 Oktober 2026. Irisan lanjutan I04/I05, berdasarkan doktek 1.3–1.8, 2.1.2, 2.2, dan 3.3.1. Konfigurasi proyek dan login nyata belum tersedia karena proyek Firebase tim belum dibuat.

## Perilaku yang diterapkan

- Bootstrap bawaan menginisialisasi Firebase dan mengamati sesi akun. Profil hanya diminta setelah stream autentikasi menghasilkan identitas wali. Batal/gagal masuk tidak membuat profil.
- `FirebaseAkunRepository` memakai Google Sign-In native + Firebase credential pada Android dan Firebase popup pada web. Hasil dibedakan menjadi berhasil, dibatalkan, atau galat yang dapat dicoba lagi. Identitas pemilik memakai UID Firebase. Token tidak ditulis ke akun/profil/cache belajar.
- Wali dapat menambah, memilih, dan mengubah profil dengan nama panggilan serta satu kelas 1–6. Profil memiliki ID tetap dan `waliUid`. Mengubah kelas menjaga hasil, XP, dan riwayat.
- `LocalProfilRepository` menyimpan satu JSON per UID dengan data belajar masing-masing profil. Antrean tulis per akun mencegah perubahan profil yang berbarengan saling menimpa. Operasi menolak tanpa login, UID berbeda, profil berbeda, dan sesi belajar yang sudah ditutup.
- Setiap profil aktif memiliki ProviderScope dan Navigator sendiri. Ganti profil/akun atau keluar membuang route soal dan state anak sebelumnya. Respons async dari konteks lama tidak diterbitkan ke profil baru.
- Saat anak belajar, Ruang wali dibuka melalui gerbang penjumlahan dua digit. Gerbang merupakan pembatas interaksi anak; Google/Firebase tetap autentikasi akun. Pilih profil dan logout tersedia dari ruang wali.
- Reset progres pada profil terikat mempertahankan identitas anak dan tidak menghapus profil saudara. Pesan maskot yang masih menunggu tidak mengakses state widget setelah sesi ditutup.
- Firebase yang belum terkonfigurasi menampilkan layar layanan belum tersedia. Demo lokal hanya melalui flag eksplisit pada build non-release; data tanpa UID tidak otomatis diimpor atau dimuat dalam alur akun.

## Lokasi implementasi

| Bagian | Lokasi relatif terhadap `app/` |
| --- | --- |
| Bootstrap dan konfigurasi | `lib/main.dart`, `lib/firebase_options.dart` |
| Kontrak/adapter autentikasi | `lib/data/repositories/akun_repository.dart`, `firebase_akun_repository.dart` |
| Profil dan penyimpanan terikat | `lib/data/repositories/profil_repository.dart`, `local_profil_repository.dart`, `lib/data/models/siswa.dart` |
| Sesi akun/profil dan route | `lib/features/account/akun_app.dart`, `lib/app.dart` |
| Login, daftar/form profil, gerbang | `lib/features/account/masuk_screen.dart`, `profil_screen.dart`, `gerbang_wali.dart` |
| Integrasi progres dan lifecycle | `lib/state/numi_controller.dart`, `lib/features/onboarding/onboarding_screen.dart`, `lib/features/home/home_shell.dart` |

Paket resmi yang dipasang: firebase_core 5.1.0, firebase_auth 7.0.1, google_sign_in 7.2.0; versi terselesaikan dicatat pada pubspec.lock. Android minSdk disetel ke 26 sesuai sasaran doktek.

## Bukti dan batas penerimaan

Tes baru memeriksa pembatalan/native token kosong, galat jaringan, inisialisasi Google sekali, pembersihan logout, dua UID/dua profil, data salah konteks, gagal tulis/retry, tulis tertunda saat logout, cache rusak, penambahan serentak, form buat/ubah kelas, gerbang, pembongkaran route soal, bootstrap tanpa konfigurasi, dan login pada layar 360×640 serta landscape 844×390 dengan teks besar.

Login nyata, aturan Firestore, impor data tanpa UID, sinkronisasi, dan pengujian Android tetap belum diterima. Tidak ada akun uji palsu atau jalur melewati login di build release. Fake akun hanya berada pada test. Pembaruan I08 memakai database Sembast per UID, migrasi cache ber-UID, dan checkpoint diagnostic/lesson/mastery; lihat [CHECKPOINT-ALUR.md](CHECKPOINT-ALUR.md). Pengujian otomatis ini tidak membuktikan keamanan cloud atau durabilitas perangkat Android.

Instruksi konfigurasi lengkap dan batas Firestore ada pada [panduan Firebase](../../firebase/README.md). Status pengujian akhir dicatat pada [verifikasi](VERIFIKASI.md); backlog I04/I05 tetap parsial sampai konfigurasi dan pemeriksaan layanan/perangkat selesai.
