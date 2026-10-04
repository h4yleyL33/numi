import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/content/kalimat_maskot.dart';
import '../../data/models/catatan_belajar.dart';
import '../../domain/diagnostic_engine.dart';
import '../../state/numi_controller.dart';
import '../quiz/pemutar_soal.dart';
import 'diagnostic_result_screen.dart';

/// UC-001. Soal diambil per topik dari SesiDiagnostic; setelah dua soal satu
/// topik terjawab, sesi memutuskan naik, turun, atau selesai.
class DiagnosticScreen extends ConsumerStatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  ConsumerState<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends ConsumerState<DiagnosticScreen> {
  late final SesiDiagnostic _sesi = SesiDiagnostic(
    topik: daftarTopik,
    usia: ref.read(numiControllerProvider).siswa!.usia,
  );
  final _semuaJawaban = <Jawaban>[];
  bool _menyimpan = false;

  Future<void> _topikSelesai(List<Jawaban> jawaban) async {
    _semuaJawaban.addAll(jawaban);
    _sesi.catat(jawaban.where((j) => j.benar).length);
    if (!_sesi.selesai) {
      setState(() {});
      return;
    }
    setState(() => _menyimpan = true);
    final hasil = _sesi.hasilAkhir();
    await ref.read(numiControllerProvider.notifier).simpanDiagnostic(hasil, _semuaJawaban);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      transisiPudar(DiagnosticResultScreen(hasil: hasil)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sudah = _semuaJawaban.length;
    return Scaffold(
      body: SafeArea(
        child: _menyimpan
            ? const Center(child: CircularProgressIndicator())
            : PemutarSoal(
                key: ValueKey(_sesi.topikSekarang.id),
                soal: _sesi.soalSekarang,
                konteks: KonteksJawaban.diagnostic,
                umpanBalik: false,
                nomorAwal: sudah,
                perkiraanTotal: AppConfig.maksTopikDiagnostic * AppConfig.soalDiagnosticPerTopik,
                judul: 'Numi: ${kalimatDiagnostic[_sesi.jumlahTopikDiuji % kalimatDiagnostic.length]}',
                onSelesai: _topikSelesai,
              ),
      ),
    );
  }
}
