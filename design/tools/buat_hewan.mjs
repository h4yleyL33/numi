// Base plate hewan bergaya stiker, dijiplak dari page "animal ref" di Figma.
// Digambar di koordinat crop referensi (700 px lebar) lalu diperkecil dengan SKALA.
// Tiap hewan dipecah menjadi bagian (tulang rig) dengan kotak batas dan sendi.
// Wajah tidak digambar di sini: wajah datang dari komponen wajah/<emosi>, ditempel di titik `wajah`.
// Jalankan dari folder design: node tools/buat_hewan.mjs
// Hasil: hewan/<id>.json (dibaca plugin Figma) dan hewan/<id>-pratinjau.svg (dengan wajah senang).

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';

const GARIS = '#1F1A17';
const g = (w = 10) => `stroke="${GARIS}" stroke-width="${w}" stroke-linejoin="round" stroke-linecap="round"`;
const SKALA = 0.35;

// Bagian: { nama, kotak: [x, y, w, h] (koordinat sumber), sendi: [x, y], isi }
// Urutan array = urutan tumpukan (paling belakang dulu).
const HEWAN = {
  beruang: {
    nama: 'Beruang',
    asal: [80, 40, 580, 630], // potongan kanvas sumber yang menjadi komponen
    warna: { bulu: '#D99B62', terang: '#FADBA0' },
    // titik tengah antara dua mata dan skala wajah (wajah asli 120x120, mata di 60,54.5)
    wajah: { x: 366, y: 266, skala: 5.5 },
    bagian: (w) => [
      {
        nama: 'badan', kotak: [196, 372, 338, 268], sendi: [365, 634],
        isi: `<path d="M236 378 C206 440 202 540 230 634 L500 634 C528 540 524 440 494 378 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="365" cy="520" rx="68" ry="92" fill="${w.terang}"/>`,
      },
      {
        nama: 'kaki-kiri', kotak: [90, 488, 248, 172], sendi: [230, 500],
        isi: `<path d="M224 494 C160 496 100 522 98 576 C96 630 148 654 214 652 L332 648 C322 600 282 522 224 494 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="138" cy="578" rx="33" ry="46" transform="rotate(-10 138 578)" fill="${w.terang}"/>
<path d="M176 522 C186 528 194 536 200 548" fill="none" ${g(8)}/>`,
      },
      {
        nama: 'kaki-kanan', kotak: [392, 488, 248, 172], sendi: [500, 500],
        isi: `<path d="M506 494 C570 496 630 522 632 576 C634 630 582 654 516 652 L398 648 C408 600 448 522 506 494 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="592" cy="578" rx="33" ry="46" transform="rotate(10 592 578)" fill="${w.terang}"/>
<path d="M554 522 C544 528 536 536 530 548" fill="none" ${g(8)}/>`,
      },
      {
        nama: 'lengan-kiri', kotak: [198, 370, 168, 272], sendi: [262, 400],
        isi: `<path d="M236 378 C206 440 204 522 238 578 C256 606 288 632 322 634 C344 636 360 622 356 604 C352 588 334 572 322 556 C306 530 294 490 296 400 Z" fill="${w.bulu}" ${g()}/>
<path d="M322 582 C330 590 338 598 346 604 M298 604 C304 614 310 624 316 632" fill="none" ${g(7)}/>`,
      },
      {
        nama: 'lengan-kanan', kotak: [364, 370, 168, 272], sendi: [468, 400],
        isi: `<path d="M494 378 C524 440 526 522 492 578 C474 606 442 632 408 634 C386 636 370 622 374 604 C378 588 396 572 408 556 C424 530 436 490 434 400 Z" fill="${w.bulu}" ${g()}/>
<path d="M408 582 C400 590 392 598 384 604 M432 604 C426 614 420 624 414 632" fill="none" ${g(7)}/>`,
      },
      {
        nama: 'kepala', kotak: [160, 54, 408, 370], sendi: [365, 400],
        isi: `<circle cx="236" cy="122" r="62" fill="${w.bulu}" ${g()}/><ellipse cx="230" cy="116" rx="32" ry="38" fill="${w.terang}"/>
<circle cx="494" cy="122" r="62" fill="${w.bulu}" ${g()}/><ellipse cx="500" cy="116" rx="32" ry="38" fill="${w.terang}"/>
<path d="M365 96 C470 96 556 160 558 262 C560 354 476 412 365 412 C254 412 170 354 172 262 C174 160 260 96 365 96 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="368" cy="330" rx="70" ry="52" fill="${w.terang}"/>
<path d="M342 296 C342 288 394 288 394 296 C394 310 378 320 368 320 C358 320 342 310 342 296 Z" fill="${GARIS}"/>`,
      },
    ],
  },
  kelinci: {
    nama: 'Kelinci',
    asal: [70, 60, 560, 900],
    skala: 0.26,
    garis: 16,
    warna: { bulu: '#FBF4E4', telinga: '#F7B8C2', hidung: '#F5A9B8' },
    wajah: { x: 242, y: 428, skala: 5.2 },
    bagian: (w) => [
      {
        nama: 'ekor', kotak: [520, 723, 84, 84], sendi: [545, 770],
        isi: `<circle cx="562" cy="765" r="32" fill="${w.bulu}"/>`,
      },
      {
        nama: 'badan', kotak: [128, 535, 445, 420], sendi: [330, 940],
        isi: `<path d="M180 560 L430 548 C470 600 520 660 545 740 C565 820 540 900 470 930 C420 945 340 945 270 940 L258 876 C230 868 200 850 184 826 C176 810 172 790 169 764 L148 750 C138 700 150 620 170 572 Z" fill="${w.bulu}" stroke="none"/>
<path d="M168 578 C150 640 138 700 148 750"/>
<path d="M430 550 C470 600 520 660 545 740 C565 820 540 900 470 930 C420 945 340 945 270 943"/>`,
      },
      {
        nama: 'kaki-belakang', kotak: [240, 840, 165, 115], sendi: [300, 880],
        isi: `<path d="M290 856 C330 858 360 876 388 900 L380 934 L272 934 C258 936 258 900 268 878 Z" fill="${w.bulu}" stroke="none"/>
<path d="M258 870 C252 862 262 856 290 856 C330 858 360 876 388 900"/>
<path d="M290 862 C268 878 258 900 258 922 C258 936 266 942 280 943"/>
<path d="M282 902 C280 910 278 918 277 925 M316 910 C314 916 312 922 310 928" stroke-width="12"/>`,
      },
      {
        nama: 'kaki-depan', kotak: [125, 750, 145, 160], sendi: [210, 840],
        isi: `<path d="M180 826 C160 840 140 862 138 878 C136 892 150 896 175 896 C200 896 225 892 248 888 L240 860 Z" fill="${w.bulu}" stroke="none"/>
<path d="M180 826 C160 840 140 862 138 878 C136 892 150 896 175 896 C200 896 225 892 248 888"/>
<path d="M172 864 C168 870 166 876 164 882" stroke-width="12"/>
<path d="M169 764 C172 790 176 810 184 826 C200 850 230 868 258 876"/>`,
      },
      {
        nama: 'lengan-kiri', kotak: [132, 636, 125, 135], sendi: [225, 650],
        isi: `<path d="M146 728 C150 752 172 762 204 752"/>
<path d="M214 648 C218 660 224 672 228 680 M246 648 C242 660 234 672 228 680 M228 680 C224 700 218 724 213 742"/>`,
      },
      {
        nama: 'lengan-kanan', kotak: [200, 668, 140, 112], sendi: [328, 681],
        isi: `<path d="M328 681 C300 712 272 746 252 762 C238 772 220 770 214 754"/>`,
      },
      {
        nama: 'telinga-belakang', induk: 'kepala', kotak: [238, 60, 160, 245], sendi: [300, 285],
        isi: `<path d="M250 272 C258 210 285 125 340 88 C372 70 388 120 382 165 C376 210 352 255 340 290 Z" fill="${w.bulu}"/>`,
      },
      {
        nama: 'telinga-depan', induk: 'kepala', kotak: [320, 88, 200, 262], sendi: [380, 320],
        isi: `<path d="M335 286 C350 240 392 160 450 120 C490 96 512 118 508 175 C504 240 470 300 412 340 Z" fill="${w.bulu}"/>
<path d="M402 300 C412 240 440 182 478 152 C490 192 484 240 458 272 Z" fill="${w.telinga}" stroke="none"/>`,
      },
      {
        nama: 'kepala', kotak: [80, 262, 390, 335], sendi: [275, 575],
        isi: `<path d="M195 572 C150 568 108 545 95 505 C86 475 92 448 106 430 C112 380 150 318 205 288 C250 268 310 272 345 288 C380 300 400 320 412 340 C440 375 458 430 456 475 C454 520 420 560 355 572 L270 590 Z" fill="${w.bulu}" stroke="none"/>
<path d="M195 572 C150 568 108 545 95 505 C86 475 92 448 106 430 C112 380 150 318 205 288 C250 268 310 272 345 288 C380 300 400 320 412 340 C440 375 458 430 456 475 C454 520 420 560 355 572"/>
<path d="M202 464 C204 458 236 458 240 464 C236 474 226 480 220 480 C214 480 204 472 202 464 Z" fill="${w.hidung}" stroke="none"/>`,
      },
    ],
  },
};

