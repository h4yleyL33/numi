// Pembantu bersama untuk semua langkah Numi Builder. Gaya mengikuti page "ref item" dan
// "ref bg" di Figma: stiker kawaii pastel, garis cokelat, bingkai putih, dan wajah emosi.
// Tidak memakai setPluginData/showUI supaya bisa dijalankan juga lewat konektor Figma (use_figma).

export type Rgb = { r: number; g: number; b: number };
export const hex = (h: string): Rgb => ({
  r: parseInt(h.slice(1, 3), 16) / 255,
  g: parseInt(h.slice(3, 5), 16) / 255,
  b: parseInt(h.slice(5, 7), 16) / 255,
});
export const solid = (h: string, opacity = 1): SolidPaint => ({ type: 'SOLID', color: hex(h), opacity });
export const gradien = (atas: string, bawah: string): GradientPaint => ({
  type: 'GRADIENT_LINEAR',
  gradientTransform: [[0, 1, 0], [-1, 0, 1]],
  gradientStops: [
    { position: 0, color: { ...hex(atas), a: 1 } },
    { position: 1, color: { ...hex(bawah), a: 1 } },
  ],
});

export const W = {
  garis: '#6B4A3A', // garis tepi cokelat seperti ref item
  tinta: '#4A3328', // warna mata dan mulut
  krem: '#FFF8EC', kertas: '#FFFDF7', pudar: '#8A7A6E',
  langit: '#BFE6F5', langitBawah: '#EAF7F0', bukit: '#CDEBB0', rumput: '#A8D98A', rumputTua: '#7FBF6A',
  danau: '#8FD0F0', danauTua: '#6BBCE6', pasir: '#F6E3B4', cahaya: '#FFB547', muda: '#FFE08A',
};
export const EMOSI = ['senang', 'berpikir', 'semangat', 'sedih', 'mengantuk', 'bangga', 'terkejut', 'tertawa', 'kagum', 'tidur', 'mengedip'];

// font

export let F: { biasa: FontName; tebal: FontName } = { biasa: { family: 'Inter', style: 'Regular' }, tebal: { family: 'Inter', style: 'Bold' } };
export async function siapkanFont() {
  try {
    const nunito = { biasa: { family: 'Nunito', style: 'Regular' }, tebal: { family: 'Nunito', style: 'ExtraBold' } };
    await Promise.all([figma.loadFontAsync(nunito.biasa), figma.loadFontAsync(nunito.tebal)]);
    F = nunito;
  } catch {
    await Promise.all([figma.loadFontAsync(F.biasa), figma.loadFontAsync(F.tebal)]);
  }
}
export function teks(isi: string, size: number, opsi: { tebal?: boolean; warna?: string; lebar?: number } = {}) {
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

const kali = (a: Transform, b: Transform): Transform => [
  [a[0][0] * b[0][0] + a[0][1] * b[1][0], a[0][0] * b[0][1] + a[0][1] * b[1][1], a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2]],
  [a[1][0] * b[0][0] + a[1][1] * b[1][0], a[1][0] * b[0][1] + a[1][1] * b[1][1], a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2]],
];
// Memutar node sejauh `derajat` (berlawanan jarum jam, sama dengan panel Figma) di sekitar
// titik (px, py) pada koordinat induknya. Dipakai untuk memutar tulang rig di sendinya.
export function putar(node: SceneNode & LayoutMixin, derajat: number, px: number, py: number) {
  if (!derajat) return;
  const t = (derajat * Math.PI) / 180;
  const c = Math.cos(t), s = Math.sin(t);
  const r: Transform = kali(kali([[1, 0, px], [0, 1, py]], [[c, s, 0], [-s, c, 0]]), [[1, 0, -px], [0, 1, -py]]);
  node.relativeTransform = kali(r, node.relativeTransform);
}
export const putarTengah = (n: SceneNode & LayoutMixin, d: number) => putar(n, d, n.x + n.width / 2, n.y + n.height / 2);

