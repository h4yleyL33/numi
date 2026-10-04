// Membuat aset SVG Numi dengan ukuran dan warna yang sama dengan CustomPainter
// di aplikasi (numi_mascot.dart, skill_map_screen.dart, pulau_hias.dart).
// Jalankan dari folder design: node tools/buat_svg.mjs

import { mkdirSync, writeFileSync } from 'node:fs';

const TINTA = '#2A2350';
const CAHAYA = '#FFB547';
const CAHAYA_MUDA = '#FFD98A';
const f = (n) => Number(n.toFixed(1));
const svg = (w, h, isi) => `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}">\n${isi.join('\n')}\n</svg>\n`;

function bintangPath(cx, cy, luar, dalam, sudut = 5) {
  const t = [];
  for (let i = 0; i < sudut * 2; i++) {
    const r = i % 2 ? dalam : luar;
    const a = -Math.PI / 2 + i * Math.PI / sudut;
    t.push(`${f(cx + r * Math.cos(a))} ${f(cy + r * Math.sin(a))}`);
  }
  return `M${t.join(' L')} Z`;
}

// maskot

function maskot(ekspresi) {
  const s = 240;
  const cx = s * 0.5;
  const cy = s * 0.56;
  const r = s * 0.3;
  const redup = ekspresi === 'mengantuk' ? 0.45 : ekspresi === 'tidur' ? 0.3 : 1;
  const el = [];

  el.push(`<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="${CAHAYA}" stop-opacity="${0.45 * redup}"/><stop offset="1" stop-color="${CAHAYA}" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="${redup}"/><stop offset="0.45" stop-color="${CAHAYA_MUDA}" stop-opacity="${0.9 * redup}"/><stop offset="1" stop-color="${CAHAYA}" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>`);
  el.push(`<circle cx="${cx}" cy="${cy}" r="${f(r * 1.75)}" fill="url(#halo)"/>`);

  // sayap
  for (const arah of [-1, 1]) {
    const px = cx + arah * r * 0.55;
    const py = cy - r * 0.55;
    const derajat = f(arah * 0.6 * 180 / Math.PI);
    el.push(`<ellipse cx="${f(px + arah * r * 0.35)}" cy="${f(py - r * 0.2)}" rx="${f(r * 0.45)}" ry="${f(r * 0.275)}" transform="rotate(${derajat} ${f(px)} ${f(py)})" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="${f(r * 0.04)}"/>`);
  }

  // antena
  for (const arah of [-1, 1]) {
    const x0 = cx + arah * r * 0.3, y0 = cy - r * 0.9;
    const kx = cx + arah * r * 0.2, ky = cy - r * 1.4;
    const x1 = cx + arah * r * 0.65, y1 = cy - r * 1.55;
    el.push(`<path d="M${f(x0)} ${f(y0)} Q${f(kx)} ${f(ky)} ${f(x1)} ${f(y1)}" fill="none" stroke="${TINTA}" stroke-width="${f(r * 0.07)}" stroke-linecap="round"/>`);
    el.push(`<circle cx="${f(x1)}" cy="${f(y1)}" r="${f(r * 0.2)}" fill="${CAHAYA}" fill-opacity="${0.35 * redup}"/>`);
    el.push(`<circle cx="${f(x1)}" cy="${f(y1)}" r="${f(r * 0.11)}" fill="${CAHAYA_MUDA}"/>`);
  }

  el.push(`<circle cx="${cx}" cy="${f(cy + r * 0.95)}" r="${f(r * 0.42)}" fill="url(#ekor)"/>`);
  el.push(`<circle cx="${cx}" cy="${f(cy)}" r="${f(r)}" fill="url(#badan)"/>`);
  el.push(`<ellipse cx="${cx}" cy="${f(cy + r * 0.35)}" rx="${f(r * 0.55)}" ry="${f(r * 0.4)}" fill="#FFF1C1" fill-opacity="0.9"/>`);

  // mata
  const my = cy - r * 0.15;
  const jarak = r * 0.38;
  const garis = `fill="none" stroke="${TINTA}" stroke-width="${f(r * 0.08)}" stroke-linecap="round"`;
  for (const arah of [-1, 1]) {
    const mx = cx + arah * jarak;
    if (ekspresi === 'kagum') {
      el.push(`<path d="${bintangPath(mx, my, r * 0.19, r * 0.08)}" fill="${TINTA}"/>`);
      el.push(`<circle cx="${f(mx + r * 0.04)}" cy="${f(my - r * 0.05)}" r="${f(r * 0.035)}" fill="#FFFFFF"/>`);
    } else if (ekspresi === 'terkejut') {
      el.push(`<circle cx="${f(mx)}" cy="${f(my)}" r="${f(r * 0.17)}" fill="#FFFFFF" stroke="${TINTA}" stroke-width="${f(r * 0.05)}"/>`);
      el.push(`<circle cx="${f(mx)}" cy="${f(my)}" r="${f(r * 0.08)}" fill="${TINTA}"/>`);
    } else if (ekspresi === 'tertawa' || (ekspresi === 'mengedip' && arah === 1)) {
      // Mata tertutup melengkung ke atas (^ ^).
      el.push(`<path d="M${f(mx - r * 0.15)} ${f(my + r * 0.04)} Q${f(mx)} ${f(my - r * 0.2)} ${f(mx + r * 0.15)} ${f(my + r * 0.04)}" ${garis}/>`);
    } else if (ekspresi === 'mengantuk' || ekspresi === 'tidur') {
      el.push(`<path d="M${f(mx - r * 0.15)} ${f(my)} A${f(r * 0.15)} ${f(r * 0.09)} 0 0 0 ${f(mx + r * 0.15)} ${f(my)}" ${garis}/>`);
    } else if (ekspresi === 'bangga') {
      el.push(`<path d="M${f(mx - r * 0.15)} ${f(my)} A${f(r * 0.15)} ${f(r * 0.13)} 0 0 1 ${f(mx + r * 0.15)} ${f(my)}" ${garis}/>`);
    } else {
      el.push(`<ellipse cx="${f(mx)}" cy="${f(my)}" rx="${f(r * 0.13)}" ry="${f(r * 0.17)}" fill="${TINTA}"/>`);
      el.push(`<circle cx="${f(mx + r * 0.05)}" cy="${f(my - r * 0.07)}" r="${f(r * 0.05)}" fill="#FFFFFF"/>`);
    }
  }

  // alis
  if (ekspresi === 'sedih') {
    for (const arah of [-1, 1]) {
      const dx = cx + arah * jarak * 0.55, lx = cx + arah * jarak * 1.35, y = my - r * 0.3;
      el.push(`<path d="M${f(dx)} ${f(y - r * 0.1)} L${f(lx)} ${f(y + r * 0.1)}" ${garis}/>`);
    }
  } else if (ekspresi === 'terkejut') {
    for (const arah of [-1, 1]) {
      const ax = cx + arah * jarak, ay = my - r * 0.42;
      el.push(`<path d="M${f(ax - r * 0.14)} ${f(ay + r * 0.03)} Q${f(ax)} ${f(ay - r * 0.08)} ${f(ax + r * 0.14)} ${f(ay + r * 0.03)}" ${garis}/>`);
    }
  } else if (ekspresi === 'semangat') {
    // Alis melengkung naik supaya terlihat bersemangat, bukan marah.
    for (const arah of [-1, 1]) {
      const ax = cx + arah * jarak, ay = my - r * 0.36;
      el.push(`<path d="M${f(ax - r * 0.16)} ${f(ay)} A${f(r * 0.16)} ${f(r * 0.09)} 0 0 1 ${f(ax + r * 0.16)} ${f(ay)}" ${garis}/>`);
    }
  }

  // pipi
  for (const arah of [-1, 1]) {
    el.push(`<circle cx="${f(cx + arah * r * 0.62)}" cy="${f(cy + r * 0.12)}" r="${f(r * 0.12)}" fill="#FF9AA2" fill-opacity="0.55"/>`);
  }

  // mulut
  const mux = cx, muy = cy + r * 0.22;
  const titik = (rx, ry, sudut, ox = 0, oy = 0) => [f(mux + ox + rx * Math.cos(sudut)), f(muy + oy + ry * Math.sin(sudut))];
  switch (ekspresi) {
    case 'terkejut':
      el.push(`<ellipse cx="${f(mux)}" cy="${f(muy + r * 0.08)}" rx="${f(r * 0.1)}" ry="${f(r * 0.13)}" fill="${TINTA}"/>`);
      break;
    case 'kagum':
    case 'tertawa':
      el.push(`<path d="M${f(mux - r * 0.26)} ${f(muy - r * 0.06)} Q${f(mux)} ${f(muy + r * 0.45)} ${f(mux + r * 0.26)} ${f(muy - r * 0.06)} Z" fill="${TINTA}"/>`);
      el.push(`<ellipse cx="${f(mux)}" cy="${f(muy + r * 0.17)}" rx="${f(r * 0.11)}" ry="${f(r * 0.06)}" fill="#FF7A85"/>`);
      break;
    case 'tidur':
      el.push(`<path d="M${f(mux - r * 0.08)} ${f(muy + r * 0.06)} Q${f(mux)} ${f(muy + r * 0.12)} ${f(mux + r * 0.08)} ${f(muy + r * 0.06)}" ${garis}/>`);
      // zzz di kanan atas kepala
      [[0.72, -0.62, 0.16], [0.95, -0.9, 0.12], [1.12, -1.12, 0.09]].forEach(([dx, dy, z]) => {
        const x = cx + r * dx, y = cy + r * dy, w = r * z;
        el.push(`<path d="M${f(x)} ${f(y)} H${f(x + w)} L${f(x)} ${f(y + w)} H${f(x + w)}" ${garis}/>`);
      });
      break;
    case 'mengedip':
    case 'senang': {
      const [ax, ay] = titik(r * 0.21, r * 0.15, 0.15);
      const [bx, by] = titik(r * 0.21, r * 0.15, Math.PI - 0.15);
      el.push(`<path d="M${ax} ${ay} A${f(r * 0.21)} ${f(r * 0.15)} 0 0 1 ${bx} ${by}" ${garis}/>`);
      break;
    }
    case 'bangga':
    case 'semangat':
      el.push(`<path d="M${f(mux - r * 0.24)} ${f(muy - r * 0.04)} Q${f(mux)} ${f(muy + r * 0.38)} ${f(mux + r * 0.24)} ${f(muy - r * 0.04)} Z" fill="${TINTA}"/>`);
      el.push(`<circle cx="${f(mux)}" cy="${f(muy + r * 0.13)}" r="${f(r * 0.07)}" fill="#FF7A85"/>`);
      break;
    case 'berpikir':
      el.push(`<circle cx="${f(mux + r * 0.1)}" cy="${f(muy + r * 0.02)}" r="${f(r * 0.07)}" fill="${TINTA}"/>`);
      break;
    case 'sedih': {
      const [ax, ay] = titik(r * 0.18, r * 0.12, Math.PI + 0.2, 0, r * 0.12);
      const [bx, by] = titik(r * 0.18, r * 0.12, 2 * Math.PI - 0.2, 0, r * 0.12);
      el.push(`<path d="M${ax} ${ay} A${f(r * 0.18)} ${f(r * 0.12)} 0 0 1 ${bx} ${by}" ${garis}/>`);
      break;
    }
    case 'mengantuk':
      el.push(`<ellipse cx="${f(mux)}" cy="${f(muy + r * 0.03)}" rx="${f(r * 0.08)}" ry="${f(r * 0.1)}" fill="${TINTA}"/>`);
      break;
  }

  return svg(s, s, el);
}

