// Membundel tiap src/langkah/*.ts menjadi skrip untuk konektor Figma (use_figma):
// kode dibungkus fungsi async, jadi diakhiri `return await __m.utama(ID)`.
// ID hasil langkah sebelumnya disisipkan sebagai `const ID = {...};` di awal skrip.
import { build } from 'esbuild';
import { readdirSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';

mkdirSync('langkah', { recursive: true });
for (const f of readdirSync('src/langkah')) {
  const nama = f.replace('.ts', '');
  const out = `langkah/${nama}.js`;
  await build({ entryPoints: [`src/langkah/${f}`], bundle: true, format: 'iife', globalName: '__m', minify: true, loader: { '.svg': 'text' }, target: 'es2017', outfile: out });
  const isi = readFileSync(out, 'utf8') + `\nreturn await __m.utama(typeof ID === 'undefined' ? undefined : ID);\n`;
  writeFileSync(out, isi);
  console.log(nama, isi.length);
}
