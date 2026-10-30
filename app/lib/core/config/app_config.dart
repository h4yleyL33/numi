/// Angka-angka aturan belajar dikumpulkan di sini supaya mudah diubah tim
/// tanpa mencari ke seluruh kode.
class AppConfig {
  AppConfig._();

  /// Referensi rancangan awal. Kebijakan bukti pilot sekarang 5/5 mandiri;
  /// keputusan bukti ada pada NumiController, bukan dari ambang skor ini.
  static const int masteryThreshold = 95;

  static const int soalPerLesson = 5;

  /// Jumlah jawaban benar minimal supaya lesson dianggap selesai (UC-003 alur alternatif).
  static const int minBenarLesson = 3;

  static const int soalMastery = 5;

  static const int soalDiagnosticPerTopik = 2;

  /// Batas topik yang diuji saat diagnostic supaya tes tidak terlalu panjang untuk anak.
  static const int maksTopikDiagnostic = 6;

  static const int xpPerBenar = 10;
  static const int xpLessonSelesai = 20;
  static const int xpMasteryLulus = 50;
  static const int xpPerLevel = 100;

  /// Lesson yang selesai di bawah durasi ini membuka badge Cepat.
  static const Duration batasLessonCepat = Duration(minutes: 2);

  /// Riwayat jawaban yang disimpan di perangkat dibatasi agar data tidak membengkak.
  static const int maksRiwayatJawaban = 300;
}
