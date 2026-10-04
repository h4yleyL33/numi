# Numi Builder (plugin Figma)

Membuat page aset Numi langsung di file Figma tim. Page yang sudah ada (ref item, ref bg, ui,
dan lainnya) tidak disentuh.

| Page | Isi |
|---|---|
| `mob base plate` | 11 komponen `wajah/<emosi>` dan 4 base plate mob (`mob/bulat`, `mob/tinggi`, `mob/mungil`, `mob/bersayap`) dengan rig tulang dan 7 pose |
| `anim emote` | 11 emote Numi dan 11 emote mob. Tiap emote adalah component set 4 frame yang berputar dengan Smart Animate |
| `bg animasi` | `bg/peta-malam`: latar peta 4 frame yang berputar, plus contoh layar peta |
| `item / <tema>` | 7 page barang esensial dari `../barang/barang.json`, satu kartu komponen per barang |

## Menjalankan

1. Buka file Numi di **Figma desktop** (plugin lokal tidak bisa dijalankan dari browser).
2. Menu Plugins > Development > Import plugin from manifest..., pilih `design/figma-plugin/manifest.json`.
3. Plugins > Development > Numi Builder. Centang bagian yang mau dibuat, lalu klik **Buat page**.
4. Prosesnya 10 sampai 30 detik. Log di jendela plugin menunjukkan page yang dibuat.

Plugin bisa dijalankan ulang. Page dengan nama yang sama akan dilewati. Centang **timpa** untuk
membuat ulang page yang dulu dibuat plugin ini. Page yang dibuat manual tidak pernah ditimpa.

## Rig base plate

```
mob/<tipe>  (component set: properti pose + emosi)
└─ rig/root                  geser naik/turun seluruh badan (lompat, duduk)
   ├─ rig/sayap-kiri|kanan   khusus tipe bersayap
   ├─ rig/kaki-kiri|kanan
   ├─ rig/badan
   │  ├─ badan, perut, telinga-*
   │  ├─ rig/antena-kiri|kanan
   │  └─ slot/wajah          instance wajah/<emosi>, diganti lewat properti "emosi"
   └─ rig/lengan-kiri|kanan
```

- Sendi tiap tulang ada di **tengah atas** frame tulangnya. Saat menganimasikan manual, pindahkan
  titik putar ke sana (tahan Alt/Option saat memutar, atau putar lalu geser ulang).
- Pose: `idle`, `lambai-a`, `lambai-b`, `lompat`, `duduk`, `sedih`, `tunjuk`.
- Semua variant memakai nama layer yang sama. Jadi kalau pose diganti dengan Smart Animate,
  tulang-tulangnya bergerak mulus, dan inilah cara rig dipakai untuk animasi.
- Emosi menjadi wajah: base plate tidak punya wajah sendiri. Pilih emosi di panel properti
  instance, maka `slot/wajah` diganti dengan `wajah/<emosi>`.
- Menambah pose baru: duplikat satu variant, putar tulangnya, lalu ganti nama menjadi `pose=<nama>`.
- Menambah tipe mob: tambah satu baris di `TIPE` pada `src/main.ts`.

## Melihat animasi

Taruh instance `frame=1` dari emote atau `bg/peta-malam` di dalam sebuah frame, lalu tekan
Present (Play). Variant saling tersambung dengan *After delay → Change to → Smart Animate*.

Di latar animasi ada beberapa interaksi:
- Mob bulat memancing, lalu kaget dan tertawa saat ikan melompat.
- Penjaga pulau (mob tinggi) melambai ke perahu, dan penumpang perahu membalas.
- Si mungil melompat-lompat.
- Numi terbang menyeberang, bintang berkelip, awan dan ombak bergeser.

Palet latar masih memakai warna tema malam yang ada. Kalau gaya di page `ref bg` berbeda,
sesuaikan warna di bagian `W` dan fungsi `kunciBg` di `src/main.ts`.

## Mengubah plugin

```bash
cd design/figma-plugin
npm install
npm run cek     # cek tipe terhadap Figma Plugin API
npm run build   # menghasilkan code.js
```

Aset SVG (maskot, wajah, perahu, benda) diambil dari `design/` saat build. Kalau aset diubah
dengan `node tools/buat_svg.mjs`, jalankan `npm run build` lagi.