export function bingkai(nama: string, w: number, h: number, isi: Paint[] = []) {
  const f = figma.createFrame();
  f.name = nama;
  f.resize(w, h);
  f.fills = isi;
  f.clipsContent = false;
  return f;
}
export function elips(nama: string, x: number, y: number, w: number, h: number, warna: string, opsi: { opacity?: number; garis?: number } = {}) {
  const e = figma.createEllipse();
  e.name = nama;
  e.x = x; e.y = y;
  e.resize(w, h);
  e.fills = [solid(warna, opsi.opacity ?? 1)];
  if (opsi.garis) {
    e.strokes = [solid(W.garis)];
    e.strokeWeight = opsi.garis;
  }
  return e;
}
export function svgNode(svg: string, nama: string) {
  const n = figma.createNodeFromSvg(svg);
  n.name = nama;
  n.fills = [];
  n.clipsContent = false;
  return n;
}

// Wajah dibuat ulang dengan warna tinta cokelat agar cocok dengan gaya stiker.
export const warnaiWajah = (svg: string) => svg.replace(/#2A2350/g, W.tinta);

// Halaman: pakai page yang ada (berdasarkan nama) atau buat baru. Isi lama dengan nama `akar`
// dihapus dulu agar langkah aman diulang.
export async function siapkanHalaman(nama: string, akar: string[]) {
  let p = figma.root.children.find((x) => x.name === nama);
  if (!p) {
    p = figma.createPage();
    p.name = nama;
  }
  await figma.setCurrentPageAsync(p);
  for (const n of [...p.children]) if (akar.includes(n.name)) n.remove();
  return p;
}

// Frame auto layout yang menyesuaikan isi.
export function susun(arah: 'HORIZONTAL' | 'VERTICAL', nama: string, jarak: number, pad = 0) {
  const f = figma.createFrame();
  f.name = nama;
  f.layoutMode = arah;
  f.primaryAxisSizingMode = 'AUTO';
  f.counterAxisSizingMode = 'AUTO';
  f.itemSpacing = jarak;
  f.paddingLeft = f.paddingRight = f.paddingTop = f.paddingBottom = pad;
  f.fills = [];
  f.clipsContent = false;
  return f;
}

export function judul(induk: BaseNode & ChildrenMixin, isi: string, catatan: string, x = 0, y = 0) {
  const kotak = susun('VERTICAL', `judul ${isi}`, 12);
  kotak.appendChild(teks(isi, 56, { tebal: true }));
  kotak.appendChild(teks(catatan, 20, { warna: W.pudar, lebar: 1200 }));
  kotak.x = x; kotak.y = y;
  induk.appendChild(kotak);
  return kotak;
}

// Menyambung variant menjadi loop: tiap frame pindah ke frame berikutnya setelah jeda singkat.
export async function sambungLoop(frames: ComponentNode[], durasi: number) {
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

export function aturVariantSet(set: ComponentSetNode, latar: string) {
  set.layoutMode = 'HORIZONTAL';
  set.itemSpacing = 24;
  set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 24;
  set.primaryAxisSizingMode = 'AUTO';
  set.counterAxisSizingMode = 'AUTO';
  set.fills = [solid(latar)];
  set.cornerRadius = 24;
}

// Base plate mob: dicari dari ID yang dikirim langkah sebelumnya.
export type IdMob = { wajah: Record<string, string>; mob: Record<string, string>; prop: Record<string, string> };
export async function ambilMob(id: IdMob) {
  const wajah: Record<string, ComponentNode> = {};
  for (const [e, i] of Object.entries(id.wajah)) wajah[e] = (await figma.getNodeByIdAsync(i)) as ComponentNode;
  const set: Record<string, ComponentSetNode> = {};
  for (const [t, i] of Object.entries(id.mob)) set[t] = (await figma.getNodeByIdAsync(i)) as ComponentSetNode;
  const mob = (tipe: string, pose: string, emosi: string) => {
    const v = set[tipe].children.find((c) => c.name === `pose=${pose}`) as ComponentNode;
    const inst = v.createInstance();
    inst.setProperties({ [id.prop[tipe]]: wajah[emosi].id });
    inst.name = `mob-${tipe}`;
    return inst;
  };
  return { wajah, set, mob };
}
