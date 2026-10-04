// Entitas yang mencatat jejak belajar siswa. Nama kelas mengikuti ERD di doktek
// bagian 2.4, ditambah MasteryResult untuk FR-007 yang belum ada di ERD awal.

enum KonteksJawaban { diagnostic, lesson, mastery }

/// Status topik di skill map (STATE-001).
enum StatusTopik {
  terkunci('Terkunci'),
  belumDikuasai('Belum dikuasai'),
  perluLatihan('Perlu latihan'),
  mastered('Dikuasai');

  const StatusTopik(this.label);
  final String label;
}

/// Entitas Jawaban (DATA-005).
class Jawaban {
  const Jawaban({
    required this.soalId,
    required this.topikId,
    required this.jawaban,
    required this.benar,
    required this.waktu,
    required this.konteks,
  });

  final String soalId;
  final String topikId;
  final String jawaban;
  final bool benar;
  final DateTime waktu;
  final KonteksJawaban konteks;

  Map<String, dynamic> toJson() => {
        'soalId': soalId,
        'topikId': topikId,
        'jawaban': jawaban,
        'benar': benar,
        'waktu': waktu.toIso8601String(),
        'konteks': konteks.name,
      };

  factory Jawaban.fromJson(Map<String, dynamic> json) => Jawaban(
        soalId: json['soalId'] as String,
        topikId: json['topikId'] as String,
        jawaban: json['jawaban'] as String,
        benar: json['benar'] as bool,
        waktu: DateTime.parse(json['waktu'] as String),
        konteks: KonteksJawaban.values.byName(json['konteks'] as String),
      );
}

/// Entitas SkillMap: status satu topik untuk satu siswa.
class SkillMap {
  const SkillMap({required this.topikId, required this.status, required this.diperbarui});

  final String topikId;
  final StatusTopik status;
  final DateTime diperbarui;

  Map<String, dynamic> toJson() => {
        'topikId': topikId,
        'status': status.name,
        'diperbarui': diperbarui.toIso8601String(),
      };

  factory SkillMap.fromJson(Map<String, dynamic> json) => SkillMap(
        topikId: json['topikId'] as String,
        status: StatusTopik.values.byName(json['status'] as String),
        diperbarui: DateTime.parse(json['diperbarui'] as String),
      );
}

/// Entitas DiagnosticResult (DATA-003): hasil diagnostic per topik yang diuji.
class DiagnosticResult {
  const DiagnosticResult({
    required this.topikId,
    required this.benar,
    required this.total,
    required this.statusPenguasaan,
  });

  final String topikId;
  final int benar;
  final int total;
  final StatusTopik statusPenguasaan;

  int get skor => total == 0 ? 0 : (benar * 100 / total).round();

  Map<String, dynamic> toJson() => {
        'topikId': topikId,
        'benar': benar,
        'total': total,
        'statusPenguasaan': statusPenguasaan.name,
      };

  factory DiagnosticResult.fromJson(Map<String, dynamic> json) => DiagnosticResult(
        topikId: json['topikId'] as String,
        benar: json['benar'] as int,
        total: json['total'] as int,
        statusPenguasaan: StatusTopik.values.byName(json['statusPenguasaan'] as String),
      );
}

/// Entitas LessonProgress.
class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.topikId,
    required this.selesai,
    required this.skorTerbaik,
    required this.jumlahPercobaan,
    required this.waktu,
  });

  final String lessonId;
  final String topikId;
  final bool selesai;
  final int skorTerbaik;
  final int jumlahPercobaan;
  final DateTime waktu;

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'topikId': topikId,
        'selesai': selesai,
        'skorTerbaik': skorTerbaik,
        'jumlahPercobaan': jumlahPercobaan,
        'waktu': waktu.toIso8601String(),
      };

  factory LessonProgress.fromJson(Map<String, dynamic> json) => LessonProgress(
        lessonId: json['lessonId'] as String,
        topikId: json['topikId'] as String,
        selesai: json['selesai'] as bool,
        skorTerbaik: json['skorTerbaik'] as int,
        jumlahPercobaan: json['jumlahPercobaan'] as int,
        waktu: DateTime.parse(json['waktu'] as String),
      );
}

/// Entitas MasteryResult: satu kali percobaan mastery test (FR-007).
class MasteryResult {
  const MasteryResult({
    required this.topikId,
    required this.skor,
    required this.lulus,
    required this.waktu,
  });

  final String topikId;
  final int skor;
  final bool lulus;
  final DateTime waktu;

  Map<String, dynamic> toJson() => {
        'topikId': topikId,
        'skor': skor,
        'lulus': lulus,
        'waktu': waktu.toIso8601String(),
      };

  factory MasteryResult.fromJson(Map<String, dynamic> json) => MasteryResult(
        topikId: json['topikId'] as String,
        skor: json['skor'] as int,
        lulus: json['lulus'] as bool,
        waktu: DateTime.parse(json['waktu'] as String),
      );
}

/// Entitas Siswa_Badge di ERD: lencana yang sudah diperoleh siswa.
class SiswaLencana {
  const SiswaLencana({required this.badgeId, required this.waktuDiperoleh});

  final String badgeId;
  final DateTime waktuDiperoleh;

  Map<String, dynamic> toJson() => {
        'badgeId': badgeId,
        'waktuDiperoleh': waktuDiperoleh.toIso8601String(),
      };

  factory SiswaLencana.fromJson(Map<String, dynamic> json) => SiswaLencana(
        badgeId: json['badgeId'] as String,
        waktuDiperoleh: DateTime.parse(json['waktuDiperoleh'] as String),
      );
}

/// Entitas StreakLog: satu baris per hari siswa aktif belajar.
class StreakLog {
  const StreakLog({required this.tanggal, required this.jumlahAktivitas});

  /// Format `yyyy-mm-dd`.
  final String tanggal;
  final int jumlahAktivitas;

  Map<String, dynamic> toJson() => {'tanggal': tanggal, 'jumlahAktivitas': jumlahAktivitas};

  factory StreakLog.fromJson(Map<String, dynamic> json) => StreakLog(
        tanggal: json['tanggal'] as String,
        jumlahAktivitas: json['jumlahAktivitas'] as int,
      );
}