// pulau skill map

function pulau(status) {
  const s = 120;
  const c = s / 2;
  const r = s * 0.36;
  const warna = {
    terkunci: ['#3D4170', '#30345E', 0],
    belum: ['#CDB98F', '#5E9A6A', 0.15],
    latihan: ['#E9D19A', '#63B071', 0.35],
    dikuasai: ['#F7DE9C', '#6CC47A', 0.75],
  }[status];
  const [pasir, rumput, cahaya] = warna;
  const gelap = { '#3D4170': '#2E3154', '#CDB98F': '#9A8B6B', '#E9D19A': '#AF9D73', '#F7DE9C': '#B9A675' }[pasir];
  const el = [`<defs><radialGradient id="g"><stop offset="0" stop-color="${CAHAYA}" stop-opacity="${cahaya}"/><stop offset="1" stop-color="${CAHAYA}" stop-opacity="0"/></radialGradient></defs>`];
  if (cahaya > 0) el.push(`<circle cx="${c}" cy="${c}" r="${f(r * 1.5)}" fill="url(#g)"/>`);
  el.push(`<ellipse cx="${c}" cy="${f(c + r * 0.25)}" rx="${f(r * 1.25)}" ry="${f(r * 0.65)}" fill="#FFFFFF" fill-opacity="0.07"/>`);
  el.push(`<circle cx="${c}" cy="${f(c + r * 0.1)}" r="${f(r)}" fill="${gelap}"/>`);
  el.push(`<circle cx="${c}" cy="${c}" r="${f(r)}" fill="${pasir}"/>`);
  el.push(`<circle cx="${c}" cy="${f(c - r * 0.08)}" r="${f(r * 0.72)}" fill="${rumput}"/>`);
  if (status === 'latihan' || status === 'dikuasai') {
    const rr = r * 1.18;
    el.push(`<circle cx="${c}" cy="${c}" r="${f(rr)}" fill="none" stroke="#FFFFFF" stroke-opacity="0.15" stroke-width="6"/>`);
    if (status === 'dikuasai') {
      el.push(`<circle cx="${c}" cy="${c}" r="${f(rr)}" fill="none" stroke="${CAHAYA}" stroke-width="6"/>`);
    } else {
      // Sepertiga lingkaran: satu dari dua lesson selesai ditambah mastery test.
      const a = -Math.PI / 2 + 2 * Math.PI / 3;
      el.push(`<path d="M${c} ${f(c - rr)} A${f(rr)} ${f(rr)} 0 0 1 ${f(c + rr * Math.cos(a))} ${f(c + rr * Math.sin(a))}" fill="none" stroke="${CAHAYA}" stroke-width="6" stroke-linecap="round"/>`);
    }
  }
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${s}" height="${s}" viewBox="0 0 ${s} ${s}">\n${el.join('\n')}\n</svg>\n`;
}

