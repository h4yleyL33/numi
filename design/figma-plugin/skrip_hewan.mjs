// Menyusun skrip use_figma untuk satu hewan: ID wajah + data hewan + bundel langkah/hewan.js.
// Pakai: node skrip_hewan.mjs <id> <y>  -> langkah/hewan-<id>.js
import { readFileSync, writeFileSync } from 'node:fs';
const [id, y] = process.argv.slice(2);
const WAJAH = { senang: '67:35', berpikir: '67:45', semangat: '67:55', sedih: '67:68', mengantuk: '67:80', bangga: '67:88', terkejut: '67:97', tertawa: '67:109', kagum: '67:118', tidur: '67:129', mengedip: '67:140' };
const data = JSON.parse(readFileSync(`../hewan/${id}.json`, 'utf8'));
const bundel = readFileSync('langkah/hewan.js', 'utf8');
const akhir = `\nconst hasil = await __m.utama(ID);\nconst set = await figma.getNodeByIdAsync(hasil.set);\nawait set.screenshot({ scale: 2.5 });\nconst fr = figma.currentPage.children.find((n) => n.name === 'hewan/${id}');\nawait fr.screenshot({ scale: 0.6 });\nreturn hasil;\n`;
const isi = `const ID = ${JSON.stringify({ wajah: WAJAH, data, y: +y })};\n` + bundel.replace(/\nreturn await __m\.utama\([^)]*\);\n?$/, '') + akhir;
writeFileSync(`langkah/hewan-${id}.js`, isi);
console.log(`langkah/hewan-${id}.js`, isi.length);
