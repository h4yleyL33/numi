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
import '../../data/models/topik.dart';
import '../../state/numi_controller.dart';
import '../lesson/hasil_sesi_view.dart';
import '../mascot/mascot_bubble.dart';
import '../quiz/pemutar_soal.dart';

enum _Tahap { pembuka, soal, menyimpan, hasil }

/// UC-005. Lulus kalau skor mencapai AppConfig.masteryThreshold.
class MasteryScreen extends ConsumerStatefulWidget {
  const MasteryScreen({super.key, required this.topik});

  final Topik topik;

  @override
  ConsumerState<MasteryScreen> createState() => _MasteryScreenState();
}

class _MasteryScreenState extends ConsumerState<MasteryScreen> {
  _Tahap _tahap = _Tahap.pembuka;
  late final List<Soal> _soal = GeneratorSoal().buat(widget.topik.id, AppConfig.soalMastery, tingkat: 2);
  RingkasanSesi? _ringkasan;

  Future<void> _selesai(List<Jawaban> jawaban) async {
    setState(() => _tahap = _Tahap.menyimpan);
    final r = await ref.read(numiControllerProvider.notifier).selesaiMastery(widget.topik.id, jawaban);
    if (!mounted) return;
    setState(() {
      _ringkasan = r;
      _tahap = _Tahap.hasil;
    });
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
                    Text('Mercusuar ${t.namaPulau}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 20),
                    const MascotBubble(
                      gelap: true,
                      ekspresi: EkspresiMaskot.semangat,
                      teks: 'Jawab ${AppConfig.soalMastery} soal. Kalau skormu mencapai '
                          '${AppConfig.masteryThreshold}, mercusuarnya akan menyala!',
                    ),
                    const Spacer(),
                    TombolNumi(
                      label: 'Nyalakan!',
                      lebar: double.infinity,
                      onTap: () => setState(() => _tahap = _Tahap.soal),
                    ),
                  ],
                ),
              ),
            ),
          ),
        _Tahap.soal => SafeArea(
            child: PemutarSoal(
              soal: _soal,
              konteks: KonteksJawaban.mastery,
              judul: 'Mastery Test · ${t.namaPulau}',
              onSelesai: _selesai,
            ),
          ),
        _Tahap.menyimpan => const Center(child: CircularProgressIndicator()),
        _Tahap.hasil => HasilSesiView(
            ringkasan: _ringkasan!,
            hiasan: PulauHias(menyala: _ringkasan!.lulus, ukuran: 110),
            judul: _ringkasan!.lulus ? 'Mercusuar menyala!' : 'Belum menyala',
            tombolUtama: 'Kembali ke Peta',
            onUtama: () => Navigator.of(context).pop(),
          ),
      },
    );
  }
}
