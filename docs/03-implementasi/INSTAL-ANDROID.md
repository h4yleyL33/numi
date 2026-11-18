# Unduh dan pasang Numi di HP Android

Rilis: **Numi 0.1.0 QA Android**, tag `v0.1.0-qa.20261119`.

[Buka halaman Release](https://github.com/h4yleyL33/numi/releases/tag/v0.1.0-qa.20261119)

## Mengunduh APK

1. Buka tautan Release di Chrome pada HP.
2. Masuk ke akun GitHub yang memiliki akses ke repositori `h4yleyL33/numi`. Repositori ini privat; jika muncul 404, pastikan akun yang dipakai memiliki akses.
3. Buka bagian **Assets**.
4. Ketuk **numi-0.1.0-qa-20261119.apk** dan tunggu unduhan selesai. Ukurannya sekitar **205 MB**. Berkas Source code ZIP/TAR bukan aplikasi yang dapat dipasang di Android.

## Memasang dan membuka

1. Buka APK dari notifikasi unduhan atau folder Downloads/Unduhan.
2. Jika Android meminta izin pemasangan dari Chrome atau Files, pilih **Setelan**, lalu aktifkan **Izinkan dari sumber ini** untuk aplikasi pengunduh tersebut. Kembali ke pemasang dan pilih **Instal**. Nama menu dapat berbeda antar merek HP. [Panduan Google](https://support.google.com/pixelphone/answer/7391672?hl=en).
3. Setelah selesai, pilih **Buka**. APK ini memerlukan Android **8.0/API 26 atau lebih baru**.
4. Masuk ke Numi dengan akun Google wali. Login Google di Numi terpisah dari login GitHub untuk mengunduh APK.
5. Untuk mengambil profil dari pengujian sebelumnya, gunakan akun Google wali yang sama, lalu pilih **Sinkronisasi → Setujui/Sinkronkan sekarang** di layar pemilih profil. Setelah profil muncul, pilih profil tersebut. Akun Google lain memiliki daftar profilnya sendiri.

Jika Numi dengan penandatanganan yang sama sudah terpasang, Android dapat menawarkan pembaruan. Bila muncul konflik paket/tanda tangan, simpan pesan kesalahannya dan pastikan progres dicadangkan sebelum menghapus aplikasi lama.

## Jika Android menyebut developer belum diverifikasi

Pada perangkat yang menerapkan verifikasi developer Android, izin sumber unduhan saja mungkin belum cukup. Jika pesan ini muncul, gunakan [alur resmi Google untuk aplikasi developer yang belum diverifikasi](https://support.google.com/android/answer/17588095?hl=en). Proses tambahan tersebut dapat mencakup penundaan keamanan **24 jam**; kondisi ini bergantung pada perangkat dan kebijakan yang diterapkan.

## Status pengujian

Ini **prarilis QA dengan penandatanganan debug**, untuk pengujian terbatas. Konten masih menunggu validasi pendidik dan APK distribusi produksi belum disiapkan.

- Source UI dan aset aplikasi: commit `558a097` beserta commit dokumentasi rilis sesudahnya.
- Suite lengkap sebelum rilis: **154 tes lulus**, analyzer bersih.
- APK yang sama sudah dipasang pada AVD Android 35: dua lesson, mastery 5/5, pemulihan sesudah force-stop dan pembukaan hasil ulang tanpa reward ganda lulus. UI dan Firestore memuat 230 XP dan satu hasil mastery.
- Perangkat fisik, API 26/RAM 2–4 GB serta target waktu startup belum diverifikasi.
- SHA-256 APK: `a8d6897c8c8698ca8a16f5d1bdc5bc977aae38047209b44be05e5d36f84b6ebf`.

[Bukti pengujian Android](../04-pengujian/VERIFIKASI-RILIS.md#verifikasi-android-apk-terbaru).
