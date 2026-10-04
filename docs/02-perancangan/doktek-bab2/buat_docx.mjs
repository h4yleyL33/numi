// Mengubah bab2.md menjadi Bab-2-Perancangan-Numi.docx untuk ditempel ke doktek di Google Docs.
// Hanya mendukung bagian Markdown yang dipakai bab2.md: judul #..###, paragraf, daftar "-",
// daftar bernomor, tabel, gambar, **tebal**, dan `kode`.
// Jalankan: npm install && npm run build

import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import {
  AlignmentType, BorderStyle, Document, HeadingLevel, ImageRun, LevelFormat, Packer, Paragraph,
  ShadingType, Table, TableCell, TableRow, TextRun, WidthType,
} from 'docx';

const SUMBER = new URL('./bab2.md', import.meta.url);
const folder = dirname(SUMBER.pathname.replace(/^\/(\w:)/, '$1'));
const LEBAR_MAKS = 600; // px, kira-kira lebar isi halaman A4 dengan margin 2,5 cm
const TINGGI_MAKS = 820;

function teksInline(s, opsi = {}) {
  const runs = [];
  for (const bagian of s.split(/(\*\*[^*]+\*\*|`[^`]+`)/)) {
    if (!bagian) continue;
    if (bagian.startsWith('**')) runs.push(new TextRun({ ...opsi, text: bagian.slice(2, -2), bold: true }));
    else if (bagian.startsWith('`')) runs.push(new TextRun({ ...opsi, text: bagian.slice(1, -1), font: 'Consolas' }));
    else runs.push(new TextRun({ ...opsi, text: bagian }));
  }
  return runs;
}

function ukuranPng(buf) {
  return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
}

function gambar(alt, path) {
  const data = readFileSync(resolve(folder, path));
  let { w, h } = ukuranPng(data);
  const skala = Math.min(1, LEBAR_MAKS / w, TINGGI_MAKS / h);
  w = Math.round(w * skala); h = Math.round(h * skala);
  return [
    new Paragraph({ alignment: AlignmentType.CENTER, children: [new ImageRun({ type: 'png', data, transformation: { width: w, height: h } })] }),
    new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 }, children: [new TextRun({ text: `Gambar ${++nomorGambar}. ${alt}`, italics: true, size: 20 })] }),
  ];
}
let nomorGambar = 0;

const garis = { style: BorderStyle.SINGLE, size: 4, color: '999999' };
function tabel(baris) {
  const sel = baris.map((b) => b.replace(/^\||\|$/g, '').split('|').map((c) => c.trim()));
  const [kepala, , ...isi] = sel;
  const kolom = kepala.length;
  const buatBaris = (cells, judul) => new TableRow({
    tableHeader: judul,
    children: cells.map((c) => new TableCell({
      shading: judul ? { type: ShadingType.CLEAR, fill: 'D9E2F3', color: 'auto' } : undefined,
      children: [new Paragraph({ children: teksInline(c, { size: 20, bold: judul || undefined }) })],
    })),
  });
  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    borders: { top: garis, bottom: garis, left: garis, right: garis, insideHorizontal: garis, insideVertical: garis },
    rows: [buatBaris(kepala, true), ...isi.map((c) => buatBaris(c.concat(Array(kolom - c.length).fill('')).slice(0, kolom), false))],
  });
}

const blok = [];
const baris = readFileSync(SUMBER, 'utf8').split(/\r?\n/);
let nomorDaftar = 0;
for (let i = 0; i < baris.length; i++) {
  const b = baris[i];
  if (!b.trim()) continue;
  let m;
  if ((m = b.match(/^(#{1,3}) (.*)/))) {
    const level = [HeadingLevel.HEADING_1, HeadingLevel.HEADING_2, HeadingLevel.HEADING_3][m[1].length - 1];
    blok.push(new Paragraph({ heading: level, children: [new TextRun(m[2])] }));
  } else if ((m = b.match(/^!\[(.*)\]\((.*)\)$/))) {
    blok.push(...gambar(m[1], m[2]));
  } else if (b.startsWith('|')) {
    const t = [];
    while (i < baris.length && baris[i].startsWith('|')) t.push(baris[i++]);
    i--;
    blok.push(tabel(t), new Paragraph({ text: '' }));
  } else if ((m = b.match(/^- (.*)/))) {
    blok.push(new Paragraph({ bullet: { level: 0 }, children: teksInline(m[1]) }));
  } else if ((m = b.match(/^\d+\. (.*)/))) {
    blok.push(new Paragraph({ numbering: { reference: 'nomor', level: 0, instance: nomorDaftar }, children: teksInline(m[1]) }));
    if (!/^\d+\. /.test(baris[i + 1] ?? '')) nomorDaftar++;
  } else {
    blok.push(new Paragraph({ alignment: AlignmentType.JUSTIFIED, spacing: { after: 120 }, children: teksInline(b) }));
  }
}

const doc = new Document({
  styles: { default: { document: { run: { font: 'Times New Roman', size: 24 } } } },
  numbering: { config: [{ reference: 'nomor', levels: [{ level: 0, format: LevelFormat.DECIMAL, text: '%1.', alignment: AlignmentType.START }] }] },
  sections: [{ properties: { page: { margin: { top: 1418, bottom: 1418, left: 1418, right: 1418 } } }, children: blok }],
});
writeFileSync(new URL('./Bab-2-Perancangan-Numi.docx', import.meta.url), await Packer.toBuffer(doc));
console.log(`selesai: ${blok.length} blok, ${nomorGambar} gambar`);
