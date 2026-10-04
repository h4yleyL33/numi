// Numi Builder: membuat page aset Numi di file Figma.
//   - mob base plate : 11 komponen wajah + 4 base plate mob dengan rig tulang dan 7 pose
//   - anim emote     : 11 emote Numi dan 11 emote mob, masing-masing 4 frame Smart Animate
//   - bg animasi     : latar peta 4 frame yang berputar, berisi mob yang saling berinteraksi
//   - item / <tema>  : satu page per tema barang esensial (design/barang/barang.json)
// Page yang sudah ada dengan nama sama dilewati, kecuali "timpa" dicentang dan page itu
// memang dibuat plugin ini. Page buatan tim (ref item, ref bg, ui, dll.) tidak pernah disentuh.

import barang from '../../barang/barang.json';
import { MASKOT, WAJAH, ASET } from './svg';

type Rgb = { r: number; g: number; b: number };
const hex = (h: string): Rgb => ({
  r: parseInt(h.slice(1, 3), 16) / 255,
  g: parseInt(h.slice(3, 5), 16) / 255,
  b: parseInt(h.slice(5, 7), 16) / 255,
});
const solid = (h: string, opacity = 1): SolidPaint => ({ type: 'SOLID', color: hex(h), opacity });
const gradien = (atas: string, bawah: string): GradientPaint => ({
  type: 'GRADIENT_LINEAR',
  gradientTransform: [[0, 1, 0], [-1, 0, 1]],
  gradientStops: [
    { position: 0, color: { ...hex(atas), a: 1 } },
    { position: 1, color: { ...hex(bawah), a: 1 } },
  ],
});

const W = {
  malam: '#1B1F4B', malamTerang: '#2B3480', laut: '#243B8F', lautDalam: '#16215E', cahaya: '#FFB547',
  muda: '#FFD98A', krem: '#FFF8EC', tinta: '#232347', pudar: '#6C6C8A', pasir: '#F2D48C', rumput: '#6CC47A',
};
const EMOSI = ['senang', 'berpikir', 'semangat', 'sedih', 'mengantuk', 'bangga', 'terkejut', 'tertawa', 'kagum', 'tidur', 'mengedip'];
const PENANDA = 'numi-builder';

// font

let F = { biasa: { family: 'Inter', style: 'Regular' }, tebal: { family: 'Inter', style: 'Bold' } } as { biasa: FontName; tebal: FontName };
async function siapkanFont() {
  try {
    const nunito = { biasa: { family: 'Nunito', style: 'Regular' }, tebal: { family: 'Nunito', style: 'ExtraBold' } };
    await Promise.all([figma.loadFontAsync(nunito.biasa), figma.loadFontAsync(nunito.tebal)]);
    F = nunito;
  } catch {
    await Promise.all([figma.loadFontAsync(F.biasa), figma.loadFontAsync(F.tebal)]);
  }
}
function teks(isi: string, size: number, opsi: { tebal?: boolean; warna?: string; lebar?: number } = {}) {
  const t = figma.createText();
  t.fontName = opsi.tebal ? F.tebal : F.biasa;
  t.characters = isi;
  t.fontSize = size;
  t.fills = [solid(opsi.warna ?? W.tinta)];
  if (opsi.lebar) {
    t.textAutoResize = 'HEIGHT';
    t.resize(opsi.lebar, t.height);
  }
  return t;
}

// geometri

type Mat = Transform;
const kali = (a: Mat, b: Mat): Mat => [
  [a[0][0] * b[0][0] + a[0][1] * b[1][0], a[0][0] * b[0][1] + a[0][1] * b[1][1], a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2]],
  [a[1][0] * b[0][0] + a[1][1] * b[1][0], a[1][0] * b[0][1] + a[1][1] * b[1][1], a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2]],
];
// Memutar node sejauh `derajat` (berlawanan jarum jam, sama dengan panel Figma) di sekitar titik
// (px, py) pada koordinat induknya. Dipakai untuk memutar tulang rig di sendinya.
function putar(node: SceneNode & LayoutMixin, derajat: number, px: number, py: number) {
  if (!derajat) return;
  const t = (derajat * Math.PI) / 180;
  const c = Math.cos(t), s = Math.sin(t);
  const r: Mat = kali(kali([[1, 0, px], [0, 1, py]], [[c, s, 0], [-s, c, 0]]), [[1, 0, -px], [0, 1, -py]]);
  node.relativeTransform = kali(r, node.relativeTransform);
}
const putarTengah = (n: SceneNode & LayoutMixin, d: number) => putar(n, d, n.x + n.width / 2, n.y + n.height / 2);

function bingkai(nama: string, w: number, h: number, isi?: Paint[]) {
  const f = figma.createFrame();
  f.name = nama;
  f.resize(w, h);
  f.fills = isi ?? [];
  f.clipsContent = false;
  return f;
}
function elips(nama: string, x: number, y: number, w: number, h: number, warna: string, opacity = 1) {
  const e = figma.createEllipse();
  e.name = nama;
  e.x = x; e.y = y;
  e.resize(w, h);
  e.fills = [solid(warna, opacity)];
  return e;
}
function svgNode(svg: string, nama: string) {
  const n = figma.createNodeFromSvg(svg);
  n.name = nama;
  n.fills = [];
  n.clipsContent = false;
  return n;
}

