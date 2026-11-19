# Tujuh diagram implementasi Numi — 19 November 2026

Pengganti ketujuh gambar yang ditinjau, berdasarkan kode aplikasi pada commit `7be1c23fb929d251d01fe532e544f140267b1437`. Diagram menjelaskan implementasi MVP yang tersedia, dengan atribut utama dipilih agar tetap terbaca. Arsip rancangan sebelumnya tetap disimpan di direktori induk.

## Gambar siap pakai

Pakai PNG untuk menempel ke dokumen dan SVG untuk diperbesar tanpa pecah. Sumber PlantUML dapat diedit lalu dirender ulang secara lokal.

| Urutan gambar asal | Diagram | PNG | SVG | Sumber |
|---|---|---|---|---|
| 1 | Activity: alur belajar | [PNG](png/activity.png) | [SVG](svg/activity.svg) | [PlantUML](src/activity.puml) |
| 2 | Use case: siswa, wali, layanan luar | [PNG](png/usecase.png) | [SVG](svg/usecase.svg) | [PlantUML](src/usecase.puml) |
| 3 | Sequence: akun, profil, sinkronisasi | [PNG](png/auth-sequence.png) | [SVG](svg/auth-sequence.svg) | [PlantUML](src/auth-sequence.puml) |
| 4 | Sequence: jawaban, checkpoint, hasil | [PNG](png/learning-sequence.png) | [SVG](svg/learning-sequence.svg) | [PlantUML](src/learning-sequence.puml) |
| 5 | Package: impor kode Dart | [PNG](png/packages.png) | [SVG](svg/packages.svg) | [PlantUML](src/packages.puml) |
| 6 | Class: model aktif | [PNG](png/classes.png) | [SVG](svg/classes.svg) | [PlantUML](src/classes.puml) |
| 7 | ERD logis: snapshot dan konten | [PNG](png/erd.png) | [SVG](svg/erd.svg) | [PlantUML](src/erd.puml) |

## Perubahan terhadap gambar asal

1. **Activity:** diagnostic mengikuti kelas/prasyarat, maksimal 12 soal, dan dapat dilanjutkan dari checkpoint. Lesson serta mastery dipisahkan. Lesson lulus minimal 3/5; bukti awal mastery memerlukan 5/5 tanpa bantuan. Hasil, XP, dan progres disimpan lokal sekali per sesi. Periksa ulang setelah lulus dijadwalkan lima hari kemudian; gagal diarahkan ke remedial.
2. **Use case:** menambahkan melanjutkan sesi, rincian wali, persetujuan sinkronisasi, dan penyelesaian konflik. Siswa/wali adalah aktor interaksi; akses cloud dibatasi UID wali. Guru tetap validator di luar aplikasi. Nomor UC yang sudah digunakan dipertahankan; fungsi cloud/rincian tambahan diberi nama tanpa menetapkan nomor RTM baru.
3. **Sequence akun:** `masukGoogle()` dan stream `perubahanAkun` mengikuti implementasi Firebase. UI memuat profil melalui repository profil, terpisah dari repository autentikasi. Profil baru/diubah memerlukan pemeriksaan nama dan kelas. Sinkronisasi opsional memvalidasi setiap profil, memakai revisi bersyarat, serta mencadangkan kedua versi saat menyelesaikan konflik.
4. **Sequence belajar:** jawaban pertama dan posisi disimpan sebelum layar maju. Kegagalan simpan dapat dicoba lagi. Lesson memberi feedback langsung; diagnostic/mastery menunda pembahasan. Finalisasi dan reward tidak menunggu konfirmasi server. Pengiriman cloud berjalan terpisah, bukan syarat menyelesaikan blok.
5. **Package:** enam kelompok folder dan 17 arah dependensi mengikuti impor nyata. Kontrak repository berada di `data/repositories`; impor silang antarkelompok ditampilkan sebagaimana kode, termasuk siklus. Diagram ini tidak menyatakan arsitektur bersih satu arah.
6. **Class:** mengganti entitas rancangan dengan `Siswa`, `DataBelajar`, `CheckpointDiagnostic`, `SesiSoal`, `Jawaban`, dan model aktif lainnya. `SesiMastery` adalah alias `SesiSoal`. Posisi berasal dari jumlah jawaban dan `menungguLanjut`; tidak ada field `cursor`, `responseId`, atau reward-ID tersendiri. Batas kardinalitas mengikuti katalog MVP 12 topik/24 lesson saat ini.
7. **ERD:** relasi bersifat logis di dalam snapshot, bukan tabel SQL atau subkoleksi per sesi. Firestore menyimpan `wali/{uid}/profil/{profilId}` berisi `versi`, `dasar`, dan `data`. `data` adalah JSON `DataBelajar` format 5; Sembast menyimpan snapshot lokal per UID, metadata sinkronisasi, dan cadangan konflik. Topik serta paket kelas adalah konten aplikasi lokal.

