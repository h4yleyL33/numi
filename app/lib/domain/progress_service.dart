import '../core/config/app_config.dart';
import '../core/utils/tanggal.dart';
import '../data/content/daftar_lencana.dart';
import '../data/models/badge.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/data_belajar.dart';

class InfoStreak {
  const InfoStreak({required this.sekarang, required this.terbaik, required this.aktifHariIni});

  final int sekarang;
  final int terbaik;
  final bool aktifHariIni;

  /// Streak masih hidup tapi hari ini belum belajar.
  bool get terancam => sekarang > 0 && !aktifHariIni;
}

/// Kejadian di satu sesi belajar yang dipakai untuk memeriksa syarat lencana.
class KejadianSesi {
  const KejadianSesi({this.lessonSelesai = false, this.sempurna = false, this.durasi});

  final bool lessonSelesai;
  final bool sempurna;
  final Duration? durasi;
}

/// Gamifikasi: XP, level, streak, dan lencana (FR-006, FR-008).
class ProgressService {
  const ProgressService();

  int level(int xp) => xp ~/ AppConfig.xpPerLevel + 1;

  /// XP yang sudah terkumpul di level sekarang, untuk bar progres.
  int xpDiLevel(int xp) => xp % AppConfig.xpPerLevel;

  InfoStreak streak(List<StreakLog> log, DateTime hariIni) {
    final hari = log.map((l) => dariKunciTanggal(l.tanggal)).toSet().toList()..sort();
    if (hari.isEmpty) return const InfoStreak(sekarang: 0, terbaik: 0, aktifHariIni: false);

    var terbaik = 1;
    var jalan = 1;
    for (var i = 1; i < hari.length; i++) {
      jalan = selisihHari(hari[i - 1], hari[i]) == 1 ? jalan + 1 : 1;
      if (jalan > terbaik) terbaik = jalan;
    }

    final jarak = selisihHari(hari.last, hariIni);
    final sekarang = jarak <= 1 ? jalan : 0;
    return InfoStreak(sekarang: sekarang, terbaik: terbaik, aktifHariIni: jarak == 0);
  }

  List<StreakLog> catatAktivitas(List<StreakLog> log, DateTime waktu) {
    final kunci = kunciTanggal(waktu);
    final ada = log.any((l) => l.tanggal == kunci);
    if (!ada) return [...log, StreakLog(tanggal: kunci, jumlahAktivitas: 1)];
    return [
      for (final l in log)
        l.tanggal == kunci ? StreakLog(tanggal: kunci, jumlahAktivitas: l.jumlahAktivitas + 1) : l,
    ];
  }

  /// Lencana yang syaratnya baru terpenuhi setelah sesi ini.
  List<Lencana> lencanaBaru(DataBelajar data, DateTime waktu, KejadianSesi kejadian) {
    final streakSekarang = streak(data.streakLog, waktu).sekarang;
    final jumlahMastered = data.jumlahBuktiAwal;
    final lulusMastery = data.hasilMastery.any((m) => m.lulus);

    bool syarat(String id) => switch (id) {
          'pemula' => data.progresLesson.values.any((p) => p.selesai),
          'rajin' => streakSekarang >= 3,
          'tekun' => streakSekarang >= 7,
          'cepat' => kejadian.lessonSelesai &&
              kejadian.durasi != null &&
              kejadian.durasi! <= AppConfig.batasLessonCepat,
          'teliti' => kejadian.lessonSelesai && kejadian.sempurna,
          'juara' => lulusMastery,
          'penjelajah' => jumlahMastered >= 3 && lulusMastery,
          'bintang' => level(data.xp) >= 5,
          _ => false,
        };

    return [
      for (final l in daftarLencana)
        if (!data.punyaLencana(l.id) && syarat(l.id)) l,
    ];
  }
}
