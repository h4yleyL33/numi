import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/domain/learning_path_service.dart';

void main() {
  final jalur = LearningPathService(daftarTopik);
  final lesson = lessonUntuk('T01');
  final tesPada = DateTime(2026, 11, 28);

  DataBelajar data({required bool lulus, required DateTime waktuLatihan}) =>
      DataBelajar(
        hasilMastery: [
          MasteryResult(
            topikId: 'T01',
            skor: lulus ? 100 : 60,
            lulus: lulus,
            waktu: tesPada,
          ),
        ],
        progresLesson: {
          for (final item in lesson)
            item.id: LessonProgress(
              lessonId: item.id,
              topikId: 'T01',
              selesai: true,
              skorTerbaik: 100,
              jumlahPercobaan: 1,
              waktu: waktuLatihan,
            ),
        },
      );

  test(
    'kegagalan mastery menyarankan latihan lagi sampai percobaan berikutnya',
    () {
      final gagal = data(lulus: false, waktuLatihan: DateTime(2026, 11, 27));
      expect(jalur.lessonBerikutnya('T01', gagal)?.id, lesson.last.id);
      expect(jalur.jadwalPeriksaUlang('T01', gagal), isNull);

      final sudahLatihan = data(
        lulus: false,
        waktuLatihan: DateTime(2026, 11, 29),
      );
      expect(jalur.lessonBerikutnya('T01', sudahLatihan), isNull);
    },
  );

  test(
    'hasil mastery lulus dijadwalkan kembali lima hari kalender kemudian',
    () {
      final lulus = data(lulus: true, waktuLatihan: tesPada);
      expect(jalur.jadwalPeriksaUlang('T01', lulus), DateTime(2026, 12, 3));
      expect(jalur.jadwalPeriksaUlang('T02', lulus), isNull);
    },
  );
}
