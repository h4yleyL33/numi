// Membuat mockup layar redesign Numi sebagai SVG 360x780 (ukuran ponsel Android umum).
// Aset maskot, pulau, dan ikon diambil dari design/ supaya sama persis dengan aset Figma.
// Jalankan dari folder prd/mockup: node buat_mockup.mjs

import { readFileSync, writeFileSync } from 'node:fs';

const W = 360, H = 780;
const T = { malam: '#1B1F4B', laut: '#243B8F', cahaya: '#FFB547', muda: '#FFD98A', krem: '#FFF8EC', tinta: '#232347', pudar: '#6C6C8A', benar: '#2EBD8E', benarMuda: '#D7F5EA', koral: '#FFE1E1', koralTua: '#B23A3A' };
const FONT = `font-family="Nunito, Arial, sans-serif"`;

let nomorId = 0;
// Menyisipkan SVG aset sebagai <svg> bersarang. id gradien diberi akhiran unik supaya tidak bentrok.
function aset(path, x, y, w, h) {
  const k = `_${nomorId++}`;
  const isi = readFileSync(new URL(`../../design/${path}`, import.meta.url), 'utf8')
    .replace(/id="(\w+)"/g, `id="$1${k}"`).replace(/url\(#(\w+)\)/g, `url(#$1${k})`)
    .replace(/<svg ([^>]*?)width="[\d.]+" height="[\d.]+"/, `<svg $1x="${x}" y="${y}" width="${w}" height="${h}"`);
  return isi.trim();
}
const teks = (x, y, isi, { size = 16, w = 700, fill = T.tinta, anchor = 'start' } = {}) =>
  `<text x="${x}" y="${y}" ${FONT} font-size="${size}" font-weight="${w}" fill="${fill}" text-anchor="${anchor}">${isi}</text>`;
const kotak = (x, y, w, h, r, fill, extra = '') => `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${r}" fill="${fill}" ${extra}/>`;
function tombol(y, label, { h = 72, fill = T.cahaya, warna = T.tinta, sub } = {}) {
  return [
    kotak(20, y + 6, W - 40, h, h / 2, '#000000', 'fill-opacity="0.18"'),
    kotak(20, y, W - 40, h, h / 2, fill),
    teks(W / 2, y + (sub ? h / 2 - 2 : h / 2 + 8), label, { size: 24, w: 900, fill: warna, anchor: 'middle' }),
    sub ? teks(W / 2, y + h / 2 + 18, sub, { size: 13, w: 700, fill: warna, anchor: 'middle' }) : '',
  ].join('');
}
const layar = (bg, isi) => `<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}">\n${kotak(0, 0, W, H, 0, bg)}\n${isi.flat().join('\n')}\n</svg>\n`;
const titikProgres = (y, selesai, aktif) => [0, 1, 2, 3, 4].map((i) =>
  `<circle cx="${W / 2 - 48 + i * 24}" cy="${y}" r="${i === aktif ? 8 : 6}" fill="${i < selesai ? T.cahaya : i === aktif ? T.muda : '#E4DFD3'}"/>`).join('');

// 01 peta (beranda)
function peta() {
  const pulau = [
    ['pulau-dikuasai', 52, 520, 'Kerikil'], ['pulau-dikuasai', 210, 470, 'Kelapa'],
    ['pulau-latihan', 90, 360, 'Pelangi'], ['pulau-belum', 230, 280, 'Kabut'],
    ['pulau-belum', 60, 200, 'Semangka'], ['pulau-terkunci', 210, 120, 'Karang'],
  ];
  const el = [];
  for (let i = 0; i < 40; i++) el.push(`<circle cx="${(i * 97) % W}" cy="${(i * 53) % 640}" r="${i % 3 ? 1 : 1.6}" fill="#FFFFFF" fill-opacity="0.5"/>`);
  el.push(`<path d="M100 580 C 200 560, 260 540, 268 530 S 120 430, 150 420 S 280 350, 290 340 S 100 270, 120 260 S 260 190, 270 180" fill="none" stroke="#FFFFFF" stroke-opacity="0.25" stroke-width="4" stroke-dasharray="2 12" stroke-linecap="round"/>`);
  for (const [a, x, y, nama] of pulau) {
    el.push(aset(`aset/${a}.svg`, x, y, 110, 110));
    el.push(teks(x + 55, y + 112, nama, { size: 13, fill: '#FFFFFF', anchor: 'middle' }));
  }
  el.push(aset('maskot/numi-senang.svg', 105, 290, 80, 80));
  // bilah atas: streak dan XP, keduanya membuka layar progres
  el.push(kotak(16, 20, 92, 44, 22, '#FFFFFF', 'fill-opacity="0.12"'), aset('aset/api-streak-nyala.svg', 20, 22, 40, 40), teks(66, 49, '3', { size: 20, w: 900, fill: '#FFFFFF' }));
  el.push(kotak(W - 124, 20, 108, 44, 22, '#FFFFFF', 'fill-opacity="0.12"'), aset('aset/bintang-xp.svg', W - 120, 22, 40, 40), teks(W - 74, 49, '120', { size: 20, w: 900, fill: '#FFFFFF' }));
  el.push(kotak(0, 640, W, 140, 0, T.malam, 'fill-opacity="0.92"'));
  el.push(tombol(668, 'MAIN', { sub: 'Pulau Pelangi · Latihan' }));
  return layar(T.malam, el);
}

// 02 soal kelas kecil
function soalKecil() {
  const el = [aset('aset/ikon/ikon-kembali.svg', 16, 20, 48, 48), aset('aset/ikon/ikon-suara.svg', W - 72, 16, 56, 56), titikProgres(44, 2, 2)];
  el.push(teks(W / 2, 130, 'Ada berapa apel?', { size: 32, w: 900, anchor: 'middle' }));
  for (let i = 0; i < 8; i++) el.push(aset('aset/benda/apel.svg', 30 + (i % 5) * 60, 170 + Math.floor(i / 5) * 70, 56, 56));
  [7, 8, 9].forEach((n, i) => {
    const x = 24 + i * 108, dipilih = n === 8;
    el.push(kotak(x, 360, 96, 96, 24, dipilih ? T.muda : '#FFFFFF', `stroke="${dipilih ? T.cahaya : '#E4DFD3'}" stroke-width="4"`));
    el.push(teks(x + 48, 422, n, { size: 40, w: 900, anchor: 'middle' }));
  });
  el.push(teks(W / 2, 520, 'Tombol Cek muncul setelah anak memilih', { size: 12, w: 600, fill: T.pudar, anchor: 'middle' }));
  el.push(tombol(668, 'Cek', { fill: T.malam, warna: '#FFFFFF' }));
  return layar(T.krem, el);
}

// 03 soal kelas besar
function soalBesar() {
  const el = [aset('aset/ikon/ikon-kembali.svg', 16, 20, 44, 44), teks(W / 2, 48, '3 dari 5', { size: 16, w: 800, fill: T.pudar, anchor: 'middle' }), aset('aset/ikon/ikon-suara.svg', W - 64, 20, 44, 44)];
  el.push(kotak(20, 76, W - 40, 8, 4, '#E4DFD3'), kotak(20, 76, (W - 40) * 0.6, 8, 4, T.cahaya));
  el.push(kotak(20, 110, W - 40, 190, 24, '#FFFFFF'));
  ['Bu Sari punya 48 kue.', 'Kue dibagi rata ke 6 piring.', 'Berapa kue di setiap piring?'].forEach((b, i) => el.push(teks(36, 160 + i * 34, b, { size: 19, w: 800 })));
  el.push(teks(40, 278, 'Pulau Pasar Apung · Pembagian', { size: 12, w: 700, fill: T.pudar }));
  [6, 7, 8, 9].forEach((n, i) => {
    const y = 330 + i * 84, dipilih = n === 8;
    el.push(kotak(20, y, W - 40, 72, 20, dipilih ? T.muda : '#FFFFFF', `stroke="${dipilih ? T.cahaya : '#E4DFD3'}" stroke-width="3"`));
    el.push(teks(W / 2, y + 46, n, { size: 28, w: 900, anchor: 'middle' }));
  });
  el.push(tombol(684, 'Cek Jawaban', { h: 56, fill: T.malam, warna: '#FFFFFF' }));
  return layar(T.krem, el);
}

// 04 umpan balik salah (kelas kecil)
function umpanBalik() {
  const el = [titikProgres(44, 2, 2), teks(W / 2, 130, 'Ada berapa apel?', { size: 32, w: 900, anchor: 'middle', fill: T.pudar })];
  for (let i = 0; i < 8; i++) el.push(aset('aset/benda/apel.svg', 30 + (i % 5) * 60, 170 + Math.floor(i / 5) * 70, 56, 56));
  el.push(kotak(0, 470, W, 310, 32, T.koral));
  el.push(aset('maskot/numi-semangat.svg', 16, 470, 120, 120));
  el.push(teks(140, 520, 'Hampir!', { size: 26, w: 900, fill: T.koralTua }));
  el.push(teks(140, 552, 'Jawabannya 8.', { size: 20, w: 800, fill: T.koralTua }));
  el.push(teks(140, 580, '5 di atas, 3 di bawah.', { size: 16, w: 700, fill: T.koralTua }));
  el.push(tombol(668, 'Lanjut', { fill: T.koralTua, warna: '#FFFFFF' }));
  return layar(T.krem, el);
}

// 05 hasil sesi
function hasil() {
  const el = [aset('maskot/numi-bangga.svg', 80, 60, 200, 200)];
  el.push(teks(W / 2, 300, 'Pulau makin terang!', { size: 28, w: 900, fill: '#FFFFFF', anchor: 'middle' }));
  [0, 1, 2].forEach((i) => el.push(aset('aset/bintang-xp.svg', 80 + i * 70, 330, 64, 64)));
  el.push(kotak(40, 430, 130, 96, 24, '#FFFFFF', 'fill-opacity="0.1"'), teks(105, 475, '4/5', { size: 32, w: 900, fill: T.benar, anchor: 'middle' }), teks(105, 505, 'benar', { size: 14, fill: '#FFFFFF', anchor: 'middle' }));
  el.push(kotak(190, 430, 130, 96, 24, '#FFFFFF', 'fill-opacity="0.1"'), teks(255, 475, '+60', { size: 32, w: 900, fill: T.cahaya, anchor: 'middle' }), teks(255, 505, 'XP', { size: 14, fill: '#FFFFFF', anchor: 'middle' }));
  el.push(aset('aset/lencana/lencana-teliti.svg', 130, 550, 100, 100));
  el.push(tombol(680, 'Lanjut'));
  return layar(T.malam, el);
}

// 06 kartu pulau (pengganti bottom sheet dua lesson + mastery)
function kartuPulau() {
  const el = [kotak(0, 0, W, H, 0, '#000000', 'fill-opacity="0.45"')];
  el.push(kotak(0, 330, W, 450, 32, T.krem));
  el.push(aset('aset/pulau-latihan.svg', 20, 350, 96, 96));
  el.push(teks(124, 392, 'Pulau Pelangi', { size: 26, w: 900 }), teks(124, 420, 'Penjumlahan sampai 20', { size: 15, w: 700, fill: T.pudar }));
  const langkah = [['Kenalan', 'selesai'], ['Latihan', 'sekarang'], ['Mercusuar', 'nanti']];
  langkah.forEach(([nama, st], i) => {
    const x = 60 + i * 120;
    if (i < 2) el.push(`<line x1="${x + 24}" y1="500" x2="${x + 96}" y2="500" stroke="${i === 0 ? T.cahaya : '#E4DFD3'}" stroke-width="6" stroke-linecap="round"/>`);
    el.push(`<circle cx="${x}" cy="500" r="24" fill="${st === 'selesai' ? T.cahaya : st === 'sekarang' ? T.muda : '#E4DFD3'}" ${st === 'sekarang' ? `stroke="${T.cahaya}" stroke-width="4"` : ''}/>`);
    el.push(teks(x, 508, st === 'selesai' ? '✓' : i + 1, { size: 22, w: 900, anchor: 'middle' }));
    el.push(teks(x, 546, nama, { size: 14, w: 800, anchor: 'middle', fill: st === 'nanti' ? T.pudar : T.tinta }));
  });
  el.push(teks(W / 2, 610, 'Satu tombol: sistem memilih langkah berikutnya', { size: 12, w: 600, fill: T.pudar, anchor: 'middle' }));
  el.push(tombol(668, 'MAIN', { sub: 'Latihan · 5 soal' }));
  return layar(T.malam, el);
}

// 07 progres anak
function progres() {
  const el = [aset('aset/ikon/ikon-kembali.svg', 16, 20, 44, 44), teks(W / 2, 50, 'Cahayaku', { size: 22, w: 900, anchor: 'middle' })];
  el.push(kotak(20, 84, W - 40, 120, 24, T.malam), aset('aset/api-streak-nyala.svg', 32, 96, 96, 96));
  el.push(teks(140, 140, '3 hari', { size: 32, w: 900, fill: '#FFFFFF' }), teks(140, 168, 'Level 2 · 20/100 XP', { size: 15, w: 700, fill: T.muda }));
  el.push(teks(20, 240, 'Lencana', { size: 20, w: 900 }));
  const daftar = ['pemula', 'rajin', 'teliti', 'terkunci', 'terkunci', 'terkunci', 'terkunci', 'terkunci'];
  daftar.forEach((id, i) => el.push(aset(`aset/lencana/lencana-${id}.svg`, 24 + (i % 4) * 80, 256 + Math.floor(i / 4) * 86, 72, 72)));
  el.push(kotak(20, 450, W - 40, 150, 24, '#FFFFFF'), teks(40, 486, 'Pulau terang', { size: 16, w: 800, fill: T.pudar }));
  for (let i = 0; i < 12; i++) el.push(`<circle cx="${52 + (i % 6) * 52}" cy="${525 + Math.floor(i / 6) * 48}" r="18" fill="${i < 2 ? T.cahaya : i < 5 ? T.muda : '#E4DFD3'}"/>`);
  // gerbang orang tua: ikon kecil, bukan tombol besar
  el.push(kotak(W / 2 - 90, 690, 180, 48, 24, '#FFFFFF', `stroke="#E4DFD3" stroke-width="2"`), teks(W / 2, 720, '🔒 Untuk orang tua', { size: 15, w: 800, fill: T.pudar, anchor: 'middle' }));
  return layar(T.krem, el);
}

// 08 ruang orang tua
function orangTua() {
  const el = [aset('aset/ikon/ikon-kembali.svg', 16, 20, 44, 44), teks(W / 2, 50, 'Ruang Orang Tua', { size: 20, w: 900, anchor: 'middle' })];
  el.push(teks(20, 100, 'Raka · kelompok kelas kecil', { size: 15, w: 700, fill: T.pudar }));
  const topik = [['T01 Bilangan sampai 20', 'Dikuasai', T.benar], ['T02 Nilai tempat', 'Dikuasai', T.benar], ['T03 Penjumlahan ≤ 20', 'Latihan · 80% benar', T.cahaya], ['T04 Pengurangan ≤ 20', 'Belum mulai', T.pudar], ['T05 Setengah, seperempat', 'Belum mulai', T.pudar], ['T06 Hitung sampai 1.000', 'Terkunci', '#B9BEDD']];
  topik.forEach(([n, s, c], i) => {
    const y = 120 + i * 64;
    el.push(kotak(20, y, W - 40, 56, 16, '#FFFFFF'), `<circle cx="44" cy="${y + 28}" r="8" fill="${c}"/>`);
    el.push(teks(62, y + 25, n, { size: 15, w: 800 }), teks(62, y + 45, s, { size: 13, w: 700, fill: T.pudar }));
  });
  el.push(teks(20, 530, 'Minggu ini: 4 hari aktif, 38 menit', { size: 15, w: 800 }));
  el.push(teks(20, 690, 'Pengaturan · Hapus data', { size: 14, w: 700, fill: T.pudar }));
  el.push(teks(20, 714, 'Pindah dari layar progres anak ke sini', { size: 12, w: 600, fill: T.pudar }));
  return layar(T.krem, el);
}

const daftar = { '01-peta': peta, '02-soal-kelas-kecil': soalKecil, '03-soal-kelas-besar': soalBesar, '04-umpan-balik-salah': umpanBalik, '05-hasil-sesi': hasil, '06-kartu-pulau': kartuPulau, '07-progres-anak': progres, '08-ruang-orang-tua': orangTua };
for (const [nama, fn] of Object.entries(daftar)) writeFileSync(new URL(`./${nama}.svg`, import.meta.url), fn());
console.log(Object.keys(daftar).length, 'mockup selesai');