// mercusuar

function mercusuar(menyala) {
  const w = 160, h = 140;
  const dx = w / 2, dy = h * 0.82;
  const ax = w / 2, ay = h * 0.3;
  const lx = ax, ly = ay - h * 0.05;
  const el = [];
  el.push(`<ellipse cx="${dx}" cy="${f(dy)}" rx="${f(w * 0.45)}" ry="${f(h * 0.13)}" fill="${menyala ? '#F2D48C' : '#4A4F7A'}"/>`);
  el.push(`<ellipse cx="${dx}" cy="${f(dy - h * 0.03)}" rx="${f(w * 0.3)}" ry="${f(h * 0.07)}" fill="${menyala ? '#6CC47A' : '#3A3F66'}"/>`);
  el.push(`<path d="M${f(dx - w * 0.08)} ${f(dy - h * 0.05)} L${f(ax - w * 0.05)} ${f(ay)} L${f(ax + w * 0.05)} ${f(ay)} L${f(dx + w * 0.08)} ${f(dy - h * 0.05)} Z" fill="${menyala ? '#FFFFFF' : '#8B8FB3'}"/>`);
  for (const i of [1, 2]) {
    const y = ay + (dy - ay) * i / 3.2;
    el.push(`<rect x="${f(dx - w * 0.065)}" y="${f(y - h * 0.025)}" width="${f(w * 0.13)}" height="${f(h * 0.05)}" fill="${menyala ? '#FF6B6B' : '#6B6F99'}"/>`);
  }
  if (menyala) {
    el.push(`<path d="M${lx} ${f(ly)} L${f(lx + w * Math.cos(-0.18))} ${f(ly + w * 0.35 * Math.sin(-0.18))} L${f(lx + w * Math.cos(0.18))} ${f(ly + w * 0.35 * Math.sin(0.18))} Z" fill="${CAHAYA_MUDA}" fill-opacity="0.35"/>`);
    el.push(`<circle cx="${lx}" cy="${f(ly)}" r="${f(w * 0.14)}" fill="${CAHAYA}" fill-opacity="0.4"/>`);
  }
  el.push(`<circle cx="${lx}" cy="${f(ly)}" r="${f(w * 0.06)}" fill="${menyala ? CAHAYA_MUDA : '#5A5E88'}"/>`);
  el.push(`<path d="M${f(lx - w * 0.08)} ${f(ly - h * 0.03)} L${lx} ${f(ly - h * 0.13)} L${f(lx + w * 0.08)} ${f(ly - h * 0.03)} Z" fill="${menyala ? '#FF6B6B' : '#6B6F99'}"/>`);
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}">\n${el.join('\n')}\n</svg>\n`;
}

