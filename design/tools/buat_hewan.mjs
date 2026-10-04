// Base plate hewan bergaya stiker (lihat page "animal ref" di Figma).
// Tiap hewan dipecah menjadi bagian (tulang rig). Bagian disimpan dengan kotak batasnya
// sendiri, sendi untuk diputar, dan isi SVG. Wajah tidak digambar di sini: wajah datang dari
// komponen wajah/<emosi>, ditempel di titik `wajah`.
// Jalankan dari folder design: node tools/buat_hewan.mjs
// Hasil: hewan/<id>.json (dibaca plugin Figma) dan hewan/<id>-pratinjau.svg (dengan wajah senang).

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';

export const GARIS = '#3D2B1F';
const g = (w = 5) => `stroke="${GARIS}" stroke-width="${w}" stroke-linejoin="round" stroke-linecap="round"`;

// Bagian: { nama, kotak: [x, y, w, h], sendi: [x, y], isi }
// Urutan array = urutan tumpukan (paling belakang dulu).
const HEWAN = {
  beruang: {
    nama: 'Beruang',
    ukuran: [220, 240],
    warna: { bulu: '#D9A066', terang: '#F5D9AE', telinga: '#EDB57A' },
    // posisi titik tengah antara dua mata dan skala wajah (wajah asli 120x120, mata di 60,54.5)
    wajah: { x: 110, y: 92, skala: 1.75 },
    bagian: (w) => [
      {
        nama: 'badan', kotak: [44, 118, 132, 110], sendi: [110, 222],
        isi: `<path d="M58 206 C46 158 70 124 110 124 C150 124 174 158 162 206 C148 226 72 226 58 206 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="110" cy="186" rx="30" ry="25" fill="${w.terang}"/>`,
      },
      {
        nama: 'kaki-kiri', kotak: [40, 190, 60, 42], sendi: [78, 200],
        isi: `<ellipse cx="70" cy="211" rx="26" ry="17" transform="rotate(-18 70 211)" fill="${w.bulu}" ${g()}/>
<ellipse cx="64" cy="212" rx="12" ry="9" transform="rotate(-18 64 212)" fill="${w.terang}"/>`,
      },
      {
        nama: 'kaki-kanan', kotak: [120, 190, 60, 42], sendi: [142, 200],
        isi: `<ellipse cx="150" cy="211" rx="26" ry="17" transform="rotate(18 150 211)" fill="${w.bulu}" ${g()}/>
<ellipse cx="156" cy="212" rx="12" ry="9" transform="rotate(18 156 212)" fill="${w.terang}"/>`,
      },
      {
        nama: 'lengan-kiri', kotak: [62, 146, 36, 60], sendi: [84, 152],
        isi: `<ellipse cx="80" cy="176" rx="13" ry="25" transform="rotate(10 80 176)" fill="${w.bulu}" ${g()}/>`,
      },
      {
        nama: 'lengan-kanan', kotak: [122, 146, 36, 60], sendi: [136, 152],
        isi: `<ellipse cx="140" cy="176" rx="13" ry="25" transform="rotate(-10 140 176)" fill="${w.bulu}" ${g()}/>`,
      },
      {
        nama: 'kepala', kotak: [34, 20, 152, 124], sendi: [110, 136],
        isi: `<circle cx="60" cy="46" r="21" fill="${w.bulu}" ${g()}/><circle cx="60" cy="47" r="10" fill="${w.telinga}"/>
<circle cx="160" cy="46" r="21" fill="${w.bulu}" ${g()}/><circle cx="160" cy="47" r="10" fill="${w.telinga}"/>
<path d="M110 30 C158 30 178 60 177 90 C176 122 148 140 110 140 C72 140 44 122 43 90 C42 60 62 30 110 30 Z" fill="${w.bulu}" ${g()}/>
<ellipse cx="110" cy="114" rx="25" ry="17" fill="${w.terang}"/>
<ellipse cx="110" cy="104" rx="6.5" ry="4.5" fill="${GARIS}"/>`,
      },
    ],
  },
};

const potong = (b) => `<svg xmlns="http://www.w3.org/2000/svg" width="${b.kotak[2]}" height="${b.kotak[3]}" viewBox="${b.kotak.join(' ')}">${b.isi}</svg>`;

mkdirSync('hewan', { recursive: true });
const wajahSenang = readFileSync('wajah/wajah-senang.svg', 'utf8').replace(/#2A2350/g, '#3D2B1F').replace(/<\/?svg[^>]*>/g, '');
for (const [id, h] of Object.entries(HEWAN)) {
  const bagian = h.bagian(h.warna);
  const data = { id, nama: h.nama, ukuran: h.ukuran, wajah: h.wajah, bagian: bagian.map((b) => ({ nama: b.nama, kotak: b.kotak, sendi: b.sendi, svg: potong(b) })) };
  writeFileSync(`hewan/${id}.json`, JSON.stringify(data, null, 1));
  // pratinjau: semua bagian + wajah senang di titik wajah
  const { x, y, skala } = h.wajah;
  const wajah = `<g transform="translate(${x - 60 * skala} ${y - 54.5 * skala}) scale(${skala})">${wajahSenang}</g>`;
  const [W, H] = h.ukuran;
  writeFileSync(`hewan/${id}-pratinjau.svg`, `<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}">${bagian.map((b) => b.isi).join('\n')}${wajah}</svg>`);
}
console.log('selesai', Object.keys(HEWAN).join(', '));
