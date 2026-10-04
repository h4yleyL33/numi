import '../data/models/catatan_belajar.dart';
import '../data/models/topik.dart';

/// Mengatur perpindahan status topik di skill map (FR-002, STATE-001).
class SkillMapService {
  const SkillMapService(this.topik);

  final List<Topik> topik;

  /// Topik terkunci dibuka menjadi belum dikuasai kalau semua prasyaratnya
  /// sudah dikuasai.
  Map<String, StatusTopik> bukaTopik(Map<String, StatusTopik> status) {
    final hasil = Map<String, StatusTopik>.from(status);
    for (final t in topik) {
      final sekarang = hasil[t.id] ?? StatusTopik.terkunci;
      if (sekarang != StatusTopik.terkunci) continue;
      final siap = t.prasyarat.every((p) => hasil[p] == StatusTopik.mastered);
      if (siap) hasil[t.id] = StatusTopik.belumDikuasai;
    }
    return hasil;
  }

  /// Status saat siswa mulai mengerjakan lesson di topik itu.
  StatusTopik saatMulaiLesson(StatusTopik status) =>
      status == StatusTopik.belumDikuasai ? StatusTopik.perluLatihan : status;

  /// Status setelah mastery test. Gagal tetap perlu latihan (UC-005 alur alternatif).
  StatusTopik setelahMastery(StatusTopik status, {required bool lulus}) {
    if (lulus) return StatusTopik.mastered;
    return status == StatusTopik.mastered ? StatusTopik.mastered : StatusTopik.perluLatihan;
  }

  List<Topik> prasyaratBelumDikuasai(Topik t, Map<String, StatusTopik> status) => [
        for (final id in t.prasyarat)
          if (status[id] != StatusTopik.mastered) topik.firstWhere((x) => x.id == id),
      ];
}
