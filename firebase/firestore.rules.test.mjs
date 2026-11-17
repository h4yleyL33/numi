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
  baru.data.xp = 10;
  await status(403, profil, b.idToken, 'PATCH', baru);
  await status(200, profil, a.idToken, 'PATCH', baru);
  baru.versi = 'c'.repeat(64);
  await status(403, profil, a.idToken, 'PATCH', baru);
});
