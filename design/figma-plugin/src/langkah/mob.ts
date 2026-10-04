// Langkah 1: page "mob base plate". 11 komponen wajah dan 4 base plate mob dengan rig.
import { EMOSI, W, bingkai, elips, judul, putar, siapkanFont, siapkanHalaman, solid, svgNode, teks, warnaiWajah } from '../lib';
import { WAJAH } from '../svg';

type Tipe = {
  id: string; nama: string; warna: string; perut: string;
  bw: number; bh: number; cy: number; lengan: number; kaki: number; tebal: number;
  sayap?: boolean; antena?: boolean; telinga?: 'bulat' | 'runcing';
};
export const TIPE: Tipe[] = [
  { id: 'bulat', nama: 'Bulat (beruang kecil)', warna: '#FFF6E8', perut: '#FFE7C7', bw: 140, bh: 120, cy: 130, lengan: 40, kaki: 26, tebal: 22, telinga: 'bulat' },
  { id: 'tinggi', nama: 'Tinggi (katak penjaga pulau)', warna: '#A8D98A', perut: '#E3F5D3', bw: 96, bh: 150, cy: 118, lengan: 50, kaki: 30, tebal: 20 },
  { id: 'mungil', nama: 'Mungil (kucing kacang)', warna: '#FFC2CC', perut: '#FFE6EA', bw: 88, bh: 84, cy: 150, lengan: 28, kaki: 20, tebal: 16, telinga: 'runcing' },
  { id: 'bersayap', nama: 'Bersayap (sepupu Numi)', warna: '#FFE08A', perut: '#FFF4CC', bw: 110, bh: 110, cy: 124, lengan: 34, kaki: 22, tebal: 18, sayap: true, antena: true },
];

// Sudut tulang per pose, derajat berlawanan jarum jam. dy = geser seluruh badan.
type Pose = { L: number; R: number; KL: number; KR: number; B: number; S: number; dy: number };
export const POSE: Record<string, Pose> = {
  idle: { L: -12, R: 12, KL: 0, KR: 0, B: 0, S: 0, dy: 0 },
  'lambai-a': { L: -12, R: 150, KL: 0, KR: 0, B: 4, S: 10, dy: 0 },
  'lambai-b': { L: -12, R: 112, KL: 0, KR: 0, B: 2, S: -6, dy: 0 },
  lompat: { L: -150, R: 150, KL: -28, KR: 28, B: 0, S: 24, dy: -28 },
  duduk: { L: -40, R: 40, KL: -80, KR: 80, B: 0, S: 0, dy: 18 },
  sedih: { L: -3, R: 3, KL: 0, KR: 0, B: -6, S: -16, dy: 4 },
  tunjuk: { L: -12, R: 88, KL: 0, KR: 0, B: 3, S: 0, dy: 0 },
};
const GARIS = 3;

