import assert from 'node:assert/strict';
import { test } from 'node:test';

const project = 'demo-numi';
const auth = process.env.FIREBASE_AUTH_EMULATOR_HOST;
const firestore = process.env.FIRESTORE_EMULATOR_HOST;
assert.ok(auth && firestore, 'Jalankan melalui firebase emulators:exec.');

const base = `http://${firestore}/v1/projects/${project}/databases/(default)/documents`;

async function akun() {
  const response = await fetch(
    `http://${auth}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ returnSecureToken: true }),
    },
  );
  assert.equal(response.status, 200);
  return response.json();
}

function nilai(value) {
  if (value === null) return { nullValue: null };
  if (typeof value === 'string') return { stringValue: value };
  if (typeof value === 'boolean') return { booleanValue: value };
  if (Number.isInteger(value)) return { integerValue: String(value) };
  if (Array.isArray(value)) return { arrayValue: { values: value.map(nilai) } };
  return { mapValue: { fields: bidang(value) } };
}

function bidang(value) {
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, nilai(item)]));
}

function request(path, token, method = 'GET', data) {
  return fetch(`${base}/${path}`, {
    method,
    headers: {
      ...(token && { Authorization: `Bearer ${token}` }),
      ...(data && { 'Content-Type': 'application/json' }),
    },
    body: data && JSON.stringify({ fields: bidang(data) }),
  });
}

test('Firestore membatasi profil ke UID dan menolak skema atau revisi tidak sah', async () => {
  const a = await akun();
  const b = await akun();
  const wali = `wali/${a.localId}`;
  const profil = `${wali}/profil/profil-123`;
  const data = {
    versi: 'a'.repeat(64),
    dasar: null,
    data: {
      versi: 5,
      siswa: {
        id: 'profil-123',
        waliUid: a.localId,
        nama: 'Raka',
        kelas: 2,
        usia: null,
        kelompokBelajar: null,
        dibuatPada: '2026-11-17T10:00:00.000',
      },
      sesiLesson: [],
      sesiDiagnostic: null,
      sesiMastery: [],
      buktiSkill: [],
      aksesMateri: [],
      skillMap: [],
      hasilDiagnostic: [],
      progresLesson: [],
      riwayatJawaban: [],
      hasilMastery: [],
      lencana: [],
      streakLog: [],
      pesanMaskot: [],
      xp: 0,
    },
  };

  async function status(expected, path, token, method, isi) {
    const response = await request(path, token, method, isi);
    assert.equal(response.status, expected, await response.text());
  }

  await status(403, profil, null, 'PATCH', data);
  await status(403, profil, b.idToken, 'PATCH', data);
  const salah = structuredClone(data);
  salah.data.siswa.kelas = 7;
  await status(403, profil, a.idToken, 'PATCH', salah);
  salah.data.siswa.kelas = 2;
  salah.data.siswa.waliUid = b.localId;
  await status(403, profil, a.idToken, 'PATCH', salah);

  await status(200, wali, a.idToken, 'PATCH', { uid: a.localId, versi: 1 });
  await status(200, profil, a.idToken, 'PATCH', data);
  await status(200, profil, a.idToken);
  await status(200, `${wali}/profil`, a.idToken);
  await status(403, wali, b.idToken);
  await status(403, profil, null);
  await status(403, profil, b.idToken);
  await status(403, `${wali}/profil`, b.idToken);
  await status(403, profil, b.idToken, 'DELETE');

  const baru = structuredClone(data);
  baru.dasar = data.versi;
  baru.versi = 'b'.repeat(64);
  baru.data.siswa.nama = 'Raka QA';
  await status(403, profil, b.idToken, 'PATCH', baru);
  await status(200, profil, a.idToken, 'PATCH', baru);
  baru.versi = 'c'.repeat(64);
  await status(403, profil, a.idToken, 'PATCH', baru);

  for (const field of ['sesiLesson', 'sesiMastery']) {
    const rusak = structuredClone(data);
    rusak.dasar = 'b'.repeat(64);
    rusak.versi = 'd'.repeat(64);
    rusak.data[field] = [{ id: 'checkpoint-tidak-lengkap' }];
    await status(403, profil, a.idToken, 'PATCH', rusak);
  }
  const palsu = structuredClone(data);
  palsu.dasar = 'b'.repeat(64);
  palsu.versi = 'e'.repeat(64);
  palsu.data.xp = 999999999;
  await status(403, profil, a.idToken, 'PATCH', palsu);

  // Uji batas evaluator rules pada seluruh slot checkpoint yang didukung.
  const penuh = structuredClone(data);
  penuh.dasar = 'b'.repeat(64);
  penuh.versi = 'f'.repeat(64);
  const sesi = (i, konteks) => ({
    id: `${konteks}-${i}`, topikId: `T${String(i % 12 + 1).padStart(2, '0')}`,
    versiKebijakan: 'numi-pilot-v1', statusSimpan: 'lokal', konteks,
    soal: Array.from({length: konteks === 'diagnostic' ? 2 : 5}, () => ({})),
    jawaban: [], hasil: null,
  });
  penuh.data.sesiLesson = Array.from({length: 24}, (_, i) => sesi(i, 'lesson'));
  penuh.data.sesiMastery = Array.from({length: 12}, (_, i) => sesi(i, 'mastery'));
  penuh.data.sesiDiagnostic = {id: 'diag', kelas: 6, versiKebijakan: 'numi-pilot-v1',
    statusSimpan: 'lokal', ditutup: false,
    blok: Array.from({length: 6}, (_, i) => sesi(i, 'diagnostic'))};
  await status(200, profil, a.idToken, 'PATCH', penuh);
  const rusakTerakhir = structuredClone(penuh);
  rusakTerakhir.dasar = penuh.versi;
  rusakTerakhir.versi = '9'.repeat(64);
  rusakTerakhir.data.sesiLesson[23] = {id: 'rusak-di-slot-terakhir'};
  await status(403, profil, a.idToken, 'PATCH', rusakTerakhir);
});
