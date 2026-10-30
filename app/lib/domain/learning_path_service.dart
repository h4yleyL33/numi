import '../data/content/daftar_lesson.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/data_belajar.dart';
import '../data/models/lesson.dart';
import '../data/models/topik.dart';

class Rekomendasi {
  const Rekomendasi({required this.topik, this.lesson, this.alasan = ''});

  final Topik topik;
  final String alasan;

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
    final lessonTertunda = data.sesiLesson.values
        .where((s) => !s.selesai)
        .firstOrNull;
    if (lessonTertunda != null) {
      final lesson = lessonUntuk(lessonTertunda.topikId)
          .where((l) => l.id == lessonTertunda.lessonId)
          .firstOrNull;
      if (lesson != null) {
        return Rekomendasi(
          topik: urut.firstWhere((t) => t.id == lessonTertunda.topikId),
          lesson: lesson,
          alasan:
              'Lanjutkan lesson tersimpan: ${lessonTertunda.jawaban.length}/5 jawaban.',
        );
      }
    }
    final tertunda = data.sesiMastery.values
        .where((s) => !s.selesai)
        .firstOrNull;
    if (tertunda != null) {
      return Rekomendasi(
        topik: urut.firstWhere((t) => t.id == tertunda.topikId),
        alasan:
            'Lanjutkan test tersimpan: ${tertunda.jawaban.length}/5 jawaban.',
      );
    }
    Topik? pilihan;
    for (final t in urut) {
      if (data.statusTopik(t.id) == StatusTopik.perluLatihan) {
        pilihan = t;
        break;
      }
    }
    pilihan ??= urut
        .where(
          (t) =>
              data.statusTopik(t.id) == StatusTopik.belumDiuji ||
              data.statusTopik(t.id) == StatusTopik.siapLanjut,
        )
        .firstOrNull;
    if (pilihan == null) return null;
    final status = data.buktiSkill[pilihan.id];
    return Rekomendasi(
      topik: pilihan,
      lesson: lessonBerikutnya(pilihan.id, data),
      alasan: status == null
          ? 'Jangkar ini belum dicoba.'
          : 'Hasil sampel ${status.benar}/${status.total} menjadi dasar latihan berikutnya.',
    );
  }

  Lesson? lessonBerikutnya(String topikId, DataBelajar data) =>
      lessonUntuk(topikId)
          .where((l) => data.sesiLesson[l.id]?.selesai == false)
          .firstOrNull ??
      lessonUntuk(topikId).where((l) => !data.lessonSelesai(l.id)).firstOrNull;

  bool siapMastery(String topikId, DataBelajar data) =>
      lessonUntuk(topikId).every((l) => data.lessonSelesai(l.id));
}
