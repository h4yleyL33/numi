import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/kalimat_maskot.dart';
import '../../data/models/checkpoint_diagnostic.dart';
import '../../state/numi_controller.dart';
import '../quiz/pemutar_soal.dart';
import '../quiz/gagal_simpan_sesi.dart';
import 'diagnostic_result_screen.dart';

class DiagnosticScreen extends ConsumerStatefulWidget {
  const DiagnosticScreen({super.key});
  @override
  ConsumerState<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends ConsumerState<DiagnosticScreen> {
  CheckpointDiagnostic? _sesi;
  bool _menyimpan = true;
  bool _gagal = false;
  Future<void> Function()? _cobaLagi;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _siapkan());
  }

  Future<void> _jalankan(Future<void> Function() aksi) async {
    if (!mounted) return;
    setState(() {
      _menyimpan = true;
      _gagal = false;
    });
    try {
      await aksi();
    } catch (_) {
      if (mounted) {
        setState(() {
          _gagal = true;
          _menyimpan = false;
          _cobaLagi = () => _jalankan(aksi);
        });
      }
    }
  }

  Future<void> _siapkan() => _jalankan(() async {
    final sesi = await ref
        .read(numiControllerProvider.notifier)
        .mulaiDiagnostic();
    if (!mounted) return;
    _sesi = sesi;
    await _tampilkan();
  });

  Future<void> _tampilkan() async {
    if (_sesi!.lengkap) {
      final hasil = await ref
          .read(numiControllerProvider.notifier)
          .finalisasiDiagnostic(_sesi!.id);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        transisiPudar(DiagnosticResultScreen(hasil: hasil, blok: _sesi!.blok)),
        (_) => false,
      );
    } else if (mounted) {
      setState(() => _menyimpan = false);
    }
  }

  Future<void> _topikSelesai() => _jalankan(() async {
    _sesi = ref.read(numiControllerProvider).sesiDiagnostic!;
    await _tampilkan();
  });

  @override
  Widget build(BuildContext context) {
    final sesi = _sesi;
    final blok = sesi?.blok.last;
    return Scaffold(
      body: _gagal
          ? GagalSimpanSesi(onCobaLagi: _cobaLagi!)
          : _menyimpan
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: PemutarSoal(
                key: ValueKey(blok!.id),
                soal: blok.soal,
                jawabanAwal: blok.jawaban,
                konteks: blok.konteks,
                umpanBalik: false,
                nomorAwal:
                    (sesi!.blok.length - 1) * AppConfig.soalDiagnosticPerTopik,
                perkiraanTotal:
                    AppConfig.maksTopikDiagnostic *
                    AppConfig.soalDiagnosticPerTopik,
                judul:
                    'Numi: ${kalimatDiagnostic[(sesi.blok.length - 1) % kalimatDiagnostic.length]}',
                simpanJawaban: (j) => ref
                    .read(numiControllerProvider.notifier)
                    .jawabDiagnostic(
                      sesi.id,
                      blok.commandId(
                        blok.soal.indexWhere((s) => s.id == j.soalId),
                      ),
                      j,
                    ),
                onSelesai: (_) => _topikSelesai(),
              ),
            ),
    );
  }
}