// api streak
function apiStreak(menyala) {
  const [luar, dalam] = menyala ? ['#FF8A3D', '#FFD166'] : ['#8B8FB3', '#C9CBE0'];
  return svg(96, 96, [
    menyala ? `<circle cx="48" cy="58" r="40" fill="${CAHAYA}" fill-opacity="0.25"/>` : '',
    `<path d="M48 8 C62 28 78 40 78 60 A30 30 0 0 1 18 60 C18 46 28 38 32 26 C36 36 40 40 44 40 C42 28 44 18 48 8 Z" fill="${luar}"/>`,
    `<path d="M48 40 C56 52 64 58 64 68 A16 16 0 0 1 32 68 C32 60 38 56 40 50 C43 56 46 56 48 40 Z" fill="${dalam}"/>`,
  ]);
}

// bintang XP
function bintangXp() {
  return svg(96, 96, [
    `<circle cx="48" cy="50" r="40" fill="${CAHAYA}" fill-opacity="0.25"/>`,
    `<path d="${bintangPath(48, 50, 38, 17)}" fill="#FFD166" stroke="#F4A340" stroke-width="4" stroke-linejoin="round"/>`,
    `<text x="48" y="58" text-anchor="middle" font-family="Nunito, Arial, sans-serif" font-weight="900" font-size="20" fill="${TINTA}">XP</text>`,
  ]);
}