function rakit(t: Tipe, namaPose: string, wajahSenang: ComponentNode): ComponentNode {
  const p = POSE[namaPose];
  const c = figma.createComponent();
  c.name = `pose=${namaPose}`;
  c.resize(200, 220);
  c.fills = [];
  c.clipsContent = false;

  const root = bingkai('rig/root', 200, 220);
  c.appendChild(root);
  const cx = 100, cy = t.cy, atas = cy - t.bh / 2, bawah = cy + t.bh / 2;
  const sendi = new Map<FrameNode, [number, number]>();

  // Tulang: frame di sendi (pusat atas), bentuk menggantung ke bawah dari sendi.
  const tulang = (nama: string, x: number, y: number, w: number, panjang: number, warna: string) => {
    const f = bingkai(`rig/${nama}`, w, panjang);
    f.x = x - w / 2; f.y = y;
    f.appendChild(elips('bentuk', 0, 0, w, panjang, warna, { garis: GARIS }));
    sendi.set(f, [x, y]);
    root.appendChild(f);
    return f;
  };

  let sayapL: FrameNode | null = null, sayapR: FrameNode | null = null;
  if (t.sayap) {
    sayapL = tulang('sayap-kiri', cx - t.bw * 0.2, atas + t.bh * 0.15, 36, 62, '#DFF4FF');
    sayapR = tulang('sayap-kanan', cx + t.bw * 0.2, atas + t.bh * 0.15, 36, 62, '#DFF4FF');
  }
  const kakiL = tulang('kaki-kiri', cx - t.bw * 0.22, bawah - 10, t.tebal, t.kaki, t.warna);
  const kakiR = tulang('kaki-kanan', cx + t.bw * 0.22, bawah - 10, t.tebal, t.kaki, t.warna);

  const badan = bingkai('rig/badan', t.bw, t.bh);
  badan.x = cx - t.bw / 2; badan.y = atas;
  root.appendChild(badan);
  if (t.telinga === 'bulat') {
    badan.appendChild(elips('telinga-kiri', t.bw * 0.1, -10, 32, 32, t.warna, { garis: GARIS }));
    badan.appendChild(elips('telinga-kanan', t.bw * 0.9 - 32, -10, 32, 32, t.warna, { garis: GARIS }));
  } else if (t.telinga === 'runcing') {
    for (const [nama, x, arah] of [['telinga-kiri', t.bw * 0.08, -1], ['telinga-kanan', t.bw * 0.62, 1]] as const) {
      const s = svgNode(`<svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 26 26"><path d="M${arah < 0 ? '2 24 L6 2 L24 16' : '24 24 L20 2 L2 16'} Z" fill="${t.warna}" stroke="${W.garis}" stroke-width="${GARIS}" stroke-linejoin="round"/></svg>`, nama);
      s.x = x; s.y = -12;
      badan.appendChild(s);
    }
  }
  if (t.antena) {
    for (const [nama, x] of [['antena-kiri', t.bw * 0.3], ['antena-kanan', t.bw * 0.7]] as const) {
      const a = bingkai(`rig/${nama}`, 6, 30);
      a.x = x - 3; a.y = -26;
      const batang = figma.createRectangle();
      batang.name = 'batang'; batang.resize(3, 28); batang.x = 1.5; batang.fills = [solid(W.garis)];
      a.appendChild(batang);
      a.appendChild(elips('cahaya', -5, -8, 16, 16, W.muda, { garis: 2 }));
      badan.appendChild(a);
    }
  }
  badan.appendChild(elips('badan', 0, 0, t.bw, t.bh, t.warna, { garis: GARIS }));
  badan.appendChild(elips('perut', t.bw * 0.24, t.bh * 0.52, t.bw * 0.52, t.bh * 0.4, t.perut));

  const wajah = wajahSenang.createInstance();
  wajah.name = 'slot/wajah';
  wajah.rescale((Math.min(t.bw, t.bh) * 1.35) / 120);
  wajah.x = (t.bw - wajah.width) / 2;
  wajah.y = t.bh * 0.42 - wajah.height / 2;
  badan.appendChild(wajah);

  const bahuY = atas + t.bh * 0.45;
  const lenganL = tulang('lengan-kiri', cx - t.bw / 2 + t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna);
  const lenganR = tulang('lengan-kanan', cx + t.bw / 2 - t.tebal * 0.3, bahuY, t.tebal, t.lengan, t.warna);

  putar(lenganL, p.L, ...sendi.get(lenganL)!);
  putar(lenganR, p.R, ...sendi.get(lenganR)!);
  putar(kakiL, p.KL, ...sendi.get(kakiL)!);
  putar(kakiR, p.KR, ...sendi.get(kakiR)!);
  if (sayapL && sayapR) {
    putar(sayapL, 35 + p.S, ...sendi.get(sayapL)!);
    putar(sayapR, -35 - p.S, ...sendi.get(sayapR)!);
  }
  putar(badan, p.B, cx, bawah);
  root.y = p.dy;
  return c;
}

