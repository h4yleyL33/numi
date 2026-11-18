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
import '../../data/models/sesi_soal.dart';
import '../quiz/gagal_simpan_sesi.dart';
import '../../state/numi_controller.dart';
import '../mascot/mascot_bubble.dart';
import '../quiz/pemutar_soal.dart';
import 'hasil_sesi_view.dart';

enum _Tahap { kenalan, soal, menyimpan, gagal, hasil }

/// UC-003 dan UC-004. Lesson kenalan dimulai dari penjelasan maskot yang dibuka
/// satu per satu, lalu lima soal dengan umpan balik langsung.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lesson, this.latihanUlang = false});

  final Lesson lesson;
  final bool latihanUlang;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  _Tahap _tahap = _Tahap.menyimpan;
  SesiSoal? _sesi;
  List<Soal>? _soalBaru;
  RingkasanSesi? _ringkasan;
  Future<void> Function()? _cobaLagi;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _siapkan());
  }

  Future<void> _jalankan(Future<void> Function() aksi) async {
    if (!mounted) return;
    setState(() => _tahap = _Tahap.menyimpan);
    try {
      await aksi();
    } catch (_) {
      if (mounted) {
        setState(() {
          _tahap = _Tahap.gagal;
          _cobaLagi = () => _jalankan(aksi);
        });
      }
    }
  }

  Future<void> _siapkan() => _jalankan(() async {
    _sesi = ref.read(numiControllerProvider).sesiLesson[widget.lesson.id];
    if (widget.latihanUlang && _sesi?.selesai == true) {
      await _buatSesi();
    } else if (_sesi != null) {
      await _tampilkan();
    } else if (widget.lesson.tipe == TipeLesson.kenalan) {
      setState(() => _tahap = _Tahap.kenalan);
    } else {
      await _buatSesi();
    }
  });

  Future<void> _buatSesi() async {
    _soalBaru ??= GeneratorSoal().buat(
      widget.lesson.topikId,
      AppConfig.soalPerLesson,
      tingkat: widget.lesson.tipe == TipeLesson.kenalan ? 1 : 2,
    );
    final sesi = await ref
        .read(numiControllerProvider.notifier)
        .mulaiSesiLesson(widget.lesson, _soalBaru!);
    if (!mounted) return;
    _sesi = sesi;
    await _tampilkan();
  }

  Future<void> _tampilkan() async {
    if (_sesi!.hasil case final hasil?) {
      setState(() {
        _ringkasan = RingkasanSesi.fromJson(hasil);
        _tahap = _Tahap.hasil;
      });
    } else if (_sesi!.lengkap && !_sesi!.menungguLanjut) {
      await _finalisasi();
    } else {
      setState(() => _tahap = _Tahap.soal);
    }
  }

  Future<void> _finalisasi() async {
    final ringkasan = await ref
        .read(numiControllerProvider.notifier)
        .finalisasiLesson(widget.lesson.id, _sesi!.id);
    if (mounted) {
      setState(() {
        _ringkasan = ringkasan;
        _tahap = _Tahap.hasil;
      });
    }
  }

  void _ulangi() {
    _soalBaru = null;
    _jalankan(_buatSesi);
  }

  @override
  Widget build(BuildContext context) {
    final topik = topikById(widget.lesson.topikId);
    final sesi = _sesi;
    return Scaffold(
      body: switch (_tahap) {
        _Tahap.kenalan => _Kenalan(
          lesson: widget.lesson,
          namaPulau: topik.namaPulau,
          onMulai: () => _jalankan(_buatSesi),
        ),
        _Tahap.soal => SafeArea(
          child: PemutarSoal(
            key: ValueKey(sesi!.id),
            soal: sesi.soal,
            konteks: KonteksJawaban.lesson,
            jawabanAwal: sesi.jawaban,
            menungguLanjut: sesi.menungguLanjut,
            judul: '${topik.namaPulau} · ${widget.lesson.judul}',
            simpanJawaban: (j) => ref
                .read(numiControllerProvider.notifier)
                .jawabLesson(
                  widget.lesson.id,
                  sesi.id,
                  sesi.commandId(sesi.soal.indexWhere((s) => s.id == j.soalId)),
                  j,
                ),
            simpanLanjut: (i) => ref
                .read(numiControllerProvider.notifier)
                .lanjutLesson(
                  widget.lesson.id,
                  sesi.id,
                  '${sesi.id}/lanjut/$i',
                ),
            onSelesai: (_) => _jalankan(_finalisasi),
          ),
        ),
        _Tahap.menyimpan => const Center(child: CircularProgressIndicator()),
        _Tahap.gagal => GagalSimpanSesi(onCobaLagi: _cobaLagi!),
        _Tahap.hasil => HasilSesiView(
          ringkasan: _ringkasan!,
          catatan: 'Hasil dan XP tersimpan di perangkat ini. Membuka hasil kembali tidak menambah XP.',
          judul: _ringkasan!.lulus ? 'Lesson selesai!' : 'Sedikit lagi!',
          tombolUtama: _ringkasan!.lulus ? 'Kembali ke Peta' : 'Coba lagi',
          onUtama: _ringkasan!.lulus
              ? () => Navigator.of(context).pop()
              : _ulangi,
          tombolKedua: _ringkasan!.lulus ? 'Latihan lagi' : 'Kembali ke Peta',
          onKedua: _ringkasan!.lulus
              ? _ulangi
              : () => Navigator.of(context).pop(),
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