// kabut lupa
function kabut() {
  const el = [];
  [[60, 70, 48], [120, 56, 60], [190, 72, 50], [250, 62, 40]].forEach(([x, y, r]) =>
    el.push(`<circle cx="${x}" cy="${y}" r="${r}" fill="#B9BEDD" fill-opacity="0.45"/>`));
  el.push(`<rect x="10" y="70" width="280" height="40" rx="20" fill="#B9BEDD" fill-opacity="0.45"/>`);
  return svg(300, 120, el);
}

// perahu Numi
function perahu() {
  return svg(160, 140, [
    `<path d="M80 18 L80 92" stroke="${TINTA}" stroke-width="5" stroke-linecap="round"/>`,
    `<path d="M84 22 L132 86 L84 86 Z" fill="#FFFFFF"/>`,
    `<path d="M76 34 L36 86 L76 86 Z" fill="${CAHAYA_MUDA}"/>`,
    `<path d="M20 94 H140 L124 118 H36 Z" fill="#E07A5F"/>`,
    `<path d="M28 104 H132" stroke="#FFFFFF" stroke-opacity="0.5" stroke-width="4"/>`,
    `<path d="M4 124 Q24 114 44 124 T84 124 T124 124 T164 124" fill="none" stroke="#4FC3F7" stroke-width="5" stroke-linecap="round"/>`,
  ]);
}

