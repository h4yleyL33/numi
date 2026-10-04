// Langkah: base plate hewan (satu hewan per panggilan) di page "mob base plate".
// Data bentuk dari design/hewan/<id>.json (dibuat tools/buat_hewan.mjs). Butuh ID wajah.
import { EMOSI, W, bingkai, putar, siapkanFont, siapkanHalaman, solid, svgNode, teks } from '../lib';

// induk: nama tulang yang menjadi induk (mis. telinga di dalam kepala). Kotak dan sendi selalu
// dalam koordinat komponen; diubah ke koordinat induk saat dipasang.
type Bagian = { nama: string; induk?: string; kotak: number[]; sendi: number[]; svg: string };
type Hewan = { id: string; nama: string; ukuran: number[]; wajah: { x: number; y: number; skala: number }; bagian: Bagian[] };

// Sudut tiap tulang per pose (derajat berlawanan jarum jam) dan geser badan.
const POSE: Record<string, { tulang: Record<string, number>; dy: number }> = {
  idle: { tulang: {}, dy: 0 },
  'lambai-a': { tulang: { 'lengan-kanan': 140, kepala: 6 }, dy: 0 },
  'lambai-b': { tulang: { 'lengan-kanan': 105, kepala: 3 }, dy: 0 },
  lompat: { tulang: { 'lengan-kiri': -135, 'lengan-kanan': 135, 'kaki-kiri': -15, 'kaki-kanan': 15 }, dy: -24 },
  sedih: { tulang: { kepala: -8, 'lengan-kiri': 4, 'lengan-kanan': -4 }, dy: 4 },
  tunjuk: { tulang: { 'lengan-kanan': 80, kepala: -4 }, dy: 0 },
};

function rakit(h: Hewan, pose: string, wajah: ComponentNode) {
  const c = figma.createComponent();
  c.name = `pose=${pose}`;
  c.resize(h.ukuran[0], h.ukuran[1]);
  c.fills = [];
  c.clipsContent = false;
  const root = bingkai('rig/root', h.ukuran[0], h.ukuran[1]);
  c.appendChild(root);
  const tulangNya: Record<string, FrameNode> = {};
  const anak: Record<string, number> = {};
  // Induk dipasang dulu supaya anak bisa masuk ke dalamnya; urutan tumpukan tetap ikut data.
  const urut = [...h.bagian.filter((b) => !b.induk), ...h.bagian.filter((b) => b.induk)];
  for (const b of urut) {
    const [x, y, w, t] = b.kotak;
    const induk = b.induk ? h.bagian.find((a) => a.nama === b.induk)! : null;
    const [dx, dy] = induk ? [induk.kotak[0], induk.kotak[1]] : [0, 0];
    const tulang = bingkai(`rig/${b.nama}`, w, t);
    tulang.x = x - dx; tulang.y = y - dy;
    const bentuk = svgNode(b.svg, 'bentuk');
    tulang.appendChild(bentuk);
    bentuk.x = 0; bentuk.y = 0;
    if (b.nama === 'kepala') {
      const s = wajah.createInstance();
      s.name = 'slot/wajah';
      s.rescale(h.wajah.skala);
      s.x = h.wajah.x - 60 * h.wajah.skala - x;
      s.y = h.wajah.y - 54.5 * h.wajah.skala - y;
      tulang.appendChild(s);
    }
    if (induk) {
      // Anak ditaruh di belakang bentuk induknya, berurutan sesuai data.
      tulangNya[induk.nama].insertChild(anak[induk.nama] ?? 0, tulang);
      anak[induk.nama] = (anak[induk.nama] ?? 0) + 1;
    } else {
      root.appendChild(tulang);
    }
    tulangNya[b.nama] = tulang;
    putar(tulang, POSE[pose].tulang[b.nama] ?? 0, b.sendi[0] - dx, b.sendi[1] - dy);
  }
  root.y = POSE[pose].dy;
  return c;
}

// Data hewan (isi design/hewan/<id>.json) dikirim lewat ID.data oleh tools/skrip_hewan.mjs,
// supaya skrip tidak membawa data semua hewan.
export async function utama(ID: { wajah: Record<string, string>; data: Hewan; y: number }) {
  await siapkanFont();
  const h = ID.data;
  const page = await siapkanHalaman('mob base plate', ['base plate', 'contoh emosi', `hewan/${h.id}`]);
  const wajah: Record<string, ComponentNode> = {};
  for (const e of EMOSI) wajah[e] = (await figma.getNodeByIdAsync(ID.wajah[e])) as ComponentNode;

  const wadah = bingkai(`hewan/${h.id}`, 100, 100);
  wadah.y = ID.y;
  page.appendChild(wadah);
  const label = teks(`${h.nama}`, 28, { tebal: true });
  wadah.appendChild(label);

  const set = figma.combineAsVariants(// ponytail: baru pose idle; pose lain menunggu bentuk lengan khusus rig.
    ['idle'].map((p) => rakit(h, p, wajah.senang)), wadah);
  set.name = `mob/${h.id}`;
  set.description = `Base plate ${h.nama}. Pose lewat properti "pose", wajah lewat properti "emosi". Tulang: rig/root > rig/badan, rig/kaki-*, rig/lengan-*, rig/kepala (berisi slot/wajah).`;
  set.layoutMode = 'HORIZONTAL';
  set.itemSpacing = 32;
  set.paddingLeft = set.paddingRight = set.paddingTop = set.paddingBottom = 32;
  set.primaryAxisSizingMode = 'AUTO';
  set.counterAxisSizingMode = 'AUTO';
  set.fills = [solid(W.kertas)];
  set.cornerRadius = 24;
  set.y = 50;
  const prop = set.addComponentProperty('emosi', 'INSTANCE_SWAP', wajah.senang.id, {
    preferredValues: EMOSI.map((e) => ({ type: 'COMPONENT' as const, key: wajah[e].key })),
  });
  for (const v of set.children as ComponentNode[]) {
    const slot = v.findOne((n) => n.name === 'slot/wajah') as InstanceNode;
    slot.componentPropertyReferences = { mainComponent: prop };
  }

  // contoh: 11 emosi pada pose idle
  const idle = set.children.find((c) => c.name === 'pose=idle') as ComponentNode;
  const contohY = 50 + set.height + 30;
  const t = teks(`${h.nama} dengan 11 emosi`, 18, { tebal: true, warna: W.pudar });
  t.y = contohY;
  wadah.appendChild(t);
  EMOSI.forEach((e, i) => {
    const inst = idle.createInstance();
    inst.setProperties({ [prop]: wajah[e].id });
    inst.rescale(0.8);
    inst.x = i * 230; inst.y = contohY + 36;
    wadah.appendChild(inst);
  });
  wadah.resize(Math.max(set.width, 11 * 230), contohY + 36 + 200);
  return { set: set.id, prop, tinggi: wadah.height };
}
