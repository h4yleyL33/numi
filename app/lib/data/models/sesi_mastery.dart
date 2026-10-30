import 'catatan_belajar.dart';
import 'soal.dart';

/// Snapshot dan respons pertama dalam satu commit. Cursor diturunkan dari
/// panjang respons agar posisi dan respons tidak mungkin berbeda.
class SesiMastery {
  SesiMastery({
    required this.id,
    required this.topikId,
    required List<Soal> soal,
    List<Jawaban> jawaban = const [],
    this.hasil,
  }) : soal = List.unmodifiable(soal),
       jawaban = List.unmodifiable(jawaban) {
    if (id.isEmpty ||
        soal.length != 5 ||
        soal.map((s) => s.id).toSet().length != 5 ||
        soal.any((s) => s.topikId != topikId || s.versi.isEmpty) ||
        jawaban.length > soal.length ||
        (hasil != null && jawaban.length != 5)) {
      throw const FormatException('Snapshot mastery tidak sah.');
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
        j.konteks != KonteksJawaban.mastery ||
        j.bantuan < 0 ||
        j.benar != s.periksa(j.jawaban) ||
        (s.jenis != JenisSoal.pasangkan &&
            s.pilihan.isNotEmpty &&
            !s.pilihan.contains(j.jawaban))) {
      throw const FormatException('Respons tidak sesuai snapshot soal.');
    }
  }

  SesiMastery catat(String command, Jawaban j) {
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
    if (selesai || indeks != jawaban.length) {
      throw StateError('Urutan respons tidak sesuai checkpoint.');
    }
    return SesiMastery(
      id: id,
      topikId: topikId,
      soal: soal,
      jawaban: [...jawaban, j],
    );
  }

  SesiMastery tutup(Map<String, dynamic> ringkasan) => SesiMastery(
    id: id,
    topikId: topikId,
    soal: soal,
    jawaban: jawaban,
    hasil: ringkasan,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'topikId': topikId,
    'versiKebijakan': versiKebijakan,
    'statusSimpan': statusSimpan,
    'soal': soal.map((s) => s.toJson()).toList(),
    'jawaban': jawaban.map((j) => j.toJson()).toList(),
    'hasil': hasil,
  };

  factory SesiMastery.fromJson(Map<String, dynamic> j) {
    if (j['versiKebijakan'] != 'numi-pilot-v1' ||
        j['statusSimpan'] != 'lokal') {
      throw const FormatException('Versi atau status sesi tidak didukung.');
    }
    return SesiMastery(
      id: j['id'] as String,
      topikId: j['topikId'] as String,
      soal: (j['soal'] as List)
          .map((s) => Soal.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
      jawaban: (j['jawaban'] as List)
          .map((s) => Jawaban.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
      hasil: (j['hasil'] as Map?)?.cast<String, dynamic>(),
    );
  }
}
