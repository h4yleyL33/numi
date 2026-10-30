import '../data/models/catatan_belajar.dart';
import '../data/models/topik.dart';
import '../data/models/bukti_skill.dart';

/// Mengatur perpindahan status topik di skill map (FR-002, STATE-001).
class SkillMapService {
  const SkillMapService(this.topik);

  final List<Topik> topik;

  Map<String, AksesMateri> susunAkses(Map<String, BuktiSkill> bukti) => {
    for (final t in topik) t.id: _akses(t, bukti),
  };

  AksesMateri _akses(Topik t, Map<String, BuktiSkill> bukti) {
    final prasyaratSiap = t.prasyarat.every((id) => bukti[id]?.siap == true);
    final prasyaratLemah = t.prasyarat.any(
      (id) => bukti[id]?.status == StatusBukti.indikasiLatihan,
    );
    final dicoba = bukti.containsKey(t.id);
    final terbuka = prasyaratSiap || (dicoba && !prasyaratLemah);
    return AksesMateri(
      topikId: t.id,
      terbuka: terbuka,
      alasan: prasyaratSiap
          ? 'Prasyarat jangkar mendukung latihan.'
          : (terbuka
                ? 'Jangkar sudah dicoba; prasyarat lain masih perlu diperiksa.'
                : 'Periksa atau latih prasyarat lebih dulu.'),
    );
  }

  List<Topik> prasyaratBelumDikuasai(
    Topik t,
    Map<String, StatusTopik> status,
  ) => [
    for (final id in t.prasyarat)
      if (status[id] != StatusTopik.mastered &&
          status[id] != StatusTopik.siapLanjut)
        topik.firstWhere((x) => x.id == id),
  ];
}
