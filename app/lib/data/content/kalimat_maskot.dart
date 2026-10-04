import '../models/companion_message.dart';

// Kalimat maskot per pemicu. {nama} diganti nama panggilan siswa.
// Nadanya menyemangati, tidak pernah menyalahkan, sesuai NFR-001.

class KalimatMaskot {
  const KalimatMaskot(this.ekspresi, this.variasi);
  final EkspresiMaskot ekspresi;
  final List<String> variasi;
}

const kalimatMaskot = <JenisTrigger, KalimatMaskot>{
  JenisTrigger.sambutan: KalimatMaskot(EkspresiMaskot.senang, [
    'Halo {nama}! Pulau mana yang mau kita terangi hari ini?',
    'Selamat datang lagi, {nama}! Cahayaku sudah siap.',
    'Hai {nama}! Ayo lanjutkan petualangan kita.',
  ]),
  JenisTrigger.streakTerancam: KalimatMaskot(EkspresiMaskot.mengantuk, [
    '{nama}, apiku mulai redup... satu lesson saja sudah cukup untuk menyalakannya!',
    'Jangan sampai nyala kita padam, {nama}. Yuk belajar sebentar hari ini.',
  ]),
  JenisTrigger.lamaTidakAktif: KalimatMaskot(EkspresiMaskot.sedih, [
    'Aku kangen, {nama}! Kabut mulai turun lagi di pulau-pulau kita.',
    '{nama}, sudah lama kita tidak berpetualang. Aku tunggu ya!',
  ]),
  JenisTrigger.lessonSelesai: KalimatMaskot(EkspresiMaskot.bangga, [
    'Keren, {nama}! Cahaya pulau ini makin terang.',
    'Kamu hebat, {nama}! Satu langkah lagi menuju mercusuar.',
  ]),
  JenisTrigger.lessonGagal: KalimatMaskot(EkspresiMaskot.semangat, [
    'Tidak apa-apa, {nama}. Salah itu bagian dari belajar. Coba sekali lagi yuk!',
    'Hampir, {nama}! Kita ulangi pelan-pelan, pasti bisa.',
  ]),
  JenisTrigger.masteryLulus: KalimatMaskot(EkspresiMaskot.bangga, [
    'Mercusuarnya menyala! {nama} berhasil menguasai pulau ini!',
  ]),
  JenisTrigger.masteryGagal: KalimatMaskot(EkspresiMaskot.semangat, [
    'Mercusuarnya belum menyala, {nama}. Kita latihan sedikit lagi, lalu coba lagi ya.',
  ]),
  JenisTrigger.badgeBaru: KalimatMaskot(EkspresiMaskot.bangga, [
    'Wah, {nama} dapat lencana baru!',
  ]),
  JenisTrigger.levelNaik: KalimatMaskot(EkspresiMaskot.bangga, [
    'Level naik! Cahayamu makin terang, {nama}!',
  ]),
};

/// Kalimat maskot saat diagnostic test, dipakai bergantian setiap soal.
const kalimatDiagnostic = [
  'Santai saja, ini bukan ujian.',
  'Jawab sebisamu ya.',
  'Aku mencatat jawabanmu.',
  'Bagus, lanjut!',
  'Kita sedang membaca peta kemampuanmu.',
];
