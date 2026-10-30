# Catatan verifikasi init Numi

Tanggal: 30 Oktober 2026. Pengujian teknis selama implementasi, belum laporan pengujian akhir Bab IV.

## Pembaruan paket pengantar dan bukti

Irisan I06/I07 menambah enam paket draft (dua butir awal per kelas), versi respons, pemisahan BuktiSkill/AksesMateri, penghapusan inferensi mastery diagnostic, migrasi aman status lama, serta label/alasan pada hasil dan peta. Ringkasan masih per sampel topik; graf subketerampilan lengkap dan validasi guru belum selesai. Lihat [KURIKULUM-BUKTI.md](KURIKULUM-BUKTI.md).

`flutter test --no-pub --reporter expanded`: **103 tes lulus**. `flutter analyze --no-pub`: **No issues found**. Build web berhasil pada pemeriksaan irisan ini dengan peringatan font CupertinoIcons yang sudah ada. Tidak ada verifikasi Firebase nyata, APK, proses mati, atau pilot anak tambahan.

Tes baru memeriksa status belum diuji/siap lanjut, larangan menguasai topik tak ditanyakan, metadata 12 butir awal, pemisahan akses dan bukti, roundtrip/migrasi, penolakan cache dua soal sebagai bukti penguasaan, blok mastery tidak lengkap/duplikat/konteks salah, bantuan, XP tanpa perubahan bukti, gagal simpan, dan tampilan kartu pulau/hasil. Hasil test tidak menjadi persetujuan validator atau bukti keefektifan pembelajaran. Catatan irisan sebelumnya di bawah dipertahankan sebagai riwayat.

## Pembaruan akun dan profil

Irisan lanjutan pada tanggal yang sama menambahkan adapter Google/Firebase, layar akun dan ruang wali, beberapa profil lokal per UID, guard sesi, serta bootstrap yang menahan akses jika Firebase belum dikonfigurasi. Rinciannya ada pada [AKUN-PROFIL.md](AKUN-PROFIL.md).

| Pemeriksaan lanjutan | Hasil |
| --- | --- |
| `flutter test --no-pub --reporter expanded` | **93 tes lulus**, termasuk 21 tes baru adapter, repository akun/profil, bootstrap, dan widget akun. |
| `flutter analyze --no-pub` | **No issues found.** |
| `flutter build web --no-pub` | Berhasil; peringatan font CupertinoIcons yang sudah ada tetap muncul saat build. |
| Browser lokal `127.0.0.1:8765` | Layar Layanan akun belum tersedia tampil, data belajar tidak dibuka; log browser tidak memuat error/warning saat pemeriksaan. Server/tab pengujian ditutup setelah pemeriksaan. |
| `flutter build apk --debug --no-pub` | Belum dapat dijalankan: **No Android SDK found**. Bukan bukti APK berhasil atau gagal mengompilasi kode native. |
| Login Google/Firebase nyata | Belum diuji; pengguna mengonfirmasi proyek Firebase tim belum dibuat. Fake SDK hanya dipakai pada test. |

Tes baru mencakup gagal/batal/retry login, token kosong, logout, UID/profil salah, data terpisah dua anak, perubahan kelas tanpa reset, penambahan berbarengan, gagal tulis/retry, tulis tertunda saat logout, cache rusak tidak ditimpa, sesi lama ditolak, buat/ubah profil melalui UI, gerbang wali, pembuangan route soal, dan startup tanpa konfigurasi. Mode demo hanya aktif dengan flag eksplisit pada build non-release; tidak ada fallback demo otomatis pada build release.

Status I04/I05 masih parsial: konfigurasi tim, login nyata/Android, impor data lama dengan persetujuan wali, Firestore/rules emulator, dan sinkronisasi belum selesai. Isolasi cache aplikasi bukan enkripsi penyimpanan perangkat atau bukti keamanan cloud. Tabel dan catatan init awal di bawah dipertahankan sebagai riwayat sebelum irisan akun.

## Lingkup yang dikerjakan

Baseline seluruh PRD diselaraskan dengan PPL/doktek Bab I–III terbaru. Init melanjutkan Flutter yang sudah tersedia. Model dan form memakai satu kelas 1–6, kelompok fase diturunkan dari kelas, enam titik awal diagnostic dikonfigurasi, dan skor tidak mengganti kelas. Data usia lama mempertahankan ID serta riwayat dan meminta konfirmasi kelas. JSON mendapat versi 2 dengan kunci penyimpanan lama agar data versi 1 tetap terbaca.

