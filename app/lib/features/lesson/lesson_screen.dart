import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/teks_matematika.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/content/generator_soal.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/companion_message.dart';
import '../../data/models/lesson.dart';
import '../../data/models/soal.dart';
import '../../state/numi_controller.dart';
import '../mascot/mascot_bubble.dart';
import '../quiz/pemutar_soal.dart';
import 'hasil_sesi_view.dart';

enum _Tahap { kenalan, soal, menyimpan, hasil }

/// UC-003 dan UC-004. Lesson kenalan dimulai dari penjelasan maskot yang dibuka
/// satu per satu, lalu lima soal dengan umpan balik langsung.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  final _generator = GeneratorSoal();
  late _Tahap _tahap = widget.lesson.tipe == TipeLesson.kenalan
      ? _Tahap.kenalan
      : _Tahap.soal;
  late List<Soal> _soal = _buatSoal();
  final _stopwatch = Stopwatch();
  RingkasanSesi? _ringkasan;
  int _percobaan = 0;

  List<Soal> _buatSoal() => _generator.buat(
    widget.lesson.topikId,
    AppConfig.soalPerLesson,
    tingkat: widget.lesson.tipe == TipeLesson.kenalan ? 1 : 2,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(numiControllerProvider.notifier)
          .mulaiLesson(widget.lesson.topikId);
    });
    if (_tahap == _Tahap.soal) _stopwatch.start();
  }

  Future<void> _selesai(List<Jawaban> jawaban) async {
    _stopwatch.stop();
    setState(() => _tahap = _Tahap.menyimpan);
    final ringkasan = await ref
        .read(numiControllerProvider.notifier)
        .selesaiLesson(widget.lesson, jawaban, _stopwatch.elapsed);
    if (!mounted) return;
    setState(() {
      _ringkasan = ringkasan;
      _tahap = _Tahap.hasil;
    });
  }

  void _ulangi() {
    setState(() {
      _percobaan++;
      _soal = _buatSoal();
      _tahap = _Tahap.soal;
      _stopwatch
        ..reset()
        ..start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topik = topikById(widget.lesson.topikId);
    return Scaffold(
      body: switch (_tahap) {
        _Tahap.kenalan => _Kenalan(
          lesson: widget.lesson,
          namaPulau: topik.namaPulau,
          onMulai: () => setState(() {
            _tahap = _Tahap.soal;
            _stopwatch.start();
          }),
        ),
        _Tahap.soal => SafeArea(
          child: PemutarSoal(
            key: ValueKey('lesson-$_percobaan'),
            soal: _soal,
            konteks: KonteksJawaban.lesson,
            judul: '${topik.namaPulau} · ${widget.lesson.judul}',
            onSelesai: _selesai,
          ),
        ),
        _Tahap.menyimpan => const Center(child: CircularProgressIndicator()),
        _Tahap.hasil => HasilSesiView(
          ringkasan: _ringkasan!,
          judul: _ringkasan!.lulus ? 'Lesson selesai!' : 'Sedikit lagi!',
          tombolUtama: _ringkasan!.lulus ? 'Kembali ke Peta' : 'Coba lagi',
          onUtama: _ringkasan!.lulus
              ? () => Navigator.of(context).pop()
              : _ulangi,
          tombolKedua: _ringkasan!.lulus ? null : 'Kembali ke Peta',
          onKedua: () => Navigator.of(context).pop(),
        ),
      },
    );
  }
}

class _Kenalan extends StatefulWidget {
  const _Kenalan({
    required this.lesson,
    required this.namaPulau,
    required this.onMulai,
  });

  final Lesson lesson;
  final String namaPulau;
  final VoidCallback onMulai;

  @override
  State<_Kenalan> createState() => _KenalanState();
}

class _KenalanState extends State<_Kenalan> {
  int _terbuka = 0;

  @override
  Widget build(BuildContext context) {
    final poin = widget.lesson.penjelasan;
    final habis = _terbuka >= poin.length - 1;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    widget.namaPulau,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: NumiWarna.tintaPudar,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    widget.lesson.judul,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  if (widget.lesson.contoh != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: NumiWarna.cahaya, width: 3),
                      ),
                      child: TeksMatematika(widget.lesson.contoh!, ukuran: 38),
                    ),
                  const SizedBox(height: 16),

                  for (var i = 0; i < _terbuka && i < poin.length; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: NumiWarna.benar,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              poin[i],
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  MascotBubble(
                    key: ValueKey(_terbuka),
                    teks: poin[_terbuka],
                    ukuranMaskot: 84,
                    ekspresi: habis
                        ? EkspresiMaskot.semangat
                        : EkspresiMaskot.senang,
                  ),
                ],
              ),
            ),
            TombolNumi(
              label: habis ? 'Ayo latihan!' : 'Lalu?',
              lebar: double.infinity,
              onTap: habis ? widget.onMulai : () => setState(() => _terbuka++),
            ),
          ],
        ),
      ),
    );
  }
}