// halaman

const log: string[] = [];
function lapor(s: string) {
  log.push(s);
  figma.ui.postMessage({ log: s });
}

async function halaman(nama: string, timpa: boolean): Promise<PageNode | null> {
  const ada = figma.root.children.find((p) => p.name === nama);
  if (ada) {
    if (!timpa || ada.getPluginData(PENANDA) !== '1') {
      lapor(`• "${nama}" sudah ada, dilewati`);
      return null;
    }
    if (figma.currentPage === ada) await figma.setCurrentPageAsync(figma.root.children.find((p) => p !== ada)!);
    ada.remove();
  }
  const p = figma.createPage();
  p.name = nama;
  p.setPluginData(PENANDA, '1');
  await figma.setCurrentPageAsync(p);
  return p;
}

function judul(page: PageNode, isi: string, catatan: string, y = 0) {
  const t = teks(isi, 48, { tebal: true });
  t.y = y;
  const c = teks(catatan, 18, { warna: W.pudar, lebar: 1100 });
  c.y = y + 70;
  page.appendChild(t);
  page.appendChild(c);
  return y + 70 + c.height + 40;
}

// 1. wajah

const wajahKomp: Record<string, ComponentNode> = {};

function buatWajah(page: PageNode, y: number) {
  const t = teks('Wajah emosi', 28, { tebal: true });
  t.y = y;
  page.appendChild(t);
  EMOSI.forEach((e, i) => {
    const c = figma.createComponent();
    c.name = `wajah/${e}`;
    c.resize(120, 120);
    c.fills = [];
    c.clipsContent = false;
    const n = svgNode(WAJAH[e], 'garis');
    c.appendChild(n);
    n.x = 0; n.y = 0;
    c.description = `Wajah ${e}. Dipasang ke slot/wajah base plate lewat properti "emosi".`;
    c.x = i * 150;
    c.y = y + 50;
    page.appendChild(c);
    const label = teks(e, 14, { warna: W.pudar });
    label.x = c.x; label.y = y + 180;
    page.appendChild(label);
    wajahKomp[e] = c;
  });
  return y + 240;
}

// 2. base plate mob dengan rig

type Tipe = {
  id: string; nama: string; warna: string; perut: string;
  bw: number; bh: number; cy: number; lengan: number; kaki: number; tebal: number;
  sayap?: boolean; antena?: boolean; telinga?: boolean;
};
const TIPE: Tipe[] = [
  { id: 'bulat', nama: 'Bulat (anjing laut)', warna: '#6FB7FF', perut: '#DDEEFF', bw: 140, bh: 120, cy: 130, lengan: 40, kaki: 26, tebal: 22, telinga: true },
  { id: 'tinggi', nama: 'Tinggi (penjaga pulau)', warna: '#B98CFF', perut: '#EEE3FF', bw: 96, bh: 160, cy: 112, lengan: 52, kaki: 30, tebal: 20 },
  { id: 'mungil', nama: 'Mungil (kacang)', warna: '#FF9AA2', perut: '#FFE3E6', bw: 84, bh: 84, cy: 150, lengan: 28, kaki: 20, tebal: 16 },
  { id: 'bersayap', nama: 'Bersayap (sepupu Numi)', warna: '#8FE3B0', perut: '#E3FBEA', bw: 110, bh: 110, cy: 124, lengan: 34, kaki: 22, tebal: 18, sayap: true, antena: true },
];

// Sudut tulang per pose, dalam derajat (berlawanan jarum jam positif).
// L = lengan kiri, R = lengan kanan, KL/KR = kaki, B = badan, S = sayap, dy = geser seluruh badan.
type Pose = { L: number; R: number; KL: number; KR: number; B: number; S: number; dy: number };
const POSE: Record<string, Pose> = {
  idle: { L: -12, R: 12, KL: 0, KR: 0, B: 0, S: 0, dy: 0 },
  'lambai-a': { L: -12, R: 150, KL: 0, KR: 0, B: 4, S: 10, dy: 0 },
  'lambai-b': { L: -12, R: 112, KL: 0, KR: 0, B: 2, S: -6, dy: 0 },
  lompat: { L: -150, R: 150, KL: -28, KR: 28, B: 0, S: 24, dy: -28 },
  duduk: { L: -40, R: 40, KL: -80, KR: 80, B: 0, S: 0, dy: 18 },
  sedih: { L: -3, R: 3, KL: 0, KR: 0, B: -6, S: -16, dy: 4 },
  tunjuk: { L: -12, R: 88, KL: 0, KR: 0, B: 3, S: 0, dy: 0 },
};

type BasePlate = { set: ComponentSetNode; emosiProp: string };
const basePlate: Record<string, BasePlate> = {};

