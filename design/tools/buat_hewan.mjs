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
};

const f = (n) => Math.round(n * 100) / 100;
mkdirSync('hewan', { recursive: true });
const wajahSenang = readFileSync('wajah/wajah-senang.svg', 'utf8').replace(/#2A2350/g, GARIS).replace(/<\/?svg[^>]*>/g, '');
for (const [id, h] of Object.entries(HEWAN)) {
  const [ox, oy, ow, oh] = h.asal;
  const ke = (x, y) => [f((x - ox) * SKALA), f((y - oy) * SKALA)];
  const bagian = h.bagian(h.warna);
  const data = {
    id, nama: h.nama, ukuran: [f(ow * SKALA), f(oh * SKALA)],
    wajah: { x: ke(h.wajah.x, h.wajah.y)[0], y: ke(h.wajah.x, h.wajah.y)[1], skala: f(h.wajah.skala * SKALA) },
    bagian: bagian.map((b) => {
      const [x, y, w, t] = b.kotak;
      return {
        nama: b.nama, kotak: [...ke(x, y), f(w * SKALA), f(t * SKALA)], sendi: ke(...b.sendi),
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="${f(w * SKALA)}" height="${f(t * SKALA)}" viewBox="${b.kotak.join(' ')}">${b.isi}</svg>`,
      };
    }),
  };
  writeFileSync(`hewan/${id}.json`, JSON.stringify(data, null, 1));
  const { x, y, skala } = h.wajah;
  const wajah = `<g transform="translate(${x - 60 * skala} ${y - 54.5 * skala}) scale(${skala})">${wajahSenang}</g>`;
  writeFileSync(`hewan/${id}-pratinjau.svg`, `<svg xmlns="http://www.w3.org/2000/svg" width="${f(ow * SKALA)}" height="${f(oh * SKALA)}" viewBox="${h.asal.join(' ')}">${bagian.map((b) => b.isi).join('\n')}${wajah}</svg>`);
}
console.log('selesai', Object.keys(HEWAN).join(', '));
