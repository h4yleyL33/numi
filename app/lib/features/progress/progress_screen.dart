import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/tanggal.dart';
import '../../core/widgets/bilah_progres.dart';
import '../../core/widgets/chip_status.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/daftar_lencana.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/models/badge.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../mascot/numi_mascot.dart';
import '../onboarding/splash_screen.dart';

/// UC-006: XP, level, streak, dan lencana. Ringkasan untuk orang tua dan
/// keterangan aturan ada di bagian bawah yang tertutup sejak awal.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(numiControllerProvider);
    final progres = ref.watch(progressServiceProvider);
    final hariIni = ref.read(jamProvider)();
    final streak = progres.streak(data.streakLog, hariIni);
    final level = progres.level(data.xp);
    final aktif = data.streakLog.map((l) => l.tanggal).toSet();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [NumiWarna.malam, NumiWarna.malamTerang]),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const NumiMascot(ukuran: 90, ekspresi: EkspresiMaskot.bangga),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.siswa?.nama ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      Text(data.siswa?.kelompokKelas?.label ?? 'Konfirmasi kelas bersama wali',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Level $level',
                              style: const TextStyle(color: NumiWarna.cahaya, fontWeight: FontWeight.w900)),
                          const Spacer(),
                          Text('${progres.xpDiLevel(data.xp)}/${AppConfig.xpPerLevel} XP',
                              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      BilahProgres(
                        nilai: progres.xpDiLevel(data.xp) / AppConfig.xpPerLevel,
                        latar: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _KartuStreak(
            sekarang: streak.sekarang,
            terbaik: streak.terbaik,
            terancam: streak.terancam,
            hari: [for (var i = 6; i >= 0; i--) hariIni.subtract(Duration(days: i))],
            aktif: aktif,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Statistik(
                ikon: '🗼',
                nilai: '${data.jumlahBuktiAwal}',
                label: 'Bukti awal',
              ),
              const SizedBox(width: 10),
              _Statistik(
                ikon: '📘',
                nilai: '${data.progresLesson.values.where((p) => p.selesai).length}',
                label: 'Lesson selesai',
              ),
              const SizedBox(width: 10),
              _Statistik(ikon: '✨', nilai: '${data.xp}', label: 'Total XP'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Lencana', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Ketuk kartu untuk melihat syaratnya', style: TextStyle(color: NumiWarna.tintaPudar)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.46),
              padEnds: false,
              itemCount: daftarLencana.length,
              itemBuilder: (context, i) {
                final l = daftarLencana[i];
                final milik = data.lencana.where((x) => x.badgeId == l.id).firstOrNull;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: KartuLencana(lencana: l, diperoleh: milik?.waktuDiperoleh),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _Lipatan(
            judul: 'Untuk orang tua',
            children: [
              for (final t in daftarTopik)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Text(t.ikon, style: const TextStyle(fontSize: 22)),
                  title: Text(t.nama, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${t.fase.label} · ${t.fase.kelas}'),
                  trailing: ChipStatus(status: data.statusTopik(t.id)),
                ),
              const SizedBox(height: 8),
              Text(_ringkasJawaban(data.riwayatJawaban)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Hapus data dan mulai dari awal'),
                onPressed: () => _konfirmasiUlang(context, ref),
              ),
            ],
          ),
          _Lipatan(
            judul: 'Keterangan',
            children: const [
              Text(
                'Setiap jawaban benar memberi ${AppConfig.xpPerBenar} XP. Lesson yang selesai memberi tambahan '
                '${AppConfig.xpLessonSelesai} XP, dan mercusuar yang menyala memberi ${AppConfig.xpMasteryLulus} XP. '
                'Setiap ${AppConfig.xpPerLevel} XP, level naik satu.\n\n'
                'Nyala api bertambah setiap hari kamu belajar. Kalau satu hari terlewat, nyalanya mulai dari nol lagi.\n\n'
                'Lesson dianggap selesai kalau minimal ${AppConfig.minBenarLesson} dari ${AppConfig.soalPerLesson} '
                'soal benar. Bukti awal mastery memakai lima jawaban benar tanpa bantuan.',
                style: TextStyle(height: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _ringkasJawaban(List<Jawaban> jawaban) {
    if (jawaban.isEmpty) return 'Belum ada jawaban tercatat.';
    final benar = jawaban.where((j) => j.benar).length;
    final persen = (benar * 100 / jawaban.length).round();
    final terakhir = jawaban.map((j) => j.waktu).reduce((a, b) => a.isAfter(b) ? a : b);
    return 'Dari ${jawaban.length} soal terakhir, $benar dijawab benar ($persen%). '
        'Aktivitas terakhir: ${kunciTanggal(terakhir)}.';
  }

  Future<void> _konfirmasiUlang(BuildContext context, WidgetRef ref) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mulai dari awal?'),
        content: const Text('Semua progres, XP, dan lencana di perangkat ini akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Hapus')),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    await ref.read(numiControllerProvider.notifier).mulaiUlang();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(transisiPudar(const SplashScreen()), (_) => false);
  }
}

class _KartuStreak extends StatefulWidget {
  const _KartuStreak({
    required this.sekarang,
    required this.terbaik,
    required this.terancam,
    required this.hari,
    required this.aktif,
  });

  final int sekarang;
  final int terbaik;
  final bool terancam;
  final List<DateTime> hari;
  final Set<String> aktif;

  @override
  State<_KartuStreak> createState() => _KartuStreakState();
}

class _KartuStreakState extends State<_KartuStreak> with SingleTickerProviderStateMixin {
  late final AnimationController _api =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  static const _namaHari = ['Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb', 'Mg'];

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE7DA), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _api,
                builder: (context, child) => Transform.scale(
                  scale: widget.terancam ? 0.9 : 1 + _api.value * 0.12,
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
                child: Text(widget.terancam ? '🕯️' : '🔥', style: const TextStyle(fontSize: 44)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.sekarang} hari',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                    Text(
                      widget.terancam ? 'Belajar hari ini supaya nyalanya tidak padam' : 'Nyala api belajarmu',
                      style: const TextStyle(color: NumiWarna.tintaPudar),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text('Terbaik', style: TextStyle(color: NumiWarna.tintaPudar)),
                  Text('${widget.terbaik}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final h in widget.hari)
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.aktif.contains(kunciTanggal(h)) ? NumiWarna.cahaya : const Color(0xFFF1ECE1),
                      ),
                      child: widget.aktif.contains(kunciTanggal(h))
                          ? const Icon(Icons.local_fire_department_rounded, size: 20, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(_namaHari[h.weekday - 1], style: const TextStyle(fontSize: 12, color: NumiWarna.tintaPudar)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Statistik extends StatelessWidget {
  const _Statistik({required this.ikon, required this.nilai, required this.label});

  final String ikon;
  final String nilai;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(ikon, style: const TextStyle(fontSize: 24)),
            Text(nilai, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(fontSize: 12, color: NumiWarna.tintaPudar)),
          ],
        ),
      ),
    );
  }
}

/// Kartu lencana yang berbalik saat diketuk: depan ikon, belakang syarat.
class KartuLencana extends StatefulWidget {
  const KartuLencana({super.key, required this.lencana, required this.diperoleh});

  final Lencana lencana;
  final DateTime? diperoleh;

  @override
  State<KartuLencana> createState() => _KartuLencanaState();
}

class _KartuLencanaState extends State<KartuLencana> with SingleTickerProviderStateMixin {
  late final AnimationController _balik =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 550));

  @override
  void dispose() {
    _balik.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final milik = widget.diperoleh != null;
    return GestureDetector(
      onTap: () => _balik.isCompleted ? _balik.reverse() : _balik.forward(),
      child: AnimatedBuilder(
        animation: _balik,
        builder: (context, _) {
          final sudut = Curves.easeInOutBack.transform(_balik.value) * pi;
          final belakang = sudut > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(sudut),
            child: belakang
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _sisi(
                      warna: milik ? NumiWarna.malam : const Color(0xFF8E8BA8),
                      isi: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.lencana.syarat,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, height: 1.4)),
                          if (milik) ...[
                            const SizedBox(height: 8),
                            Text('Didapat ${kunciTanggal(widget.diperoleh!)}',
                                style: const TextStyle(color: NumiWarna.cahayaMuda, fontSize: 12)),
                          ],
                        ],
                      ),
                    ),
                  )
                : _sisi(
                    warna: milik ? NumiWarna.cahaya : const Color(0xFFE9E5DA),
                    isi: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: milik ? 1 : 0.35,
                          child: Text(widget.lencana.ikon, style: const TextStyle(fontSize: 56)),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.lencana.nama,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: milik ? NumiWarna.tinta : NumiWarna.tintaPudar,
                            )),
                        if (!milik) const Icon(Icons.lock_rounded, size: 18, color: NumiWarna.tintaPudar),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _sisi({required Color warna, required Widget isi}) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: warna,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Color.lerp(warna, Colors.black, 0.25)!, offset: const Offset(0, 6))],
        ),
        child: isi,
      );
}

class _Lipatan extends StatelessWidget {
  const _Lipatan({required this.judul, required this.children});

  final String judul;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        title: Text(judul, style: const TextStyle(fontWeight: FontWeight.w800, color: NumiWarna.tintaPudar)),
        children: children,
      ),
    );
  }
}
