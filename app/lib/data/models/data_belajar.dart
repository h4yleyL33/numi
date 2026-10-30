import 'catatan_belajar.dart';
import 'companion_message.dart';
import 'siswa.dart';

/// Seluruh data milik satu siswa. Disimpan utuh oleh repository, dan menjadi
/// state utama yang dipegang NumiController.
class DataBelajar {
  const DataBelajar({
    this.siswa,
    this.skillMap = const {},
    this.hasilDiagnostic = const [],
    this.progresLesson = const {},
    this.riwayatJawaban = const [],
    this.hasilMastery = const [],
    this.lencana = const [],
    this.streakLog = const [],
    this.pesanMaskot = const [],
    this.xp = 0,
  });

  final Siswa? siswa;
  final Map<String, SkillMap> skillMap;
  final List<DiagnosticResult> hasilDiagnostic;
  final Map<String, LessonProgress> progresLesson;
  final List<Jawaban> riwayatJawaban;
  final List<MasteryResult> hasilMastery;
  final List<SiswaLencana> lencana;
  final List<StreakLog> streakLog;
  final List<CompanionMessage> pesanMaskot;
  final int xp;

  bool get sudahDaftar => siswa != null;
  bool get diagnosticSelesai => hasilDiagnostic.isNotEmpty;

  StatusTopik statusTopik(String topikId) =>
      skillMap[topikId]?.status ?? StatusTopik.terkunci;

  bool lessonSelesai(String lessonId) => progresLesson[lessonId]?.selesai ?? false;

  bool punyaLencana(String id) => lencana.any((l) => l.badgeId == id);

  DataBelajar copyWith({
    Siswa? siswa,
    Map<String, SkillMap>? skillMap,
    List<DiagnosticResult>? hasilDiagnostic,
    Map<String, LessonProgress>? progresLesson,
    List<Jawaban>? riwayatJawaban,
    List<MasteryResult>? hasilMastery,
    List<SiswaLencana>? lencana,
    List<StreakLog>? streakLog,
    List<CompanionMessage>? pesanMaskot,
    int? xp,
  }) {
    return DataBelajar(
      siswa: siswa ?? this.siswa,
      skillMap: skillMap ?? this.skillMap,
      hasilDiagnostic: hasilDiagnostic ?? this.hasilDiagnostic,
      progresLesson: progresLesson ?? this.progresLesson,
      riwayatJawaban: riwayatJawaban ?? this.riwayatJawaban,
      hasilMastery: hasilMastery ?? this.hasilMastery,
      lencana: lencana ?? this.lencana,
      streakLog: streakLog ?? this.streakLog,
      pesanMaskot: pesanMaskot ?? this.pesanMaskot,
      xp: xp ?? this.xp,
    );
  }

  Map<String, dynamic> toJson() => {
        'versi': 2,
        'siswa': siswa?.toJson(),
        'skillMap': skillMap.values.map((e) => e.toJson()).toList(),
        'hasilDiagnostic': hasilDiagnostic.map((e) => e.toJson()).toList(),
        'progresLesson': progresLesson.values.map((e) => e.toJson()).toList(),
        'riwayatJawaban': riwayatJawaban.map((e) => e.toJson()).toList(),
        'hasilMastery': hasilMastery.map((e) => e.toJson()).toList(),
        'lencana': lencana.map((e) => e.toJson()).toList(),
        'streakLog': streakLog.map((e) => e.toJson()).toList(),
        'pesanMaskot': pesanMaskot.map((e) => e.toJson()).toList(),
        'xp': xp,
      };

  factory DataBelajar.fromJson(Map<String, dynamic> json) {
    List<T> daftar<T>(String kunci, T Function(Map<String, dynamic>) ubah) =>
        (json[kunci] as List? ?? const [])
            .map((e) => ubah(Map<String, dynamic>.from(e as Map)))
            .toList();

    final skill = daftar('skillMap', SkillMap.fromJson);
    final lesson = daftar('progresLesson', LessonProgress.fromJson);
    return DataBelajar(
      siswa: json['siswa'] == null
          ? null
          : Siswa.fromJson(Map<String, dynamic>.from(json['siswa'] as Map)),
      skillMap: {for (final s in skill) s.topikId: s},
      hasilDiagnostic: daftar('hasilDiagnostic', DiagnosticResult.fromJson),
      progresLesson: {for (final l in lesson) l.lessonId: l},
      riwayatJawaban: daftar('riwayatJawaban', Jawaban.fromJson),
      hasilMastery: daftar('hasilMastery', MasteryResult.fromJson),
      lencana: daftar('lencana', SiswaLencana.fromJson),
      streakLog: daftar('streakLog', StreakLog.fromJson),
      pesanMaskot: daftar('pesanMaskot', CompanionMessage.fromJson),
      xp: json['xp'] as int? ?? 0,
    );
  }
}
