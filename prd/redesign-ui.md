# Redesign UI Numi: Lebih Sedikit Tombol

Masukan tim: UI sekarang terlalu banyak tombol. Dokumen ini mengaudit layar yang ada, lalu
merancang ulang dengan satu prinsip dari `kajian-ui-anak.md`: satu layar, satu tombol utama.

Mockup hasil redesign ada di `mockup/` (8 layar, 360 × 780). Berkas SVG bisa diseret langsung
ke Figma dan tetap bisa diedit sebagai vektor. Untuk membuat ulang setelah aset berubah:

```bash
node prd/mockup/buat_mockup.mjs
```

## 1. Audit layar lama

Hitungan diambil dari kode di `app/lib/features` (yang dibuat mengikuti Figma halaman `ui`).
"Target" berarti semua yang bisa diketuk anak.

| Layar | Target yang bisa diketuk | Masalah |
|---|---|---|
| Peta | 12 pulau + legenda (bisa dibuka) + 2 tab navigasi bawah | Anak tidak tahu harus mulai dari mana; saran Numi kalah oleh 12 pulau yang sama menariknya |
| Lembar pulau | 2 tombol lesson (Mulai/Ulangi) + tombol mastery + daftar prasyarat | Tiga tombol besar sejajar; anak sering menekan mastery yang masih terkunci |
| Progres | kartu streak + 8 lencana yang bisa dibalik + daftar 12 topik + tombol hapus data | Tombol hapus data ada di layar anak; daftar topik berisi istilah fase yang tidak dipahami anak |
| Lesson kenalan | tombol tutup + "Lalu?" berulang | Anak harus menekan "Lalu?" tiga kali sebelum latihan |
| Soal | tombol tutup + 3-4 pilihan + Cek Jawaban (terlihat sejak awal, abu-abu) | Tombol Cek abu-abu sering ditekan berulang karena dikira rusak |
| Hasil sesi | dua tombol (utama dan kedua) | Anak bingung memilih "Ulangi" atau "Kembali" |

Total di alur belajar satu pulau (peta, lembar pulau, lesson, 5 soal, hasil): sekitar 40
keputusan ketuk, dan 9 di antaranya adalah pilihan navigasi, bukan menjawab soal.

## 2. Prinsip redesign

1. **Satu tombol MAIN.** Di peta ada satu tombol besar di bawah. Sistem memilih langkah
   berikutnya dari learning path (FR-003): lesson Kenalan, Latihan, atau mastery test.
2. **Pulau tetap bisa diketuk**, tetapi hanya membuka kartu pulau yang berisi satu tombol MAIN
   untuk pulau itu. Lesson dan mastery tidak lagi jadi tiga tombol terpisah; ketiganya tampil
   sebagai tiga titik langkah (Kenalan, Latihan, Mercusuar).
3. **Navigasi bawah dihapus.** Progres dibuka dengan mengetuk api streak atau bintang XP di
   pojok atas peta. Tidak ada tab yang perlu dipahami.
4. **Tombol Cek muncul setelah menjawab.** Sebelum anak memilih jawaban, tombol tidak ada.
5. **Hasil sesi hanya punya Lanjut.** Kalau lesson belum lulus, Lanjut otomatis mengulang
   dengan soal baru (UC-003 alur alternatif). Anak tidak perlu memilih.
6. **Urusan orang tua dipindah.** Hapus data, rincian per topik, dan pengaturan masuk ke Ruang
   Orang Tua yang dibuka dengan tekan tahan 3 detik.
7. **Lesson Kenalan berjalan sendiri.** Penjelasan Numi muncul satu per satu dengan suara;
   tombol "Lalu?" diganti satu tombol "Ayo latihan" di akhir.

## 3. Sebelum dan sesudah

| Layar | Sebelum | Sesudah | Mockup |
|---|---|---|---|
| Peta | 12 pulau, legenda, 2 tab | 1 tombol MAIN, pulau bisa diketuk, 2 ikon atas | `01-peta.svg` |
| Soal kelas kecil | tutup, pilihan, Cek abu-abu | kembali, suara, pilihan, Cek muncul setelah memilih | `02-soal-kelas-kecil.svg` |
| Soal kelas besar | sama dengan kelas kecil | soal cerita di kartu, 4 pilihan lebar penuh | `03-soal-kelas-besar.svg` |
| Umpan balik salah | banner merah | banner koral, Numi semangat, satu tombol Lanjut | `04-umpan-balik-salah.svg` |
| Hasil sesi | 2 tombol | 1 tombol Lanjut | `05-hasil-sesi.svg` |
| Lembar pulau | 3 tombol | 3 titik langkah, 1 tombol MAIN | `06-kartu-pulau.svg` |
| Progres | streak, lencana, 12 topik, hapus data | streak, lencana, 12 titik pulau, ikon orang tua | `07-progres-anak.svg` |
| (baru) Ruang Orang Tua | - | status 12 topik, persentase benar, pengaturan | `08-ruang-orang-tua.svg` |

