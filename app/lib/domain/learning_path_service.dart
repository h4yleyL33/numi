import '../data/content/daftar_lesson.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/data_belajar.dart';
import '../data/models/lesson.dart';
import '../data/models/topik.dart';

class Rekomendasi {
  const Rekomendasi({required this.topik, this.lesson});

  final Topik topik;

  /// Kosong berarti semua lesson topik ini selesai dan siswa siap mastery test.
  final Lesson? lesson;

  bool get siapMastery => lesson == null;
}

/// Menentukan apa yang sebaiknya dipelajari berikutnya (FR-003).
class LearningPathService {
  const LearningPathService(this.topik);

  final List<Topik> topik;

  /// Topik yang sedang dilatih didahulukan, supaya siswa menuntaskan satu pulau
  /// sebelum pindah. Setelah itu topik terbuka dengan urutan paling awal.
  Rekomendasi? rekomendasi(DataBelajar data) {
    final urut = [...topik]..sort((a, b) => a.urutan.compareTo(b.urutan));
    Topik? pilihan;
    for (final t in urut) {
      if (data.statusTopik(t.id) == StatusTopik.perluLatihan) {
        pilihan = t;
        break;
      }
    }
    pilihan ??= urut.where((t) => data.statusTopik(t.id) == StatusTopik.belumDikuasai).firstOrNull;
    if (pilihan == null) return null;
    return Rekomendasi(topik: pilihan, lesson: lessonBerikutnya(pilihan.id, data));
  }

  Lesson? lessonBerikutnya(String topikId, DataBelajar data) =>
      lessonUntuk(topikId).where((l) => !data.lessonSelesai(l.id)).firstOrNull;

  bool siapMastery(String topikId, DataBelajar data) =>
      lessonUntuk(topikId).every((l) => data.lessonSelesai(l.id));
}