// lencana: bingkai bundar dengan simbol sederhana
const SIMBOL = {
  pemula: (c) => `<path d="${bintangPath(c, c, 24, 10)}" fill="#FFFFFF"/>`,
  rajin: (c) => `<path d="M${c} ${c - 26} C${c + 12} ${c - 10} ${c + 22} ${c} ${c + 22} ${c + 10} A22 22 0 0 1 ${c - 22} ${c + 10} C${c - 22} ${c} ${c - 14} ${c - 6} ${c - 10} ${c - 14} C${c - 6} ${c - 6} ${c - 2} ${c - 6} ${c} ${c - 26} Z" fill="#FFFFFF"/>`,
  cepat: (c) => `<path d="M${c + 6} ${c - 28} L${c - 16} ${c + 4} H${c - 2} L${c - 8} ${c + 28} L${c + 16} ${c - 6} H${c + 2} Z" fill="#FFFFFF"/>`,
  juara: (c) => `<path d="M${c - 18} ${c - 22} H${c + 18} V${c - 6} A18 18 0 0 1 ${c - 18} ${c - 6} Z M${c - 4} ${c + 10} H${c + 4} V${c + 18} H${c + 12} V${c + 24} H${c - 12} V${c + 18} H${c - 4} Z" fill="#FFFFFF"/>`,
  teliti: (c) => [26, 18, 10].map((r, i) => `<circle cx="${c}" cy="${c}" r="${r}" fill="${i % 2 ? WARNA_LENCANA.teliti : '#FFFFFF'}"/>`).join(''),
  tekun: (c) => `<path d="M${c + 6} ${c - 24} A24 24 0 1 0 ${c + 22} ${c + 12} A18 18 0 1 1 ${c + 6} ${c - 24} Z" fill="#FFFFFF"/>`,
  penjelajah: (c) => `<circle cx="${c}" cy="${c}" r="24" fill="none" stroke="#FFFFFF" stroke-width="4"/><path d="M${c} ${c - 18} L${c + 7} ${c} L${c} ${c + 18} L${c - 7} ${c} Z" fill="#FFFFFF"/>`,
  bintang: (c) => `<path d="${bintangPath(c, c, 28, 12)}" fill="#FFFFFF"/><circle cx="${c + 22}" cy="${c - 20}" r="4" fill="#FFFFFF"/><circle cx="${c - 24}" cy="${c + 18}" r="3" fill="#FFFFFF"/>`,
};
const WARNA_LENCANA = {
  pemula: '#FFB547', rajin: '#FF8A3D', cepat: '#4FC3F7', juara: '#F4A340',
  teliti: '#2EBD8E', tekun: '#7C5CFF', penjelajah: '#243B8F', bintang: '#FF6B9A',
};
function lencana(id, terkunci = false) {
  const c = 60;
  const warna = terkunci ? '#B9BEDD' : WARNA_LENCANA[id];
  return svg(120, 120, [
    `<circle cx="${c}" cy="${c + 3}" r="52" fill="${TINTA}" fill-opacity="0.15"/>`,
    `<circle cx="${c}" cy="${c}" r="52" fill="${warna}"/>`,
    `<circle cx="${c}" cy="${c}" r="44" fill="none" stroke="#FFFFFF" stroke-opacity="0.45" stroke-width="3" stroke-dasharray="6 6"/>`,
    terkunci
      ? `<rect x="${c - 16}" y="${c - 4}" width="32" height="26" rx="5" fill="#FFFFFF"/><path d="M${c - 10} ${c - 4} V${c - 12} A10 10 0 0 1 ${c + 10} ${c - 12} V${c - 4}" fill="none" stroke="#FFFFFF" stroke-width="5"/>`
      : SIMBOL[id](c),
  ]);
}