export async function utama() {
  await siapkanFont();
  const AKAR = ['judul Mob base plate', 'wajah emosi', 'base plate', 'contoh emosi'];
  const page = await siapkanHalaman('mob base plate', AKAR);
  judul(page, 'Mob base plate', 'Badan polos tanpa wajah. Emosi dipasang sebagai wajah lewat properti "emosi", pose lewat properti "pose". ' +
    'Tulang: rig/root > rig/badan (badan, perut, telinga, antena, slot/wajah), rig/lengan-*, rig/kaki-*, rig/sayap-*. Sendi tiap tulang ada di tengah atas frame-nya. ' +
    'Semua variant memakai nama layer yang sama, jadi mengganti pose dengan Smart Animate = animasi rig.');

  // wajah
  const deret = figma.createFrame();
  deret.name = 'wajah emosi';
  deret.fills = [solid(W.kertas)];
  deret.cornerRadius = 24;
  deret.resize(11 * 150 + 40, 210);
  deret.y = 200;
  page.appendChild(deret);
  const wajah: Record<string, ComponentNode> = {};
  EMOSI.forEach((e, i) => {
    const c = figma.createComponent();
    c.name = `wajah/${e}`;
    c.resize(120, 120);
    c.fills = [];
    c.clipsContent = false;
    const n = svgNode(warnaiWajah(WAJAH[e]), 'garis');
    c.appendChild(n);
    n.x = 0; n.y = 0;
    c.description = `Wajah ${e}. Dipasang ke slot/wajah base plate dan stiker barang lewat properti "emosi".`;
    c.x = 20 + i * 150; c.y = 20;
    deret.appendChild(c);
    const label = teks(e, 16, { tebal: true, warna: W.pudar });
    label.x = c.x + 10; label.y = 160;
    deret.appendChild(label);
    wajah[e] = c;
  });

  // base plate
  const wadah = figma.createFrame();
  wadah.name = 'base plate';
  wadah.fills = [];
  wadah.clipsContent = false;
  wadah.y = 460;
  page.appendChild(wadah);
  const id = { wajah: {} as Record<string, string>, mob: {} as Record<string, string>, prop: {} as Record<string, string> };
  for (const e of EMOSI) id.wajah[e] = wajah[e].id;
  let yy = 0, lebar = 0;
  for (const tipe of TIPE) {
    const label = teks(tipe.nama, 24, { tebal: true });
    label.y = yy;
    wadah.appendChild(label);
    const set = figma.combineAsVariants(Object.keys(POSE).map((n) => rakit(tipe, n, wajah.senang)), wadah);
    set.name = `mob/${tipe.id}`;
    set.description = `Base plate mob ${tipe.nama}. Pilih pose dan emosi dari panel properti.`;
    set.layoutMode = 'HORIZONTAL';
    set.itemSpacing = 40;
    set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 30;
    set.primaryAxisSizingMode = 'AUTO';
    set.counterAxisSizingMode = 'AUTO';
    set.fills = [solid(W.kertas)];
    set.cornerRadius = 24;
    set.y = yy + 44;
    const prop = set.addComponentProperty('emosi', 'INSTANCE_SWAP', wajah.senang.id, {
      preferredValues: EMOSI.map((e) => ({ type: 'COMPONENT' as const, key: wajah[e].key })),
    });
    for (const v of set.children as ComponentNode[]) {
      const slot = v.findOne((n) => n.name === 'slot/wajah') as InstanceNode;
      slot.componentPropertyReferences = { mainComponent: prop };
    }
    id.mob[tipe.id] = set.id;
    id.prop[tipe.id] = prop;
    yy += 44 + set.height + 50;
    lebar = Math.max(lebar, set.width);
  }
  wadah.resize(lebar, yy);

  // contoh: satu base plate dengan semua emosi
  const contoh = figma.createFrame();
  contoh.name = 'contoh emosi';
  contoh.fills = [];
  contoh.clipsContent = false;
  contoh.y = 460 + yy + 40;
  page.appendChild(contoh);
  contoh.appendChild(teks('Contoh: mob/bulat dengan 11 emosi', 24, { tebal: true }));
  const set = (await figma.getNodeByIdAsync(id.mob.bulat)) as ComponentSetNode;
  const idle = set.children.find((c) => c.name === 'pose=idle') as ComponentNode;
  EMOSI.forEach((e, i) => {
    const inst = idle.createInstance();
    inst.setProperties({ [id.prop.bulat]: wajah[e].id });
    inst.x = i * 210; inst.y = 50;
    contoh.appendChild(inst);
  });
  contoh.resize(11 * 210, 280);
  return { page: page.id, ...id };
}
