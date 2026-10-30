import '../content/daftar_topik.dart';
import '../content/generator_soal.dart';
import '../../domain/diagnostic_engine.dart';
import 'catatan_belajar.dart';
import 'sesi_soal.dart';

class CheckpointDiagnostic {
  CheckpointDiagnostic({
    required this.id,
    required this.kelas,
    required List<SesiSoal> blok,
    this.ditutup = false,
  }) : blok = List.unmodifiable(blok) {
    if (id.isEmpty ||
        blok.asMap().entries.any((e) => e.value.id != '$id/blok/${e.key}') ||
        blok.expand((b) => b.soal).map((s) => s.id).toSet().length !=
            blok.length * 2 ||
        blok.any((b) => b.hasil != null)) {
      throw const FormatException('Identitas blok diagnostic tidak sah.');
    }
    final alur = SesiDiagnostic.pulihkan(
      topik: daftarTopik,
      kelas: kelas,
      blok: blok,
    );
    if (ditutup && !alur.selesai) {
      throw const FormatException('Diagnostic belum lengkap.');
    }
  }
  final String id;
  final int kelas;
  final List<SesiSoal> blok;
  final bool ditutup;
  bool get lengkap => blok.last.lengkap;
  List<Jawaban> get jawaban => blok.expand((b) => b.jawaban).toList();

  factory CheckpointDiagnostic.mulai(String id, int kelas) {
    final alur = SesiDiagnostic(topik: daftarTopik, kelas: kelas);
    return CheckpointDiagnostic(
      id: id,
      kelas: kelas,
      blok: [
        SesiSoal(
          id: '$id/blok/0',
          topikId: alur.topikSekarang.id,
          soal: alur.soalSekarang,
          konteks: KonteksJawaban.diagnostic,
        ),
      ],
    );
  }

  CheckpointDiagnostic catat(
    String command,
    Jawaban j, {
    GeneratorSoal? generator,
  }) {
    final indeks = blok.indexWhere((b) => b.soal.any((s) => s.id == j.soalId));
    if (indeks < 0) throw StateError('Butir bukan bagian sesi diagnostic.');
    final baru = blok[indeks].catat(command, j);
    if (identical(baru, blok[indeks])) return this;
    if (ditutup || indeks != blok.length - 1) {
      throw StateError('Blok sudah ditutup.');
    }
    final semua = [...blok]..[indeks] = baru;
    if (baru.lengkap) {
      final alur = SesiDiagnostic.pulihkan(
        topik: daftarTopik,
        kelas: kelas,
        blok: semua,
        siapkanBerikutnya: true,
        generator: generator,
      );
      if (!alur.selesai) {
        semua.add(
          SesiSoal(
            id: '$id/blok/${semua.length}',
            topikId: alur.topikSekarang.id,
            soal: alur.soalSekarang,
            konteks: KonteksJawaban.diagnostic,
          ),
        );
      }
    }
    return CheckpointDiagnostic(id: id, kelas: kelas, blok: semua);
  }

  HasilAkhirDiagnostic hasilAkhir() => SesiDiagnostic.pulihkan(
    topik: daftarTopik,
    kelas: kelas,
    blok: blok,
  ).hasilAkhir();
  CheckpointDiagnostic tutup() =>
      CheckpointDiagnostic(id: id, kelas: kelas, blok: blok, ditutup: true);
  Map<String, dynamic> toJson() => {
    'id': id,
    'kelas': kelas,
    'versiKebijakan': 'numi-pilot-v1',
    'statusSimpan': 'lokal',
    'blok': blok.map((b) => b.toJson()).toList(),
    'ditutup': ditutup,
  };
  factory CheckpointDiagnostic.fromJson(Map<String, dynamic> j) {
    if (j['versiKebijakan'] != 'numi-pilot-v1' ||
        j['statusSimpan'] != 'lokal') {
      throw const FormatException(
        'Versi atau status diagnostic tidak didukung.',
      );
    }
    return CheckpointDiagnostic(
      id: j['id'] as String,
      kelas: j['kelas'] as int,
      blok: (j['blok'] as List)
          .map((b) => SesiSoal.fromJson(Map<String, dynamic>.from(b as Map)))
          .toList(),
      ditutup: j['ditutup'] as bool,
    );
  }
}