// ikon tombol besar untuk anak (suara, kembali, main, petunjuk)
function ikon(nama) {
  const isi = {
    suara: `<path d="M26 42 H38 L54 28 V68 L38 54 H26 Z" fill="${TINTA}"/><path d="M62 38 Q70 48 62 58 M68 30 Q82 48 68 66" fill="none" stroke="${TINTA}" stroke-width="5" stroke-linecap="round"/>`,
    kembali: `<path d="M56 26 L34 48 L56 70" fill="none" stroke="${TINTA}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>`,
    main: `<path d="M38 28 L70 48 L38 68 Z" fill="${TINTA}" stroke="${TINTA}" stroke-width="4" stroke-linejoin="round"/>`,
    petunjuk: `<path d="M48 22 A18 18 0 0 1 58 55 V62 H38 V55 A18 18 0 0 1 48 22 Z" fill="${CAHAYA}"/><rect x="39" y="66" width="18" height="6" rx="3" fill="${TINTA}"/>`,
  }[nama];
  return svg(96, 96, [`<circle cx="48" cy="48" r="44" fill="#FFFFFF"/>`, `<circle cx="48" cy="48" r="44" fill="none" stroke="${TINTA}" stroke-opacity="0.12" stroke-width="4"/>`, isi]);
}

// benda hitung untuk soal kelas kecil
function benda(nama) {
  const isi = {
    apel: [`<circle cx="36" cy="44" r="24" fill="#FF6B6B"/>`, `<circle cx="28" cy="36" r="6" fill="#FFFFFF" fill-opacity="0.5"/>`, `<path d="M36 20 Q38 12 44 10" fill="none" stroke="#6B4F3A" stroke-width="4" stroke-linecap="round"/>`, `<ellipse cx="46" cy="16" rx="8" ry="4" transform="rotate(-25 46 16)" fill="#6CC47A"/>`],
    kerang: [`<path d="M36 14 L60 54 Q36 66 12 54 Z" fill="#FF9AA2"/>`, ...[-14, -6, 2, 10].map((d) => `<path d="M36 14 L${36 + d * 1.4} 58" stroke="#FFFFFF" stroke-width="2"/>`)],
    ikan: [`<ellipse cx="32" cy="36" rx="22" ry="14" fill="${CAHAYA}"/>`, `<path d="M52 36 L66 24 L66 48 Z" fill="${CAHAYA}"/>`, `<circle cx="22" cy="32" r="3" fill="${TINTA}"/>`],
    kue: [`<circle cx="36" cy="36" r="28" fill="#F7DE9C"/>`, `<path d="M36 36 L36 8 A28 28 0 0 1 64 36 Z" fill="#E07A5F"/>`, `<path d="M8 36 H64 M36 8 V64" stroke="#FFFFFF" stroke-width="3"/>`, `<circle cx="36" cy="36" r="28" fill="none" stroke="${TINTA}" stroke-width="3"/>`],
  }[nama];
  return svg(72, 72, isi);
}

mkdirSync('maskot', { recursive: true });
mkdirSync('aset/lencana', { recursive: true });
mkdirSync('aset/ikon', { recursive: true });
mkdirSync('aset/benda', { recursive: true });
for (const id of Object.keys(SIMBOL)) writeFileSync(`aset/lencana/lencana-${id}.svg`, lencana(id));
writeFileSync('aset/lencana/lencana-terkunci.svg', lencana('pemula', true));
for (const n of ['suara', 'kembali', 'main', 'petunjuk']) writeFileSync(`aset/ikon/ikon-${n}.svg`, ikon(n));
for (const n of ['apel', 'kerang', 'ikan', 'kue']) writeFileSync(`aset/benda/${n}.svg`, benda(n));
writeFileSync('aset/api-streak-nyala.svg', apiStreak(true));
writeFileSync('aset/api-streak-redup.svg', apiStreak(false));
writeFileSync('aset/bintang-xp.svg', bintangXp());
writeFileSync('aset/kabut-lupa.svg', kabut());
writeFileSync('aset/perahu.svg', perahu());
for (const e of ['senang', 'berpikir', 'semangat', 'sedih', 'mengantuk', 'bangga', 'terkejut', 'tertawa', 'kagum', 'tidur', 'mengedip']) {
  writeFileSync(`maskot/numi-${e}.svg`, maskot(e));
}
for (const st of ['terkunci', 'belum', 'latihan', 'dikuasai']) {
  writeFileSync(`aset/pulau-${st}.svg`, pulau(st));
}
writeFileSync('aset/mercusuar-padam.svg', mercusuar(false));
writeFileSync('aset/mercusuar-menyala.svg', mercusuar(true));
console.log('selesai');
