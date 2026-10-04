import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/chip_status.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/daftar_lesson.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/lesson.dart';
import '../../data/models/topik.dart';
import '../../state/numi_controller.dart';
import '../lesson/lesson_screen.dart';
import '../mastery/mastery_screen.dart';

void tampilkanTopikSheet(BuildContext context, Topik topik) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TopikSheet(topik: topik),
  );
}

/// Isi satu pulau: dua lesson dan mercusuar (mastery test).
class TopikSheet extends ConsumerWidget {
  const TopikSheet({super.key, required this.topik});

  final Topik topik;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(numiControllerProvider);
    final status = data.statusTopik(topik.id);
    final path = ref.watch(learningPathProvider);
    final lessons = lessonUntuk(topik.id);
    final siapMastery = path.siapMastery(topik.id, data);
    final kurang = ref
        .watch(skillMapServiceProvider)
        .prasyaratBelumDikuasai(topik, {for (final e in data.skillMap.entries) e.key: e.value.status});

    void buka(Widget halaman) {
      Navigator.of(context).pop();
      Navigator.of(context).push(transisiNaik(halaman));
    }

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      decoration: const BoxDecoration(
        color: NumiWarna.krem,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(topik.ikon, style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topik.namaPulau, style: Theme.of(context).textTheme.headlineSmall),
                        Text(topik.nama, style: const TextStyle(color: NumiWarna.tintaPudar, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ChipStatus(status: status),
                  Chip(
                    label: Text('${topik.fase.label} · ${topik.fase.kelas}'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (status == StatusTopik.terkunci)
                _Terkunci(kurang: kurang)
              else ...[
                for (final (i, l) in lessons.indexed)
                  _BarisLesson(
                    nomor: i + 1,
                    lesson: l,
                    selesai: data.lessonSelesai(l.id),
                    terbuka: i == 0 || data.lessonSelesai(lessons[i - 1].id),
                    onTap: () => buka(LessonScreen(lesson: l)),
                  ),
                const SizedBox(height: 8),
                _BarisMercusuar(
                  status: status,
                  siap: siapMastery,
                  onTap: () => buka(MasteryScreen(topik: topik)),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Capaian: ${topik.capaian}',
                style: const TextStyle(color: NumiWarna.tintaPudar, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Terkunci extends StatelessWidget {
  const _Terkunci({required this.kurang});

  final List<Topik> kurang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_rounded, color: NumiWarna.tintaPudar),
              SizedBox(width: 8),
              Text('Pulau ini masih tertutup kabut', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Terangi dulu pulau ini:'),
          for (final t in kurang)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${t.ikon}  ${t.namaPulau}', style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

class _BarisLesson extends StatelessWidget {
  const _BarisLesson({
    required this.nomor,
    required this.lesson,
    required this.selesai,
    required this.terbuka,
    required this.onTap,
  });

  final int nomor;
  final Lesson lesson;
  final bool selesai;
  final bool terbuka;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: selesai ? NumiWarna.benar : const Color(0xFFEDE7DA), width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: selesai ? NumiWarna.benar : NumiWarna.cahayaMuda,
            child: selesai
                ? const Icon(Icons.check_rounded, color: Colors.white)
                : Text('$nomor', style: const TextStyle(fontWeight: FontWeight.w900, color: NumiWarna.tinta)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.judul, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text('${lesson.tipe.label} · ${AppConfig.soalPerLesson} soal',
                    style: const TextStyle(color: NumiWarna.tintaPudar)),
              ],
            ),
          ),
          SizedBox(
            width: 104,
            child: TombolNumi(
              label: selesai ? 'Ulangi' : 'Mulai',
              tinggi: 44,
              warna: selesai ? Colors.white : NumiWarna.cahaya,
              onTap: terbuka ? onTap : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarisMercusuar extends StatelessWidget {
  const _BarisMercusuar({required this.status, required this.siap, required this.onTap});

  final StatusTopik status;
  final bool siap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sudah = status == StatusTopik.mastered;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [NumiWarna.malam, NumiWarna.malamTerang]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('🗼', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nyalakan Mercusuar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                    Text(
                      sudah
                          ? 'Mercusuar sudah menyala. Boleh dicoba lagi.'
                          : (siap ? 'Mastery test, ${AppConfig.soalMastery} soal' : 'Selesaikan kedua lesson dulu'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TombolNumi(label: sudah ? 'Coba lagi' : 'Mulai Mastery Test', onTap: siap || sudah ? onTap : null),
        ],
      ),
    );
  }
}
