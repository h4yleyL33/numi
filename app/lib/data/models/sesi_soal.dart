import 'catatan_belajar.dart';
import 'soal.dart';

/// Snapshot dan respons pertama dalam satu commit. Cursor diturunkan dari
/// panjang respons agar posisi dan respons tidak mungkin berbeda.
class SesiSoal {
  SesiSoal({
    required this.id,
    required this.topikId,
    required List<Soal> soal,
    List<Jawaban> jawaban = const [],
    this.hasil,
    this.konteks = KonteksJawaban.mastery,
    this.lessonId,
    this.mulaiPada,
    this.menungguLanjut = false,
  }) : soal = List.unmodifiable(soal),
       jawaban = List.unmodifiable(jawaban) {
    if (id.isEmpty ||
        soal.length != (konteks == KonteksJawaban.diagnostic ? 2 : 5) ||
        soal.map((s) => s.id).toSet().length != soal.length ||
        soal.any((s) => s.topikId != topikId || s.versi.isEmpty) ||
        jawaban.length > soal.length ||
        (hasil != null && (jawaban.length != soal.length || menungguLanjut)) ||
        (konteks == KonteksJawaban.lesson &&
            (lessonId == null || mulaiPada == null)) ||
        (konteks != KonteksJawaban.lesson &&
            (lessonId != null || menungguLanjut)) ||
        (menungguLanjut && jawaban.isEmpty)) {
      throw const FormatException('Snapshot sesi soal tidak sah.');
    }
    for (var i = 0; i < jawaban.length; i++) {
      _periksa(jawaban[i], i);
    }
  }

  final String id;
  final String topikId;
  final List<Soal> soal;
  final List<Jawaban> jawaban;
  final Map<String, dynamic>? hasil;
  final KonteksJawaban konteks;
  final String? lessonId;
  final DateTime? mulaiPada;
  final bool menungguLanjut;
  String get versiKebijakan => 'numi-pilot-v1';
  String get statusSimpan => 'lokal';
  bool get lengkap => jawaban.length == soal.length;
  bool get selesai => hasil != null;
  String commandId(int indeks) => '$id/respons/$indeks';

  void _periksa(Jawaban j, int indeks) {
    final s = soal[indeks];
    if (j.soalId != s.id ||
        j.topikId != topikId ||
        j.versiButir != s.versi ||
        j.skillId != s.skillId ||
        j.konteks != konteks ||
        j.bantuan < 0 ||
        j.benar != s.periksa(j.jawaban) ||
        (s.jenis != JenisSoal.pasangkan &&
            s.pilihan.isNotEmpty &&
            !s.pilihan.contains(j.jawaban))) {
      throw const FormatException('Respons tidak sesuai snapshot soal.');
    }
  }

  SesiSoal catat(String command, Jawaban j) {
    final indeks = soal.indexWhere((s) => s.id == j.soalId);
    if (indeks < 0 || command != commandId(indeks)) {
      throw StateError('Identitas perintah respons tidak sesuai.');
    }
    _periksa(j, indeks);
    if (indeks < jawaban.length) {
      final pertama = jawaban[indeks];
      if (pertama.jawaban != j.jawaban || pertama.bantuan != j.bantuan) {
        throw StateError('Jawaban pertama sudah tersimpan.');
      }
      return this;
    }
    if (selesai || menungguLanjut || indeks != jawaban.length) {
      throw StateError('Urutan respons tidak sesuai checkpoint.');
    }
    return SesiSoal(
      id: id,
      topikId: topikId,
      soal: soal,
      jawaban: [...jawaban, j],
      konteks: konteks,
      lessonId: lessonId,
      mulaiPada: mulaiPada,
      menungguLanjut: konteks == KonteksJawaban.lesson,
    );
  }

  SesiSoal lanjut(String command) {
    if (konteks != KonteksJawaban.lesson ||
        jawaban.isEmpty ||
        command != '$id/lanjut/${jawaban.length - 1}') {
      throw StateError('Perintah Lanjut tidak sesuai checkpoint.');
    }
    if (!menungguLanjut) return this;
    return SesiSoal(
      id: id,
      topikId: topikId,
      soal: soal,
      jawaban: jawaban,
      konteks: konteks,
      lessonId: lessonId,
      mulaiPada: mulaiPada,
    );
  }

  SesiSoal tutup(Map<String, dynamic> ringkasan) => SesiSoal(
    id: id,
    topikId: topikId,
    soal: soal,
    jawaban: jawaban,
    hasil: ringkasan,
    konteks: konteks,
    lessonId: lessonId,
    mulaiPada: mulaiPada,
    menungguLanjut: menungguLanjut,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'topikId': topikId,
    'versiKebijakan': versiKebijakan,
    'statusSimpan': statusSimpan,
    'soal': soal.map((s) => s.toJson()).toList(),
    'jawaban': jawaban.map((j) => j.toJson()).toList(),
    'hasil': hasil,
    'konteks': konteks.name,
    'lessonId': lessonId,
    'mulaiPada': mulaiPada?.toIso8601String(),
    'menungguLanjut': menungguLanjut,
  };

  factory SesiSoal.fromJson(Map<String, dynamic> j) {
    if (j['versiKebijakan'] != 'numi-pilot-v1' ||
        j['statusSimpan'] != 'lokal') {
      throw const FormatException('Versi atau status sesi tidak didukung.');
    }
    return SesiSoal(
      id: j['id'] as String,
      topikId: j['topikId'] as String,
      soal: (j['soal'] as List)
          .map((s) => Soal.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
      jawaban: (j['jawaban'] as List)
          .map((s) => Jawaban.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
      hasil: (j['hasil'] as Map?)?.cast<String, dynamic>(),
      konteks: KonteksJawaban.values.byName(
        j['konteks'] as String? ?? 'mastery',
      ),
      lessonId: j['lessonId'] as String?,
      mulaiPada: j['mulaiPada'] == null
          ? null
          : DateTime.parse(j['mulaiPada'] as String),
      menungguLanjut: j['menungguLanjut'] as bool? ?? false,
    );
  }
}