Jumlah keputusan navigasi di alur satu pulau turun dari 9 menjadi 3 (MAIN, Lanjut, Lanjut).

## 4. Susunan layar di Figma

Halaman `ui` di Figma berisi 20 layar. Usulan susunan baru untuk halaman `ui v2`:

| No | Layar | Catatan |
|---|---|---|
| 01 | Splash | sama |
| 02-04 | Cerita pembuka | tombol Lanjut di bawah, ketuk di mana saja juga lanjut |
| 05 | Nama dan umur | umur berupa 7 bola angka 6-12, tanpa keyboard angka |
| 06 | Pembuka diagnostic | Numi berpikir, satu tombol "Ayo mulai" |
| 07 | Soal diagnostic | tanpa umpan balik, tanpa tombol kembali |
| 08 | Hasil diagnostic | peta mini dan kelompok belajar, satu tombol "Lihat peta" |
| 09 | Peta | `01-peta.svg` |
| 10 | Kartu pulau | `06-kartu-pulau.svg` |
| 11 | Kenalan | penjelasan Numi otomatis dengan suara |
| 12 | Soal kelas kecil | `02-soal-kelas-kecil.svg`, varian per bentuk soal |
| 13 | Soal kelas besar | `03-soal-kelas-besar.svg` |
| 14 | Umpan balik benar dan salah | `04-umpan-balik-salah.svg` |
| 15 | Hasil sesi | `05-hasil-sesi.svg` |
| 16 | Mastery: menyalakan mercusuar | animasi mercusuar padam ke menyala |
| 17 | Progres anak | `07-progres-anak.svg` |
| 18 | Gerbang dan Ruang Orang Tua | `08-ruang-orang-tua.svg` |
| 19 | Pesan maskot | balon kata di atas peta, hilang sendiri setelah 7 detik |

Dari 20 layar jadi 19, tetapi yang lebih penting jumlah tombol per layar: paling banyak satu
tombol utama dan dua ikon.

## 5. Aset yang ditambahkan

Dibuat oleh `design/tools/buat_svg.mjs`, siap diseret ke Figma halaman `asset`.

| Kelompok | Berkas | Dipakai di |
|---|---|---|
| Ekspresi maskot baru | `numi-terkejut`, `numi-tertawa`, `numi-kagum`, `numi-tidur`, `numi-mengedip` | terkejut: soal baru jenis lain; tertawa: jawaban benar beruntun; kagum: lencana baru; tidur: aplikasi dibuka malam hari; mengedip: petunjuk |
| Lencana | `aset/lencana/lencana-*.svg` (8 + terkunci) | layar progres, hasil sesi |
| Ikon besar | `aset/ikon/ikon-suara`, `-kembali`, `-main`, `-petunjuk` | semua layar soal |
| Benda hitung | `aset/benda/apel`, `kerang`, `ikan`, `kue` | soal kelas kecil |
| Dunia | `api-streak-nyala`, `api-streak-redup`, `bintang-xp`, `kabut-lupa`, `perahu` | peta, progres, cerita pembuka |

Semua aset bisa dilihat sekaligus di `design/pratinjau-aset.html`.

## 6. Dampak ke kode dan doktek

| Perubahan | Berkas yang diubah | Doktek |
|---|---|---|
| Tombol MAIN di peta | `skill_map_screen.dart`, `learning_path_service.dart` (sudah ada) | UC-009 alur utama |
| Navigasi bawah dihapus | `home_shell.dart` | 2.2 user flow |
| Kartu pulau satu tombol | `topik_sheet.dart` | UC-002, UC-003 |
| Cek muncul setelah memilih | `pemutar_soal.dart` | - |
| Banner koral | `banner_umpan_balik.dart` | UC-004 |
| Ruang Orang Tua | layar baru di `features/progress` | UC-006 alur alternatif |
| Suara pembaca soal | paket `flutter_tts`, `tampilan_soal.dart` | NFR-001 |

Perubahan kode belum dikerjakan. Tunggu mockup disetujui tim di Figma, lalu dikerjakan di
minggu implementasi.