function tulang(nama: string, x: number, y: number, w: number, panjang: number, warna: string, induk: FrameNode) {
  // Frame tulang ditaruh di sendi (pusat atas). Bentuknya menggantung ke bawah dari sendi.
  const f = bingkai(`rig/${nama}`, w, panjang);
  f.x = x - w / 2; f.y = y;
  const e = elips('bentuk', 0, 0, w, panjang, warna);
  f.appendChild(e);
  f.setPluginData('sendi', JSON.stringify([x, y]));
  induk.appendChild(f);
  return f;
}

function rakit(t: Tipe, namaPose: string): ComponentNode {
  const p = POSE[namaPose];
  const c = figma.createComponent();
  c.name = `pose=${namaPose}`;
  c.resize(200, 220);
  c.fills = [];
  c.clipsContent = false;

  const root = bingkai('rig/root', 200, 220);
  c.appendChild(root);
  const cx = 100, cy = t.cy, atas = cy - t.bh / 2, bawah = cy + t.bh / 2;

  let sayapL: FrameNode | null = null, sayapR: FrameNode | null = null;
  if (t.sayap) {
    sayapL = tulang('sayap-kiri', cx - t.bw * 0.2, atas + t.bh * 0.15, 34, 60, '#CFF3FF', root);
    sayapR = tulang('sayap-kanan', cx + t.bw * 0.2, atas + t.bh * 0.15, 34, 60, '#CFF3FF', root);
    for (const s of [sayapL, sayapR]) {
      const e = s.children[0] as EllipseNode;
      e.opacity = 0.85;
      e.strokes = [solid('#FFFFFF')];
      e.strokeWeight = 2;
    }
  }
  const kakiL = tulang('kaki-kiri', cx - t.bw * 0.22, bawah - 8, t.tebal, t.kaki, t.warna, root);
  const kakiR = tulang('kaki-kanan', cx + t.bw * 0.22, bawah - 8, t.tebal, t.kaki, t.warna, root);

  const badan = bingkai('rig/badan', t.bw, t.bh);
  badan.x = cx - t.bw / 2; badan.y = atas;
  root.appendChild(badan);
  if (t.telinga) {
    badan.appendChild(elips('telinga-kiri', t.bw * 0.12, -8, 28, 28, t.warna));
    badan.appendChild(elips('telinga-kanan', t.bw * 0.88 - 28, -8, 28, 28, t.warna));
  }
  if (t.antena) {
    for (const [nama, x] of [['antena-kiri', t.bw * 0.3], ['antena-kanan', t.bw * 0.7]] as const) {
      const a = bingkai(`rig/${nama}`, 6, 30);
      a.x = x - 3; a.y = -26;
      const batang = figma.createRectangle();
      batang.name = 'batang'; batang.resize(4, 28); batang.x = 1; batang.fills = [solid(W.tinta)];
      a.appendChild(batang);
      a.appendChild(elips('cahaya', -5, -8, 16, 16, W.muda));
      badan.appendChild(a);
    }
  }
  badan.appendChild(elips('badan', 0, 0, t.bw, t.bh, t.warna));
  badan.appendChild(elips('perut', t.bw * 0.22, t.bh * 0.5, t.bw * 0.56, t.bh * 0.42, t.perut, 0.9));

  const wajah = wajahKomp.senang.createInstance();
  wajah.name = 'slot/wajah';
  const ukuran = Math.min(t.bw, t.bh) * 1.35;
  wajah.rescale(ukuran / 120);
  wajah.x = (t.bw - wajah.width) / 2;
  wajah.y = t.bh * 0.42 - wajah.height / 2;
  badan.appendChild(wajah);

  const bahuY = atas + t.bh * 0.45;
  const lenganL = tulang('lengan-kiri', cx - t.bw / 2 + t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna, root);
  const lenganR = tulang('lengan-kanan', cx + t.bw / 2 - t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna, root);

  // Pose: putar tiap tulang di sendinya, lalu geser seluruh rig.
  const sendi = (f: FrameNode) => JSON.parse(f.getPluginData('sendi')) as [number, number];
  putar(lenganL, p.L, ...sendi(lenganL));
  putar(lenganR, p.R, ...sendi(lenganR));
  putar(kakiL, p.KL, ...sendi(kakiL));
  putar(kakiR, p.KR, ...sendi(kakiR));
  if (sayapL && sayapR) {
    putar(sayapL, 35 + p.S, ...sendi(sayapL));
    putar(sayapR, -35 - p.S, ...sendi(sayapR));
  }
  putar(badan, p.B, cx, bawah);
  root.y = p.dy;
  return c;
}

