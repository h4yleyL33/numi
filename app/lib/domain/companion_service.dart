import 'dart:math';

import '../core/utils/tanggal.dart';
import '../data/content/kalimat_maskot.dart';
import '../data/models/companion_message.dart';
import '../data/models/data_belajar.dart';
import 'progress_service.dart';

/// Menentukan kapan dan apa yang diucapkan maskot (FR-009, UC-007).
class CompanionService {
  CompanionService({this.progress = const ProgressService(), Random? rng}) : _rng = rng ?? Random();

  final ProgressService progress;
  final Random _rng;

  /// Diperiksa setiap kali aplikasi dibuka. Satu jenis pesan paling banyak
  /// muncul sekali sehari supaya maskot tidak cerewet.
  CompanionMessage? periksaSaatMembuka(DataBelajar data, DateTime sekarang) {
    final siswa = data.siswa;
    if (siswa == null || !data.diagnosticSelesai) return null;

    final JenisTrigger jenis;
    final terakhir = data.streakLog.isEmpty
        ? null
        : data.streakLog.map((l) => dariKunciTanggal(l.tanggal)).reduce((a, b) => a.isAfter(b) ? a : b);
    final info = progress.streak(data.streakLog, sekarang);

    if (terakhir != null && selisihHari(terakhir, sekarang) >= 3) {
      jenis = JenisTrigger.lamaTidakAktif;
    } else if (info.terancam) {
      jenis = JenisTrigger.streakTerancam;
    } else {
      jenis = JenisTrigger.sambutan;
    }

    final hariIni = kunciTanggal(sekarang);
    final sudahMuncul = data.pesanMaskot.any(
      (p) => p.trigger == jenis && kunciTanggal(p.waktuKirim) == hariIni,
    );
    if (sudahMuncul) return null;
    return buat(jenis, siswa.namaPanggilan, sekarang);
  }

  CompanionMessage buat(JenisTrigger jenis, String nama, DateTime waktu) {
    final kalimat = kalimatMaskot[jenis]!;
    final isi = kalimat.variasi[_rng.nextInt(kalimat.variasi.length)].replaceAll('{nama}', nama);
    return CompanionMessage(
      id: '${jenis.name}-${waktu.microsecondsSinceEpoch}',
      trigger: jenis,
      isi: isi,
      ekspresi: kalimat.ekspresi,
      waktuKirim: waktu,
    );
  }
}
