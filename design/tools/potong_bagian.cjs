// Membantu memindahkan gambar jiplakan (SVG dengan komentar <!-- nama -->) ke entri buat_hewan.mjs.
// ambil(svg, 'nama komentar') -> isi elemen setelah komentar itu sampai komentar berikutnya.
// warnai(isi, {hex: 'kunci'}) -> ganti warna hex dengan ${w.kunci}.
const fs = require('fs');
exports.baca = (p) => fs.readFileSync(p, 'utf8');
exports.ambil = (sv, nama) => {
  const tanda = `<!-- ${nama} -->`;
  const a = sv.indexOf(tanda);
  if (a < 0) throw new Error('tidak ada bagian: ' + nama);
  const b1 = sv.indexOf('<!--', a + tanda.length), b2 = sv.indexOf('</g>', a);
  const b = b1 < 0 ? b2 : Math.min(b1, b2);
  return sv.slice(a + tanda.length, b).trim();
};
exports.warnai = (isi, peta) => Object.entries(peta).reduce((s, [hex, k]) => s.split(hex).join('${w.' + k + '}'), isi);
exports.sisipkan = (entri) => {
  let s = fs.readFileSync('tools/buat_hewan.mjs', 'utf8');
  if (!s.includes('\n};\n\nconst f = ')) throw new Error('penanda');
  s = s.replace('\n};\n\nconst f = ', `${entri}\n\nconst f = `);
  fs.writeFileSync('tools/buat_hewan.mjs', s);
};
