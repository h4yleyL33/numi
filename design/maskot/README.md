# Maskot Numi

Numi adalah kunang-kunang bulat berwarna kuning jingga dengan dua antena bercahaya, sayap
bening, dan ekor yang menyala. Berkas di folder ini dibuat oleh `../tools/buat_svg.mjs`
dengan ukuran dan warna yang sama dengan widget `NumiMascot` di aplikasi, jadi mengubah
bentuk maskot cukup di dua tempat itu.

```bash
node tools/buat_svg.mjs
```

Perintah di atas dijalankan dari folder `design`. Hasilnya menimpa semua SVG di `maskot/`
dan `aset/`.

## Ekspresi dan kapan dipakai

| Ekspresi | Berkas | Dipakai saat |
|---|---|---|
| senang | `numi-senang.svg` | sapaan harian, splash, form profil |
| berpikir | `numi-berpikir.svg` | pembuka diagnostic, poin penjelasan lesson |
| semangat | `numi-semangat.svg` | jawaban salah, lesson atau mastery belum berhasil |
| sedih | `numi-sedih.svg` | siswa tidak aktif 3 hari atau lebih |
| mengantuk | `numi-mengantuk.svg` | streak terancam putus, cahayanya juga lebih redup |
| bangga | `numi-bangga.svg` | lesson selesai, mercusuar menyala, lencana baru |

Pemetaan ini sama dengan `app/lib/data/content/kalimat_maskot.dart`.

Ekspresi tambahan untuk redesign (`prd/redesign-ui.md`), belum dipakai di aplikasi:

| Ekspresi | Berkas | Usulan pemakaian |
|---|---|---|
| terkejut | `numi-terkejut.svg` | bentuk soal baru muncul pertama kali |
| tertawa | `numi-tertawa.svg` | tiga jawaban benar beruntun |
| kagum | `numi-kagum.svg` | lencana baru |
| tidur | `numi-tidur.svg` | aplikasi dibuka malam hari (di atas 21.00) |
| mengedip | `numi-mengedip.svg` | petunjuk atau tips |

Aset lain (lencana, ikon, benda hitung, api streak, perahu, kabut) ada di `../aset/`.
Semua bisa dilihat sekaligus di `../pratinjau-aset.html`.

## Warna

| Bagian | Warna |
|---|---|
| Tubuh | gradasi `#FFD166` ke `#F4A340` |
| Perut | `#FFF1C1` |
| Garis wajah dan antena | `#2A2350` |
| Cahaya | `#FFB547` dan `#FFD98A` |
| Pipi | `#FF9AA2` |

## Aturan pakai

Maskot tidak pernah memarahi atau menyalahkan. Saat siswa salah, ekspresi yang dipakai
adalah semangat, bukan sedih. Ekspresi sedih hanya untuk ajakan kembali setelah lama tidak
aktif.

Doktek menyebut Rive untuk animasi maskot. Aplikasi saat ini menggambar maskot dengan
CustomPainter (berkedip, melayang, sayap mengepak) supaya tidak bergantung pada berkas
animasi. Kalau tim membuat berkas Rive, ekspresinya cukup mengikuti enam nama di atas.

Semua aset ini juga tersedia sebagai komponen di Figma, halaman `asset`.