function buatBasePlate(page: PageNode, y: number) {
  const t = teks('Base plate mob', 28, { tebal: true });
  t.y = y;
  page.appendChild(t);
  const cat = teks(
    'Setiap base plate adalah component set dengan properti "pose" (variant) dan "emosi" (instance swap ke wajah/*). ' +
    'Tulang: rig/root > rig/badan (badan, perut, slot/wajah, antena), rig/lengan-*, rig/kaki-*, rig/sayap-*. ' +
    'Semua variant memakai nama layer yang sama, jadi ganti pose dengan Smart Animate = animasi rig. ' +
    'Sendi tiap tulang ada di tengah atas frame-nya; saat menganimasikan manual, putar dari titik itu.',
    16, { warna: W.pudar, lebar: 1400 });
  cat.y = y + 44;
  page.appendChild(cat);
  let yy = y + 44 + cat.height + 30;

  for (const tipe of TIPE) {
    const varian = Object.keys(POSE).map((n) => rakit(tipe, n));
    const set = figma.combineAsVariants(varian, page);
    set.name = `mob/${tipe.id}`;
    set.description = `Base plate mob ${tipe.nama}. Pilih pose dan emosi dari panel properti.`;
    set.layoutMode = 'HORIZONTAL';
    set.itemSpacing = 40;
    set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 30;
    set.primaryAxisSizingMode = 'AUTO';
    set.counterAxisSizingMode = 'AUTO';
    set.fills = [solid('#F4F1EA')];
    set.cornerRadius = 24;
    set.x = 0; set.y = yy;

    const emosiProp = set.addComponentProperty('emosi', 'INSTANCE_SWAP', wajahKomp.senang.id, {
      preferredValues: EMOSI.map((e) => ({ type: 'COMPONENT' as const, key: wajahKomp[e].key })),
    });
    for (const v of set.children as ComponentNode[]) {
      const slot = v.findOne((n) => n.name === 'slot/wajah') as InstanceNode;
      slot.componentPropertyReferences = { mainComponent: emosiProp };
    }
    basePlate[tipe.id] = { set, emosiProp };

    const label = teks(tipe.nama, 18, { tebal: true });
    label.x = set.width + 30; label.y = yy + 20;
    page.appendChild(label);
    yy += set.height + 50;
  }

  // Contoh pemakaian: satu base plate dengan semua emosi.
  const contoh = teks('Contoh: mob/bulat dengan 11 emosi', 20, { tebal: true });
  contoh.y = yy;
  page.appendChild(contoh);
  EMOSI.forEach((e, i) => {
    const inst = mob('bulat', 'idle', e);
    inst.x = i * 210; inst.y = yy + 40;
    page.appendChild(inst);
  });
  return yy + 300;
}

function mob(tipe: string, pose: string, emosi: string) {
  const bp = basePlate[tipe];
  const v = bp.set.children.find((c) => c.name === `pose=${pose}`) as ComponentNode;
  const inst = v.createInstance();
  inst.setProperties({ [bp.emosiProp]: wajahKomp[emosi].id });
  inst.name = `mob-${tipe}`;
  return inst;
}

// 3. animasi emote

type Kunci = { dy: number; s: number; rot: number; wajah?: string; pose?: string };
const k = (dy: number, s: number, rot: number, extra: Partial<Kunci> = {}): Kunci => ({ dy, s, rot, ...extra });
const EMOTE: Record<string, { durasi: number; kunci: Kunci[]; pose: string[] }> = {
  senang: { durasi: 0.35, kunci: [k(0, 1, 0), k(-10, 1.04, 0), k(0, 1, 0), k(-6, 1.02, 0)], pose: ['idle', 'lambai-a', 'lambai-b', 'lambai-a'] },
  berpikir: { durasi: 0.5, kunci: [k(0, 1, 0), k(0, 1, 8), k(-4, 1, 10), k(0, 1, 4)], pose: ['idle', 'tunjuk', 'tunjuk', 'idle'] },
  semangat: { durasi: 0.3, kunci: [k(0, 1, 0), k(6, 0.95, 0), k(-28, 1.05, -6), k(0, 1, 0)], pose: ['idle', 'duduk', 'lompat', 'idle'] },
  sedih: { durasi: 0.7, kunci: [k(0, 1, 0), k(6, 0.97, -4), k(8, 0.96, -6), k(6, 0.97, -4)], pose: ['idle', 'sedih', 'sedih', 'sedih'] },
  mengantuk: { durasi: 0.8, kunci: [k(0, 1, 0), k(4, 0.99, -8), k(6, 0.98, -12), k(2, 1, -4)], pose: ['idle', 'sedih', 'sedih', 'idle'] },
  bangga: { durasi: 0.4, kunci: [k(0, 1, 0), k(-6, 1.08, 0), k(-8, 1.12, 0), k(-4, 1.06, 0)], pose: ['idle', 'lompat', 'lompat', 'idle'] },
  terkejut: { durasi: 0.25, kunci: [k(0, 1, 0), k(-20, 1.1, 0), k(-14, 1.06, 0), k(0, 1, 0)], pose: ['idle', 'lompat', 'idle', 'idle'] },
  tertawa: { durasi: 0.2, kunci: [k(0, 1, 0), k(-4, 1.02, 8), k(-4, 1.02, -8), k(-2, 1.01, 4)], pose: ['idle', 'lambai-a', 'idle', 'lambai-b'] },
  kagum: { durasi: 0.45, kunci: [k(0, 1, 0), k(-12, 1.06, 0), k(-16, 1.08, 0), k(-8, 1.04, 0)], pose: ['idle', 'lompat', 'lompat', 'idle'] },
  tidur: { durasi: 0.9, kunci: [k(0, 1, 0), k(2, 1.03, 0), k(4, 1.05, 0), k(2, 1.03, 0)], pose: ['duduk', 'duduk', 'duduk', 'duduk'] },
  mengedip: { durasi: 0.3, kunci: [k(0, 1, 0, { wajah: 'senang' }), k(0, 1, 6), k(0, 1, 6), k(0, 1, 0, { wajah: 'senang' })], pose: ['idle', 'tunjuk', 'tunjuk', 'idle'] },
};

