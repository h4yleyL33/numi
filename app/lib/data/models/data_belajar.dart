import 'catatan_belajar.dart';
import 'companion_message.dart';
import 'siswa.dart';
import 'bukti_skill.dart';
import 'sesi_mastery.dart';
import 'checkpoint_diagnostic.dart';

/// Seluruh data milik satu siswa. Disimpan utuh oleh repository, dan menjadi
/// state utama yang dipegang NumiController.
class DataBelajar {
  const DataBelajar({
    this.siswa,
    this.skillMap = const {},
    this.buktiSkill = const {},
    this.aksesMateri = const {},
    this.sesiMastery = const {},
    this.sesiLesson = const {},
    this.sesiDiagnostic,
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
  final Map<String, BuktiSkill> buktiSkill;
  final Map<String, AksesMateri> aksesMateri;
  final Map<String, SesiMastery> sesiMastery;
  final Map<String, SesiSoal> sesiLesson;
  final CheckpointDiagnostic? sesiDiagnostic;
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
  bool get perluDiagnostic =>
      sesiDiagnostic?.ditutup == false ||
      !diagnosticSelesai ||
      buktiSkill.isEmpty;

  StatusTopik statusTopik(String topikId) {
    final akses = aksesMateri[topikId];
    if (akses?.tersedia == false) return StatusTopik.belumTersedia;
    if (akses?.terbuka == false ||
        (akses == null &&
            (skillMap[topikId]?.status ?? StatusTopik.terkunci) ==
                StatusTopik.terkunci)) {
      return StatusTopik.terkunci;
    }
    return switch (buktiSkill[topikId]?.status) {
      StatusBukti.buktiAwal => StatusTopik.mastered,
      StatusBukti.indikasiSiap => StatusTopik.siapLanjut,
      StatusBukti.indikasiLatihan => StatusTopik.perluLatihan,
      null => StatusTopik.belumDiuji,
    };
  }

  int get jumlahBuktiAwal =>
      buktiSkill.values.where((b) => b.status == StatusBukti.buktiAwal).length;

  bool lessonSelesai(String lessonId) =>
      progresLesson[lessonId]?.selesai ?? false;

  bool punyaLencana(String id) => lencana.any((l) => l.badgeId == id);

  DataBelajar copyWith({
    Siswa? siswa,
    Map<String, SkillMap>? skillMap,
    Map<String, BuktiSkill>? buktiSkill,
    Map<String, AksesMateri>? aksesMateri,
    Map<String, SesiMastery>? sesiMastery,
    Map<String, SesiSoal>? sesiLesson,
    CheckpointDiagnostic? sesiDiagnostic,
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
      buktiSkill: buktiSkill ?? this.buktiSkill,
      aksesMateri: aksesMateri ?? this.aksesMateri,
      sesiMastery: sesiMastery ?? this.sesiMastery,
      sesiLesson: sesiLesson ?? this.sesiLesson,
      sesiDiagnostic: sesiDiagnostic ?? this.sesiDiagnostic,
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
    'versi': 5,
    'sesiLesson': sesiLesson.values.map((s) => s.toJson()).toList(),
    'sesiDiagnostic': sesiDiagnostic?.toJson(),
    'sesiMastery': sesiMastery.values.map((s) => s.toJson()).toList(),
    'buktiSkill': buktiSkill.values.map((e) => e.toJson()).toList(),
    'aksesMateri': aksesMateri.values.map((e) => e.toJson()).toList(),
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
    final bukti = daftar('buktiSkill', BuktiSkill.fromJson);
    final akses = daftar('aksesMateri', AksesMateri.fromJson);
    final sesi = daftar('sesiMastery', SesiMastery.fromJson);
    final sesiLesson = daftar('sesiLesson', SesiSoal.fromJson);
    if (sesi.any((s) => s.konteks != KonteksJawaban.mastery) ||
        sesiLesson.any((s) => s.konteks != KonteksJawaban.lesson) ||
        sesiLesson.map((s) => s.lessonId).toSet().length != sesiLesson.length ||
        sesi.map((s) => s.topikId).toSet().length != sesi.length) {
      throw const FormatException('Checkpoint topik duplikat.');
    }
    final lesson = daftar('progresLesson', LessonProgress.fromJson);
    return DataBelajar(
      siswa: json['siswa'] == null
          ? null
          : Siswa.fromJson(Map<String, dynamic>.from(json['siswa'] as Map)),
      skillMap: {for (final s in skill) s.topikId: s},
      buktiSkill: {for (final b in bukti) b.topikId: b},
      aksesMateri: {for (final a in akses) a.topikId: a},
      sesiMastery: {for (final s in sesi) s.topikId: s},
      sesiLesson: {for (final s in sesiLesson) s.lessonId!: s},
      sesiDiagnostic: json['sesiDiagnostic'] == null
          ? null
          : CheckpointDiagnostic.fromJson(
              Map<String, dynamic>.from(json['sesiDiagnostic'] as Map),
            ),
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