Controller menerbitkan state sesudah simpan repository berhasil. Adapter lokal mengubah hasil tulis/hapus `false` menjadi galat. Profil menampilkan keadaan gagal dan dapat dicoba kembali. Pemutar soal menunda banner/kunci pada diagnostic dan mastery, tetap memberi pembahasan langsung pada lesson, memakai Kirim pada tes, serta mengabaikan callback selesai berulang dari satu blok widget.

## Pemeriksaan dan hasil

| Pemeriksaan | Hasil | Batas bukti |
| --- | --- | --- |
| Baseline sebelum perubahan: `flutter test --reporter expanded` | 59 tes lulus. | Menunjukkan kode awal berjalan, bukan pemenuhan rancangan terbaru. |
| Regresi simpan sebelum perbaikan | Dua tes gagal: state profil terbit sebelum simpan selesai/berhasil. | Setelah perbaikan, kedua tes lulus. |
| Model kelas sebelum penambahan | Tes baru gagal karena model kelas belum tersedia. | Setelah penambahan, roundtrip enam kelas dan migrasi data usia lulus. |
| Perubahan profil | Nama kosong/lebih dari 30 karakter, kelas 0/7 ditolak; perubahan kelas mempertahankan riwayat; gagal simpan mempertahankan kelas lama. | Pengelolaan banyak profil dan UID belum tercakup. |
| Adapter lokal | Tulis/hapus `false` ditolak; profil, kelas, XP dapat dimuat ulang. | SharedPreferences diuji dengan mock/fake; belum bukti durabilitas proses mati. |
| Alur widget | Cerita → profil kelas → pengantar diagnostic; profil lama → konfirmasi kelas → gagal/retry → lanjut. | Tidak menjalankan login Google. |
| Asesmen | Diagnostic/mastery tanpa banner per butir; lesson dengan banner; penyelesaian widget sekali walau kirim diulang. | Belum pembahasan akhir blok, checkpoint, atau finalisasi reward idempoten. |
| Suite akhir: `flutter test --no-pub --reporter expanded` | **72 tes lulus.** | Termasuk generator 12 topik, domain progres, controller, model/repository, dan widget. |
| `flutter analyze --no-pub` | **No issues found.** | Analyzer bukan audit keamanan akun/cloud. |
| `flutter build web --no-pub` | Build web berhasil pada pemeriksaan init. | Web adalah sarana pengembangan, bukan rilis Android. |
| `git diff --check` | Tidak ada kesalahan whitespace. | Peringatan konversi CRLF/LF mengikuti konfigurasi Git. |

SDK yang digunakan adalah Flutter 3.47.5 dan Dart 3.13.4 yang sudah terpasang. Perintah Flutter dijalankan melalui snapshot SDK karena launcher/cache SDK berada di luar workspace. Tidak ada pembaruan dependensi aplikasi yang diperlukan. Build menampilkan peringatan font CupertinoIcons; tidak ada pemakaian CupertinoIcons di kode aplikasi yang ditemukan. Pemeriksaan visual ikon pada build sasaran tetap diperlukan.

Uji responsif yang sudah tersedia dijalankan kembali pada 320×568, 390×844, 844×390, 1024×768, dan 1440×900, termasuk soal landscape dengan skala teks 1,4. Ini memeriksa layout Flutter melalui widget test dan belum membuktikan keterbacaan, sentuhan, atau performa pada perangkat fisik.

## Bagian yang belum menjadi hasil init

- Firebase Authentication/Google Login, konfigurasi proyek tim, logout, beberapa profil, dan isolasi akun belum terintegrasi.
- Model bukti per skill dan akses materi belum terpisah. Diagnostic lama masih dapat menginferensikan penguasaan topik di bawah titik uji; jangan memakai hasilnya sebagai bukti penguasaan fase. Perbaikannya tercatat pada I07.
- Enam titik awal kelas belum menjadi enam paket konten berversi dan tervalidasi guru. Generator tetap konten pengembangan.
- Checkpoint atomik per respons, resume setelah proses mati, sinkronisasi/konflik, dan deduplikasi reward belum ada.
- Pembahasan setelah blok, pemeriksaan ulang 3–7 hari, gerbang/ringkasan wali lengkap, serta redesign satu MAIN belum selesai.
- Build APK/perangkat Android API 26+, RAM 2/4 GB, pengukuran 2 detik, validasi guru, dan pilot enam kelas belum dijalankan.

Syarat pada doktek 3.3.4 tetap menjadi gerbang menuju pengujian akhir. Hasil kode di atas tidak membuktikan keamanan cloud, efektivitas pembelajaran, atau terpenuhinya seluruh FR/NFR.