const f = (n) => Math.round(n * 100) / 100;
// Pratinjau: bagian anak (induk) digambar tepat sebelum induknya, sama seperti di Figma.
const urutGambar = (bagian) => bagian.filter((b) => !b.induk).flatMap((b) => [...bagian.filter((a) => a.induk === b.nama), b]);
mkdirSync('hewan', { recursive: true });
const wajahSenang = readFileSync('wajah/wajah-senang.svg', 'utf8').replace(/#2A2350/g, GARIS).replace(/<\/?svg[^>]*>/g, '');
for (const [id, h] of Object.entries(HEWAN)) {
  const [ox, oy, ow, oh] = h.asal;
  const S = h.skala ?? SKALA;
  const ke = (x, y) => [f((x - ox) * S), f((y - oy) * S)];
  // Hewan yang digambar tanpa atribut garis per elemen memakai satu grup garis (h.garis = tebal).
  const bungkus = (isi) => (h.garis ? `<g ${g(h.garis)} fill="none">${isi}</g>` : isi);
  const bagian = h.bagian(h.warna).map((b) => ({ ...b, isi: bungkus(b.isi) }));
  const data = {
    id, nama: h.nama, ukuran: [f(ow * S), f(oh * S)],
    wajah: { x: ke(h.wajah.x, h.wajah.y)[0], y: ke(h.wajah.x, h.wajah.y)[1], skala: f(h.wajah.skala * S) },
    bagian: bagian.map((b) => {
      const [x, y, w, t] = b.kotak;
      return {
        nama: b.nama, induk: b.induk, kotak: [...ke(x, y), f(w * S), f(t * S)], sendi: ke(...b.sendi),
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="${f(w * S)}" height="${f(t * S)}" viewBox="${b.kotak.join(' ')}">${b.isi}</svg>`,
      };
    }),
  };
  writeFileSync(`hewan/${id}.json`, JSON.stringify(data, null, 1));
  const { x, y, skala } = h.wajah;
  const wajah = `<g transform="translate(${x - 60 * skala} ${y - 54.5 * skala}) scale(${skala})">${wajahSenang}</g>`;
  writeFileSync(`hewan/${id}-pratinjau.svg`, `<svg xmlns="http://www.w3.org/2000/svg" width="${f(ow * S)}" height="${f(oh * S)}" viewBox="${h.asal.join(' ')}">${urutGambar(bagian).map((b) => b.isi).join('\n')}${wajah}</svg>`);
}
console.log('selesai', Object.keys(HEWAN).join(', '));