// Menyambung frame variant menjadi loop: tiap frame pindah ke frame berikutnya setelah jeda.
async function sambungLoop(frames: ComponentNode[], durasi: number) {
  for (let i = 0; i < frames.length; i++) {
    await frames[i].setReactionsAsync([{
      trigger: { type: 'AFTER_TIMEOUT', timeout: 0.01 },
      actions: [{
        type: 'NODE',
        destinationId: frames[(i + 1) % frames.length].id,
        navigation: 'CHANGE_TO',
        transition: { type: 'SMART_ANIMATE', easing: { type: 'EASE_IN_AND_OUT' }, duration: durasi },
        preserveScrollPosition: false,
      }],
    }]);
  }
}

function aturVariantSet(set: ComponentSetNode, x: number, y: number) {
  set.layoutMode = 'HORIZONTAL';
  set.itemSpacing = 24;
  set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 24;
  set.primaryAxisSizingMode = 'AUTO';
  set.counterAxisSizingMode = 'AUTO';
  set.fills = [solid(W.malam)];
  set.cornerRadius = 24;
  set.x = x; set.y = y;
}

async function buatEmote(page: PageNode, y: number) {
  let yy = y;
  for (const e of EMOSI) {
    const resep = EMOTE[e];
    // Numi
    const frames = resep.kunci.map((kc, i) => {
      const c = figma.createComponent();
      c.name = `frame=${i + 1}`;
      c.resize(260, 260);
      c.fills = [];
      c.clipsContent = false;
      const n = svgNode(MASKOT[kc.wajah ?? e], 'numi');
      c.appendChild(n);
      n.rescale(kc.s);
      n.x = (260 - n.width) / 2;
      n.y = (260 - n.height) / 2 + kc.dy;
      putarTengah(n, kc.rot);
      return c;
    });
    const set = figma.combineAsVariants(frames, page);
    set.name = `emote/numi/${e}`;
    set.description = `Emote ${e}. Pasang instance frame=1 lalu Play: berputar ${resep.kunci.length} frame dengan Smart Animate.`;
    aturVariantSet(set, 0, yy);
    await sambungLoop(frames, resep.durasi);

    // Mob: pose rig + wajah emosi
    const framesMob = resep.kunci.map((kc, i) => {
      const c = figma.createComponent();
      c.name = `frame=${i + 1}`;
      c.resize(240, 260);
      c.fills = [];
      c.clipsContent = false;
      const m = mob('bulat', resep.pose[i], kc.wajah ?? e);
      c.appendChild(m);
      m.x = 20; m.y = 20 + kc.dy;
      putarTengah(m, kc.rot / 2);
      return c;
    });
    const setMob = figma.combineAsVariants(framesMob, page);
    setMob.name = `emote/mob/${e}`;
    aturVariantSet(setMob, set.width + 60, yy);
    await sambungLoop(framesMob, resep.durasi);

    const label = teks(e, 22, { tebal: true });
    label.x = set.width + setMob.width + 100; label.y = yy + 30;
    page.appendChild(label);
    yy += Math.max(set.height, setMob.height) + 40;
  }
  return yy;
}

// 4. latar animasi

const pp = [0, 1, 2, 1]; // ping-pong, supaya frame 4 kembali mulus ke frame 1

