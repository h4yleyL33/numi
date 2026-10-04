// Langkah 2: page "anim emote". Butuh ID dari langkah mob.
import { EMOSI, IdMob, W, ambilMob, aturVariantSet, judul, putarTengah, sambungLoop, siapkanFont, siapkanHalaman, svgNode, teks, warnaiWajah } from '../lib';
import { MASKOT } from '../svg';

type Kunci = { dy: number; s: number; rot: number; wajah?: string };
const k = (dy: number, s: number, rot: number, wajah?: string): Kunci => ({ dy, s, rot, wajah });
export const EMOTE: Record<string, { durasi: number; kunci: Kunci[]; pose: string[] }> = {
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
  mengedip: { durasi: 0.3, kunci: [k(0, 1, 0, 'senang'), k(0, 1, 6), k(0, 1, 6), k(0, 1, 0, 'senang')], pose: ['idle', 'tunjuk', 'tunjuk', 'idle'] },
};

export async function utama(ID: IdMob) {
  await siapkanFont();
  const page = await siapkanHalaman('anim emote', ['judul Animasi emote', 'emote']);
  const { mob } = await ambilMob(ID);
  judul(page, 'Animasi emote', 'Kiri: Numi. Kanan: mob/bulat (pose rig + wajah emosi). Tiap baris adalah component set 4 frame yang tersambung ' +
    '(After delay → Change to → Smart Animate). Taruh instance frame=1 di dalam sebuah frame, lalu tekan Present untuk melihat animasinya.');
  const wadah = figma.createFrame();
  wadah.name = 'emote';
  wadah.fills = [];
  wadah.clipsContent = false;
  wadah.y = 180;
  page.appendChild(wadah);

  const hasil: Record<string, string[]> = {};
  let yy = 0, lebar = 0;
  for (const e of EMOSI) {
    const resep = EMOTE[e];
    const frames = resep.kunci.map((kc, i) => {
      const c = figma.createComponent();
      c.name = `frame=${i + 1}`;
      c.resize(260, 260);
      c.fills = [];
      c.clipsContent = false;
      const n = svgNode(warnaiWajah(MASKOT[kc.wajah ?? e]), 'numi');
      c.appendChild(n);
      n.rescale(kc.s);
      n.x = (260 - n.width) / 2;
      n.y = (260 - n.height) / 2 + kc.dy;
      putarTengah(n, kc.rot);
      return c;
    });
    const set = figma.combineAsVariants(frames, wadah);
    set.name = `emote/numi/${e}`;
    set.description = `Emote Numi ${e}. Pasang instance frame=1 lalu Play: berputar 4 frame dengan Smart Animate.`;
    aturVariantSet(set, '#DDF1FA');
    set.y = yy;
    await sambungLoop(frames, resep.durasi);

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
    const setMob = figma.combineAsVariants(framesMob, wadah);
    setMob.name = `emote/mob/${e}`;
    setMob.description = `Emote mob ${e}: pose rig dan wajah emosi berganti tiap frame.`;
    aturVariantSet(setMob, '#E9F6E1');
    setMob.x = set.width + 40;
    setMob.y = yy;
    await sambungLoop(framesMob, resep.durasi);

    const label = teks(e, 28, { tebal: true });
    label.x = setMob.x + setMob.width + 40; label.y = yy + 20;
    wadah.appendChild(label);
    hasil[e] = [set.id, setMob.id];
    lebar = Math.max(lebar, label.x + 200);
    yy += Math.max(set.height, setMob.height) + 40;
  }
  wadah.resize(lebar, yy);
  return { page: page.id, emote: hasil, warnaLatar: W.krem };
}