## Dasar kode dan batas cakupan

| Bagian | Acuan |
|---|---|
| Autentikasi dan pergantian akun | [FirebaseAkunRepository](../../../../app/lib/data/repositories/firebase_akun_repository.dart), [AkunApp](../../../../app/lib/features/account/akun_app.dart) |
| Profil, simpan lokal, sinkronisasi, konflik | [LocalProfilRepository](../../../../app/lib/data/repositories/local_profil_repository.dart), [adapter cloud](../../../../app/lib/data/repositories/cloud_profil_repository.dart) |
| Simpan respons dan finalisasi | [NumiController](../../../../app/lib/state/numi_controller.dart), [SesiSoal](../../../../app/lib/data/models/sesi_soal.dart) |
| Struktur snapshot dan kelas | [DataBelajar](../../../../app/lib/data/models/data_belajar.dart), [Siswa](../../../../app/lib/data/models/siswa.dart), [PaketKelas](../../../../app/lib/data/content/paket_kelas.dart) |
| Bukti pengujian aplikasi | [Verifikasi rilis](../../../04-pengujian/VERIFIKASI-RILIS.md) |

Sinkronisasi aktif hanya setelah izin wali. Pengiriman dicoba tiap 30 detik; penarikan diterapkan dari pemilih profil saat navigasi ditahan. Finalisasi belajar berlangsung lokal. Pemeriksaan jawaban tepercaya di server, portal guru, dan graf seluruh subketerampilan SD belum menjadi fitur yang sudah selesai. Paket pengantar/generator soal masih memerlukan validasi pendidik. Data usia/kelompok lama dibaca untuk kompatibilitas; profil baru memakai kelas 1–6.

Diagram kelas hanya memuat atribut utama, bukan dokumentasi seluruh API. ERD menampilkan profil sah yang sudah mempunyai kelas; model Dart masih menerima `kelas`/`waliUid` kosong untuk kompatibilitas data lama sebelum dikonfirmasi wali. `skillId` jangkar topik tidak berarti sudah ada entitas `Subketerampilan` terpisah.

## Render dan periksa ulang

Butuh Python 3, Java, PlantUML, dan Graphviz yang sudah terpasang. Dari akar repository, sesuaikan lokasi perkakas:

```powershell
python docs/02-perancangan/uml/implementasi-2026-11-19/render.py --jar '<lokasi>/plantuml.jar' --java '<lokasi>/java.exe' --dot '<lokasi>/dot.exe'
```

Alternatif: set `PLANTUML_JAR` dan `GRAPHVIZ_DOT`, lalu jalankan skrip tanpa kedua argumen tersebut. `--java` opsional jika Java tersedia di PATH. Semua render berjalan lokal.

Skrip menolak perubahan dependensi paket yang belum tercermin di diagram, memeriksa tujuh sumber, merender PNG/SVG, memeriksa format keluaran, lalu mencatat dimensi serta SHA-256 di [manifest.json](manifest.json). [imports.json](imports.json) berisi jumlah impor dan satu contoh lokasi kode untuk setiap arah dependensi. Pemeriksaan ini hanya menguji impor Dart internal, bukan seluruh dependensi transitif atau runtime.

Verifikasi pembaruan ini: tujuh PNG dan tujuh SVG berhasil dirender, 17 arah impor cocok, serta semua gambar ditinjau secara visual. Tidak ada perubahan perilaku aplikasi sehingga pengujian Flutter tidak diulang untuk pembaruan dokumentasi ini. Gambar tertanam dalam Word/PDF/Figma belum diganti oleh paket ini.