function ombakSvg(w: number, warna: string) {
  let d = `M0 20`;
  for (let x = 0; x < w; x += 40) d += ` Q${x + 10} 6 ${x + 20} 20 T${x + 40} 20`;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="40" viewBox="0 0 ${w} 40"><path d="${d} V40 H0 Z" fill="${warna}"/></svg>`;
}
const PULAU_SAMPING = `<svg xmlns="http://www.w3.org/2000/svg" width="180" height="120" viewBox="0 0 180 120">
<ellipse cx="90" cy="96" rx="88" ry="24" fill="#B9A675"/><ellipse cx="90" cy="88" rx="80" ry="26" fill="${W.pasir}"/>
<ellipse cx="90" cy="78" rx="56" ry="16" fill="${W.rumput}"/>
<path d="M120 80 Q124 46 116 20" stroke="#8B6B4A" stroke-width="7" fill="none" stroke-linecap="round"/>
<path d="M116 20 Q96 8 80 22 M116 20 Q132 4 150 16 M116 20 Q106 30 98 44 M116 20 Q134 28 140 42" stroke="#4E9F5D" stroke-width="9" fill="none" stroke-linecap="round"/></svg>`;
const PERAHU = ASET.perahu;
const IKAN = ASET.ikan;

function kunciBg(i: number) {
  const f = figma.createComponent();
  f.name = `frame=${i + 1}`;
  f.resize(360, 780);
  f.clipsContent = true;
  f.fills = [gradien(W.malam, W.malamTerang)];

  // bintang berkelip
  for (let b = 0; b < 18; b++) {
    const r = b % 3 ? 3 : 5;
    const s = elips(`bintang-${b + 1}`, (b * 97) % 340 + 8, (b * 53) % 360 + 20, r, r, '#FFFFFF', 0.25 + 0.75 * (((b + i) % 4) / 3));
    f.appendChild(s);
  }
  const halo = elips('bulan-cahaya', 250, 60, 90, 90, W.muda, 0.15 + 0.05 * pp[i]);
  const bulan = elips('bulan', 270, 80, 50, 50, '#FFF1C1');
  f.appendChild(halo); f.appendChild(bulan);
  for (const [nama, x0, y0, arah] of [['awan-1', 20, 150, 1], ['awan-2', 200, 230, -1]] as const) {
    const a = figma.createFrame();
    a.name = nama; a.fills = []; a.clipsContent = false; a.resize(120, 40);
    a.appendChild(elips('a', 0, 12, 60, 28, '#B9BEDD', 0.35));
    a.appendChild(elips('b', 30, 0, 60, 40, '#B9BEDD', 0.35));
    a.appendChild(elips('c', 64, 12, 56, 28, '#B9BEDD', 0.35));
    a.x = x0 + arah * pp[i] * 14; a.y = y0;
    f.appendChild(a);
  }

  // Numi terbang menyeberang
  const numi = svgNode(MASKOT[i === 2 ? 'tertawa' : 'senang'], 'numi');
  numi.rescale(0.42);
  numi.x = [40, 130, 220, 130][i]; numi.y = [300, 270, 300, 330][i];
  putarTengah(numi, [6, 0, -6, 0][i]);
  f.appendChild(numi);

  // kunang-kunang kecil
  for (let b = 0; b < 6; b++) {
    const g = elips(`kunang-${b + 1}`, (b * 61 + pp[i] * 8) % 340, 380 + ((b * 37 + pp[i] * 10) % 80), 8, 8, W.muda, 0.4 + 0.15 * ((b + i) % 3));
    f.appendChild(g);
  }

  const laut = figma.createRectangle();
  laut.name = 'laut'; laut.resize(360, 330); laut.y = 450;
  laut.fills = [gradien(W.laut, W.lautDalam)];
  f.appendChild(laut);

  // pulau kiri: mob bulat duduk memancing
  const pulauA = svgNode(PULAU_SAMPING, 'pulau-kiri');
  pulauA.x = -10; pulauA.y = 420;
  f.appendChild(pulauA);
  const pemancing = mob('bulat', 'duduk', ['senang', 'senang', 'terkejut', 'tertawa'][i]);
  pemancing.name = 'mob-pemancing';
  pemancing.rescale(0.45);
  pemancing.x = 30; pemancing.y = 392;
  f.appendChild(pemancing);
  const tali = figma.createLine();
  tali.name = 'tali-pancing'; tali.resize(70, 0); tali.x = 118; tali.y = 425;
  tali.rotation = -[40, 50, 70, 40][i];
  tali.strokes = [solid('#FFFFFF', 0.6)]; tali.strokeWeight = 2;
  f.appendChild(tali);
  const ikan = svgNode(IKAN, 'ikan');
  ikan.rescale(0.5);
  ikan.x = [150, 150, 128, 160][i]; ikan.y = [520, 470, 420, 520][i];
  ikan.opacity = i === 0 ? 0 : 1;
  putarTengah(ikan, [0, 40, 0, -40][i]);
  f.appendChild(ikan);

  // pulau kanan: mob tinggi melambai ke perahu, mob mungil melompat
  const pulauB = svgNode(PULAU_SAMPING, 'pulau-kanan');
  pulauB.x = 200; pulauB.y = 380;
  f.appendChild(pulauB);
  const penjaga = mob('tinggi', ['idle', 'lambai-a', 'lambai-b', 'lambai-a'][i], i === 0 ? 'senang' : 'tertawa');
  penjaga.name = 'mob-penjaga';
  penjaga.rescale(0.45);
  penjaga.x = 238; penjaga.y = 360;
  f.appendChild(penjaga);
  const mungil = mob('mungil', i % 2 ? 'lompat' : 'idle', i % 2 ? 'kagum' : 'senang');
  mungil.name = 'mob-mungil';
  mungil.rescale(0.4);
  mungil.x = 280; mungil.y = 380 - (i % 2 ? 14 : 0);
  f.appendChild(mungil);

  // perahu dengan dua penumpang yang membalas lambaian
  const ayun = [0, 5, 0, -5][i];
  const perahu = svgNode(PERAHU, 'perahu');
  perahu.rescale(0.9);
  perahu.x = 96 + pp[i] * 6; perahu.y = 560 + ayun;
  putarTengah(perahu, [0, 3, 0, -3][i]);
  const p1 = mob('bersayap', ['lambai-a', 'lambai-b', 'lambai-a', 'lambai-b'][i], 'senang');
  p1.name = 'mob-penumpang-1'; p1.rescale(0.36);
  p1.x = 100 + pp[i] * 6; p1.y = 572 + ayun;
  const p2 = mob('bulat', i === 2 ? 'tunjuk' : 'idle', i === 2 ? 'terkejut' : 'senang');
  p2.name = 'mob-penumpang-2'; p2.rescale(0.32);
  p2.x = 168 + pp[i] * 6; p2.y = 580 + ayun;
  f.appendChild(perahu); f.appendChild(p1); f.appendChild(p2);

  // ombak bergeser
  [['ombak-1', 600, '#2F4FB0', 1], ['ombak-2', 660, '#2A45A0', -1], ['ombak-3', 720, '#22388A', 1]].forEach(([nama, yy, warna, arah]) => {
    const o = svgNode(ombakSvg(440, warna as string), nama as string);
    o.x = -40 + (arah as number) * pp[i] * 10; o.y = yy as number;
    f.appendChild(o);
  });
  return f;
}

async function buatBg(page: PageNode, y: number) {
  const frames = [0, 1, 2, 3].map(kunciBg);
  const set = figma.combineAsVariants(frames, page);
  set.name = 'bg/peta-malam';
  set.description = 'Latar peta animasi. Pakai instance frame=1 di layar, lalu Play: berputar 4 frame (1,2 detik per frame). ' +
    'Interaksi: pemancing menangkap ikan dan kaget, penjaga pulau melambai ke perahu, penumpang membalas, si mungil melompat, Numi terbang.';
  aturVariantSet(set, 0, y);
  set.fills = [solid('#F4F1EA')];
  await sambungLoop(frames, 1.2);

  // Contoh layar peta memakai latar animasi.
  const layar = bingkai('contoh layar peta', 360, 780, [solid(W.malam)]);
  layar.clipsContent = true;
  layar.x = set.width + 80; layar.y = y + 24;
  const bg = frames[0].createInstance();
  bg.name = 'bg';
  layar.appendChild(bg);
  const tombol = figma.createFrame();
  tombol.name = 'tombol MAIN';
  tombol.resize(320, 72); tombol.x = 20; tombol.y = 680; tombol.cornerRadius = 36;
  tombol.fills = [solid(W.cahaya)];
  tombol.layoutMode = 'VERTICAL';
  tombol.primaryAxisAlignItems = 'CENTER';
  tombol.counterAxisAlignItems = 'CENTER';
  tombol.appendChild(teks('MAIN', 24, { tebal: true }));
  layar.appendChild(tombol);
  page.appendChild(layar);
  const cat = teks('Layar peta dengan latar animasi. Pulau skill map nanti ditaruh di atas lapisan ini.', 16, { warna: W.pudar, lebar: 360 });
  cat.x = layar.x; cat.y = layar.y + 800;
  page.appendChild(cat);
}

// 5. barang esensial

async function buatItem(tema: (typeof barang.tema)[number], timpa: boolean) {
  const page = await halaman(`item / ${tema.nama.toLowerCase()}`, timpa);
  if (!page) return;
  let y = judul(page, tema.nama, `${tema.barang.length} barang yang perlu dikenal anak. Kotak ilustrasi masih kosong: gambar mengikuti gaya di page "ref item", ` +
    'lalu tiap kartu bisa dipakai sebagai komponen soal (hitung benda, pecahan, soal cerita). Label "kecil" = dikenalkan kelas 1-3, "besar" = kelas 4-6.');
  const grid = figma.createFrame();
  grid.name = 'daftar';
  grid.layoutMode = 'HORIZONTAL';
  grid.layoutWrap = 'WRAP';
  grid.itemSpacing = 24;
  grid.counterAxisSpacing = 24;
  grid.primaryAxisSizingMode = 'FIXED';
  grid.counterAxisSizingMode = 'AUTO';
  grid.resize(1416, 100);
  grid.fills = [];
  grid.y = y;
  page.appendChild(grid);

  for (const b of tema.barang) {
    const c = figma.createComponent();
    c.name = `item/${tema.id}/${b.id}`;
    c.description = `${b.nama} (${b.en}). Kelas ${b.kelas}. Dipakai untuk: ${b.pakai}.`;
    c.layoutMode = 'VERTICAL';
    c.itemSpacing = 8;
    c.paddingLeft = c.paddingRight = c.paddingTop = c.paddingBottom = 16;
    c.primaryAxisSizingMode = 'AUTO';
    c.counterAxisSizingMode = 'FIXED';
    c.resize(204, 100);
    c.cornerRadius = 20;
    c.fills = [solid('#FFFFFF')];
    c.strokes = [solid('#E4DFD3')];
    c.strokeWeight = 2;

    const ilustrasi = figma.createFrame();
    ilustrasi.name = 'ilustrasi';
    ilustrasi.resize(172, 140);
    ilustrasi.cornerRadius = 16;
    ilustrasi.fills = [solid(tema.warna, 0.12)];
    ilustrasi.strokes = [solid(tema.warna, 0.6)];
    ilustrasi.dashPattern = [6, 6];
    ilustrasi.layoutMode = 'VERTICAL';
    ilustrasi.primaryAxisAlignItems = 'CENTER';
    ilustrasi.counterAxisAlignItems = 'CENTER';
    const svg = ASET[b.id];
    if (svg) {
      const n = svgNode(svg, 'gambar');
      n.rescale(110 / Math.max(n.width, n.height));
      ilustrasi.appendChild(n);
    } else {
      ilustrasi.appendChild(teks(b.nama.charAt(0), 56, { tebal: true, warna: tema.warna }));
    }
    c.appendChild(ilustrasi);
    c.appendChild(teks(b.nama, 20, { tebal: true }));
    c.appendChild(teks(b.en, 14, { warna: W.pudar }));
    const chip = teks(`kelas ${b.kelas} · ${b.pakai}`, 12, { warna: W.pudar, lebar: 172 });
    c.appendChild(chip);
    grid.appendChild(c);
  }
  lapor(`✓ item / ${tema.nama.toLowerCase()}: ${tema.barang.length} kartu`);
}

// jalankan

async function jalankan(pilih: Record<string, boolean>, timpa: boolean) {
  await siapkanFont();
  const butuhMob = pilih.mob || pilih.emote || pilih.bg;
  if (butuhMob) {
    // Emote dan latar memakai base plate, jadi page mob dibuat dulu (atau dipakai ulang bila ada).
    let page = await halaman('mob base plate', timpa);
    if (page) {
      let y = judul(page, 'Mob base plate', 'Badan polos tanpa wajah. Emosi dipasang sebagai wajah lewat properti "emosi", pose lewat properti "pose".');
      y = buatWajah(page, y);
      buatBasePlate(page, y + 40);
      lapor('✓ mob base plate: 11 wajah, 4 base plate × 7 pose');
    } else {
      const ada = figma.root.children.find((p) => p.name === 'mob base plate')!;
      await ada.loadAsync();
      for (const e of EMOSI) {
        const c = ada.findOne((n) => n.type === 'COMPONENT' && n.name === `wajah/${e}`) as ComponentNode | null;
        if (c) wajahKomp[e] = c;
      }
      for (const t of TIPE) {
        const set = ada.findOne((n) => n.type === 'COMPONENT_SET' && n.name === `mob/${t.id}`) as ComponentSetNode | null;
        const prop = set && Object.keys(set.componentPropertyDefinitions).find((p) => p.startsWith('emosi'));
        if (set && prop) basePlate[t.id] = { set, emosiProp: prop };
      }
      if (Object.keys(basePlate).length < TIPE.length || Object.keys(wajahKomp).length < EMOSI.length) {
        lapor('✗ page "mob base plate" sudah ada tetapi isinya berubah. Centang "timpa" atau hapus page itu dulu.');
        return;
      }
    }
  }
  if (pilih.emote) {
    const page = await halaman('anim emote', timpa);
    if (page) {
      const y = judul(page, 'Animasi emote', 'Kiri: Numi. Kanan: mob/bulat dengan pose rig dan wajah emosi. Tiap baris component set 4 frame yang saling tersambung ' +
        '(After delay → Change to, Smart Animate). Taruh instance frame=1 di sebuah frame, lalu tekan Play untuk melihat animasinya.');
      await buatEmote(page, y);
      lapor('✓ anim emote: 11 emote Numi + 11 emote mob');
    }
  }
  if (pilih.bg) {
    const page = await halaman('bg animasi', timpa);
    if (page) {
      const y = judul(page, 'Latar animasi', 'Pengganti latar peta yang polos. Empat frame berputar dengan Smart Animate; semua karakter memakai base plate mob, jadi wajah dan pose bisa diganti dari panel properti.');
      await buatBg(page, y);
      lapor('✓ bg animasi: 4 frame + contoh layar peta');
    }
  }
  if (pilih.item) for (const t of barang.tema) await buatItem(t, timpa);
}

figma.showUI(__html__, { width: 360, height: 420 });
figma.ui.onmessage = async (m: { pilih: Record<string, boolean>; timpa: boolean }) => {
  try {
    await jalankan(m.pilih, m.timpa);
    lapor('Selesai.');
    figma.notify('Numi Builder selesai');
  } catch (e) {
    lapor(`✗ Gagal: ${(e as Error).message}`);
    console.error(e);
  }
};
