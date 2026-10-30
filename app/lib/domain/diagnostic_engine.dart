import '../core/config/app_config.dart';
import '../data/content/generator_soal.dart';
import '../data/content/paket_kelas.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/siswa.dart';
import '../data/models/soal.dart';
import '../data/models/topik.dart';
import '../data/models/sesi_soal.dart';

/// Hasil akhir diagnostic test yang siap disimpan.
class HasilAkhirDiagnostic {
  const HasilAkhirDiagnostic({
    required this.hasilPerTopik,
    required this.statusAwal,
    required this.kelas,
  });

  /// Hanya topik yang benar-benar diuji.
  final List<DiagnosticResult> hasilPerTopik;

  /// Status awal semua topik sebelum dibuka oleh SkillMapService.
  final Map<String, StatusTopik> statusAwal;
  final int kelas;
  KelompokKelas get kelompok => KelompokKelas.dariKelas(kelas);
}

/// Diagnostic test adaptif (FR-001, UC-001).
///
/// Tes dimulai dari topik awal kelas. Kalau siswa menjawab benar semua soal
/// di satu topik, tes naik ke topik berikutnya. Kalau salah di topik pertama, tes
/// turun ke topik sebelumnya. Dengan begitu anak tidak perlu mengerjakan soal di
/// semua topik, cukup di sekitar batas kemampuannya.
class SesiDiagnostic {
  factory SesiDiagnostic({
    required List<Topik> topik,
    required int kelas,
    GeneratorSoal? generator,
  }) {
    final sesi = SesiDiagnostic._(
      topik: topik,
      kelas: kelas,
      generator: generator,
    );
    sesi._soalSekarang = sesi._buatSoal();
    return sesi;
  }

  SesiDiagnostic._({
    required List<Topik> topik,
    required this.kelas,
    GeneratorSoal? generator,
  }) : _topik = [...topik]..sort((a, b) => a.urutan.compareTo(b.urutan)),
       _generator = generator ?? GeneratorSoal() {
    final idAwal = PaketKelas.untuk(kelas).topikAwal;
    _indeksAwal = _topik.indexWhere((t) => t.id == idAwal);
    if (_indeksAwal < 0) {
      throw ArgumentError('Topik awal $idAwal tidak tersedia.');
    }
    _indeks = _indeksAwal;
  }

  /// Replay hanya keputusan dari respons tersimpan; blok aktif tidak dibangkitkan ulang.
  factory SesiDiagnostic.pulihkan({
    required List<Topik> topik,
    required int kelas,
    required List<SesiSoal> blok,
    bool siapkanBerikutnya = false,
    GeneratorSoal? generator,
  }) {
    final sesi = SesiDiagnostic._(
      topik: topik,
      kelas: kelas,
      generator: generator,
    );
    if (blok.isEmpty || blok.length > AppConfig.maksTopikDiagnostic) {
      throw const FormatException('Jumlah blok diagnostic tidak sah.');
    }
    for (var i = 0; i < blok.length; i++) {
      final b = blok[i];
      if (sesi.selesai ||
          b.konteks != KonteksJawaban.diagnostic ||
          b.topikId != sesi.topikSekarang.id ||
          (!b.lengkap && i != blok.length - 1)) {
        throw const FormatException('Rute diagnostic tidak sesuai checkpoint.');
      }
      if (b.lengkap) sesi._catat(b.jawaban.where((j) => j.benar).length);
    }
    if (blok.last.lengkap && !sesi.selesai) {
      if (!siapkanBerikutnya) {
        throw const FormatException('Blok berikutnya belum tersimpan.');
      }
      sesi._soalSekarang = sesi._buatSoal();
    } else {
      sesi._soalSekarang = blok.last.soal;
    }
    return sesi;
  }

  final List<Topik> _topik;
  final GeneratorSoal _generator;
  final int kelas;
  late final int _indeksAwal;
  late int _indeks;
  bool _turun = false;
  bool _selesai = false;
  late List<Soal> _soalSekarang;
  final Map<String, DiagnosticResult> _hasil = {};

  bool get selesai => _selesai;
  Topik get topikSekarang => _topik[_indeks];
  List<Soal> get soalSekarang => _soalSekarang;
  int get jumlahTopikDiuji => _hasil.length;
  Map<String, DiagnosticResult> get hasilSementara => Map.unmodifiable(_hasil);

  List<Soal> _buatSoal() => _indeks == _indeksAwal
      ? PaketKelas.untuk(kelas).butirAwal
      : _generator.buat(
          _topik[_indeks].id,
          AppConfig.soalDiagnosticPerTopik,
          tingkat: 1,
        );

  /// Dipanggil setelah semua soal topik sekarang dijawab.
  void catat(int jumlahBenar) {
    _catat(jumlahBenar);
    if (!_selesai) _soalSekarang = _buatSoal();
  }

  void _catat(int jumlahBenar) {
    if (_selesai) return;
    final total = AppConfig.soalDiagnosticPerTopik;
    RangeError.checkValueInInterval(jumlahBenar, 0, total, 'jumlahBenar');
    final status = jumlahBenar == total
        ? StatusTopik.siapLanjut
        : StatusTopik.perluLatihan;
    _hasil[topikSekarang.id] = DiagnosticResult(
      topikId: topikSekarang.id,
      benar: jumlahBenar,
      total: total,
      statusPenguasaan: status,
    );

    final lulus = status == StatusTopik.siapLanjut;
    if (_hasil.length >= AppConfig.maksTopikDiagnostic) {
      _selesai = true;
    } else if (_turun) {
      // Sedang mencari batas bawah: berhenti begitu menemukan topik yang dikuasai.
      if (lulus || _indeks == 0) {
        _selesai = true;
      } else {
        _indeks--;
      }
    } else if (lulus) {
      if (_indeks == _topik.length - 1) {
        _selesai = true;
      } else {
        _indeks++;
      }
    } else if (_indeks == _indeksAwal && _indeks > 0) {
      _turun = true;
      _indeks--;
    } else {
      _selesai = true;
    }
  }

  HasilAkhirDiagnostic hasilAkhir() {
    if (!_selesai) throw StateError('Diagnostic belum selesai.');

    final status = <String, StatusTopik>{};
    for (var i = 0; i < _topik.length; i++) {
      final topik = _topik[i];
      final hasil = _hasil[topik.id];
      if (hasil != null) {
        status[topik.id] = hasil.statusPenguasaan;
      } else {
        status[topik.id] = StatusTopik.belumDiuji;
      }
    }

    return HasilAkhirDiagnostic(
      hasilPerTopik: _hasil.values.toList(),
      statusAwal: status,
      kelas: kelas,
    );
  }
}
