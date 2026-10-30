import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/pulau_hias.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/content/generator_soal.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/companion_message.dart';
import '../../data/models/soal.dart';
import '../../data/models/sesi_mastery.dart';
import '../../data/models/topik.dart';
import '../../state/numi_controller.dart';
import '../lesson/hasil_sesi_view.dart';
import '../mascot/mascot_bubble.dart';
import '../quiz/pemutar_soal.dart';

enum _Tahap { pembuka, soal, menyimpan, gagal, hasil }

/// UC-005. Lima respons benar tanpa bantuan menjadi bukti awal pada sampel.
class MasteryScreen extends ConsumerStatefulWidget {
  const MasteryScreen({super.key, required this.topik});

  final Topik topik;

  @override
  ConsumerState<MasteryScreen> createState() => _MasteryScreenState();
}

class _MasteryScreenState extends ConsumerState<MasteryScreen> {
  _Tahap _tahap = _Tahap.pembuka;
  List<Soal>? _soalBaru;
  SesiMastery? _sesi;
  RingkasanSesi? _ringkasan;
  Future<void> Function()? _cobaLagi;

  @override
  void initState() {
    super.initState();
    _sesi = ref.read(numiControllerProvider).sesiMastery[widget.topik.id];
    if (_sesi?.hasil case final hasil?) {
      _ringkasan = RingkasanSesi.fromJson(hasil);
      _tahap = _Tahap.hasil;
    }
  }

  Future<void> _mulai() async {
    setState(() => _tahap = _Tahap.menyimpan);
    try {
      _soalBaru ??= (_sesi != null && !_sesi!.selesai)
          ? _sesi!.soal
          : GeneratorSoal().buat(
              widget.topik.id,
              AppConfig.soalMastery,
              tingkat: 2,
            );
      final sesi = await ref
          .read(numiControllerProvider.notifier)
          .mulaiMastery(widget.topik.id, _soalBaru!);
      if (!mounted) return;
      _sesi = sesi;
      if (sesi.lengkap) {
        await _selesai(sesi.jawaban);
      } else {
        setState(() => _tahap = _Tahap.soal);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _cobaLagi = _mulai;
          _tahap = _Tahap.gagal;
        });
      }
    }
  }

  Future<void> _selesai(List<Jawaban> jawaban) async {
    setState(() => _tahap = _Tahap.menyimpan);
    try {
      final r = await ref
          .read(numiControllerProvider.notifier)
          .finalisasiMastery(widget.topik.id, _sesi!.id);
      if (!mounted) return;
      setState(() {
        _ringkasan = r;
        _tahap = _Tahap.hasil;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _cobaLagi = () => _selesai(jawaban);
          _tahap = _Tahap.gagal;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.topik;
    return Scaffold(
      body: switch (_tahap) {
        _Tahap.pembuka => LatarMalam(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.close_rounded, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                  const PulauHias(menyala: false, ukuran: 130),
                  Text(
                    'Mercusuar ${t.namaPulau}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_sesi != null && !_sesi!.selesai)
                    Text(
                      '${_sesi!.jawaban.length}/5 jawaban tersimpan di perangkat ini.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  const MascotBubble(
                    gelap: true,
                    ekspresi: EkspresiMaskot.semangat,
                    teks:
                        'Jawab ${AppConfig.soalMastery} soal sendiri. '
                        'Hasil 5 dari 5 memberi bukti awal pada sampel ini.',
                  ),
                  const Spacer(),
                  TombolNumi(
                    label: _sesi != null && !_sesi!.selesai
                        ? 'Lanjutkan test'
                        : 'Nyalakan!',
                    lebar: double.infinity,
                    onTap: _mulai,
                  ),
                ],
              ),
            ),
          ),
        ),
        _Tahap.soal => SafeArea(
          child: PemutarSoal(
            soal: _sesi!.soal,
            jawabanAwal: _sesi!.jawaban,
            konteks: KonteksJawaban.mastery,
            simpanJawaban: (j) {
              final indeks = _sesi!.soal.indexWhere((s) => s.id == j.soalId);
              return ref
                  .read(numiControllerProvider.notifier)
                  .jawabMastery(t.id, _sesi!.id, _sesi!.commandId(indeks), j);
            },
            judul: 'Mastery Test · ${t.namaPulau}',
            onSelesai: _selesai,
          ),
        ),
        _Tahap.menyimpan => const Center(child: CircularProgressIndicator()),
        _Tahap.gagal => SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sesi belum berhasil disimpan. Coba lagi. '
                    'Jika tetap gagal, buka ulang profil untuk memuat data terbaru.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TombolNumi(label: 'Coba simpan lagi', onTap: _cobaLagi),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali ke Peta'),
                  ),
                ],
              ),
            ),
          ),
        ),
        _Tahap.hasil => HasilSesiView(
          catatan:
              'Hasil dan XP sesi ini sudah tersimpan di perangkat ini. '
              'Membuka hasil kembali tidak menambah XP.',
          ringkasan: _ringkasan!,
          hiasan: PulauHias(menyala: _ringkasan!.lulus, ukuran: 110),
          judul: _ringkasan!.lulus ? 'Mercusuar menyala!' : 'Belum menyala',
          tombolUtama: 'Kembali ke Peta',
          onUtama: () => Navigator.of(context).pop(),
          tombolKedua: 'Mulai test baru',
          onKedua: () {
            _soalBaru = null;
            _sesi = null;
            _mulai();
          },
        ),
      },
    );
  }
}
