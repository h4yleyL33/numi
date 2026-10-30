import '../core/config/app_config.dart';
import '../data/content/generator_soal.dart';
import '../data/content/paket_kelas.dart';
import '../data/models/catatan_belajar.dart';
import '../data/models/siswa.dart';
import '../data/models/soal.dart';
import '../data/models/topik.dart';

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
  SesiDiagnostic({
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
    _soalSekarang = _buatSoal();
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

  List<Soal> _buatSoal() => _generator.buat(
    _topik[_indeks].id,
    AppConfig.soalDiagnosticPerTopik,
    tingkat: 1,
  );

  /// Dipanggil setelah semua soal topik sekarang dijawab.
  void catat(int jumlahBenar) {
    if (_selesai) return;
    final total = _soalSekarang.length;
    final status = jumlahBenar == total
        ? StatusTopik.mastered
        : (jumlahBenar > 0
              ? StatusTopik.perluLatihan
              : StatusTopik.belumDikuasai);
    _hasil[topikSekarang.id] = DiagnosticResult(
      topikId: topikSekarang.id,
      benar: jumlahBenar,
      total: total,
      statusPenguasaan: status,
    );

    final lulus = status == StatusTopik.mastered;
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

    if (!_selesai) _soalSekarang = _buatSoal();
  }

  HasilAkhirDiagnostic hasilAkhir() {
    final diuji = _hasil.keys.map((id) => _topik.indexWhere((t) => t.id == id));
    final terendah = diuji.reduce((a, b) => a < b ? a : b);

    final status = <String, StatusTopik>{};
    for (var i = 0; i < _topik.length; i++) {
      final topik = _topik[i];
      final hasil = _hasil[topik.id];
      if (hasil != null) {
        status[topik.id] = hasil.statusPenguasaan;
      } else if (i < terendah) {
        // shortcut: inferensi topik lama, ganti dengan bukti belum diuji pada I07.
        status[topik.id] = StatusTopik.mastered;
      } else {
        status[topik.id] = StatusTopik.terkunci;
      }
    }

    return HasilAkhirDiagnostic(
      hasilPerTopik: _hasil.values.toList(),
      statusAwal: status,
      kelas: kelas,
    );
  }
}
