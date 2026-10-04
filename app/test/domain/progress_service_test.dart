import 'package:flutter_test/flutter_test.dart';
import 'package:numi/core/utils/tanggal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/domain/progress_service.dart';

void main() {
  const service = ProgressService();
  final hariIni = DateTime(2026, 9, 26, 10);

  List<StreakLog> log(List<int> hariLalu) => [
        for (final h in hariLalu)
          StreakLog(tanggal: kunciTanggal(hariIni.subtract(Duration(days: h))), jumlahAktivitas: 1),
      ];

  test('level naik setiap 100 XP', () {
    expect(service.level(0), 1);
    expect(service.level(99), 1);
    expect(service.level(100), 2);
    expect(service.xpDiLevel(250), 50);
  });

  test('streak dihitung dari hari berturut-turut sampai hari ini', () {
    final info = service.streak(log([0, 1, 2]), hariIni);
    expect(info.sekarang, 3);
    expect(info.aktifHariIni, isTrue);
    expect(info.terancam, isFalse);
  });

  test('streak berakhir kemarin masih hidup tetapi terancam', () {
    final info = service.streak(log([1, 2, 3]), hariIni);
    expect(info.sekarang, 3);
    expect(info.terancam, isTrue);
  });

  test('streak putus kalau satu hari terlewat', () {
    final info = service.streak(log([2, 3, 4, 5]), hariIni);
    expect(info.sekarang, 0);
    expect(info.terbaik, 4);
  });

  test('catat aktivitas menambah hari baru atau menambah hitungan hari yang sama', () {
    var l = service.catatAktivitas(const [], hariIni);
    l = service.catatAktivitas(l, hariIni.add(const Duration(hours: 3)));
    expect(l, hasLength(1));
    expect(l.single.jumlahAktivitas, 2);
  });

  test('lencana pemula, teliti, dan cepat terbuka setelah lesson sempurna yang cepat', () {
    final data = DataBelajar(
      progresLesson: {
        'T01-L1': LessonProgress(
          lessonId: 'T01-L1',
          topikId: 'T01',
          selesai: true,
          skorTerbaik: 100,
          jumlahPercobaan: 1,
          waktu: hariIni,
        ),
      },
      streakLog: log([0]),
    );
    final baru = service.lencanaBaru(
      data,
      hariIni,
      const KejadianSesi(lessonSelesai: true, sempurna: true, durasi: Duration(seconds: 70)),
    );
    expect(baru.map((l) => l.id), containsAll(['pemula', 'teliti', 'cepat']));
    expect(baru.map((l) => l.id), isNot(contains('rajin')));
  });

  test('lencana yang sudah dimiliki tidak diberikan lagi', () {
    final data = DataBelajar(
      progresLesson: {
        'T01-L1': LessonProgress(
            lessonId: 'T01-L1', topikId: 'T01', selesai: true, skorTerbaik: 60, jumlahPercobaan: 1, waktu: hariIni),
      },
      lencana: [SiswaLencana(badgeId: 'pemula', waktuDiperoleh: hariIni)],
    );
    expect(service.lencanaBaru(data, hariIni, const KejadianSesi()).map((l) => l.id), isNot(contains('pemula')));
  });
}
