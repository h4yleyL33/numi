import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/krayon.dart';
import '../../data/content/daftar_lesson.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/companion_message.dart';
import '../../data/models/data_belajar.dart';
import '../../data/models/topik.dart';
import '../../state/numi_controller.dart';
import '../mascot/numi_mascot.dart';
import 'topik_sheet.dart';

/// Skill map sebagai peta pulau (FR-002, UC-002). Pulau pertama ada di bawah
/// dan siswa "naik" ke pulau berikutnya. Pulau yang direkomendasikan learning
/// path (FR-003, UC-009) ditandai dengan Numi yang melayang di atasnya.
class SkillMapScreen extends ConsumerWidget {
  const SkillMapScreen({super.key});

  static const _jarakPulau = 170.0;
  static const _posisiX = [
    0.28,
    0.7,
    0.36,
    0.74,
    0.26,
    0.62,
    0.3,
    0.72,
    0.4,
    0.76,
    0.3,
    0.6,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(numiControllerProvider);
    final rekomendasi = ref.watch(learningPathProvider).rekomendasi(data);
    final progres = ref.watch(progressServiceProvider);
    final streak = progres.streak(data.streakLog, ref.read(jamProvider)());
    final topik = [...daftarTopik]
      ..sort((a, b) => a.urutan.compareTo(b.urutan));

    return LatarKrayon(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Kepala(
              data: data,
              streak: streak.sekarang,
              terancam: streak.terancam,
              level: progres.level(data.xp),
            ),
            if (rekomendasi != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  '${rekomendasi.topik.namaPulau}: ${rekomendasi.alasan}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: NumiWarna.tinta),
                ),
              ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, batas) {
                  final lebar = batas.maxWidth;
                  final tinggi = topik.length * _jarakPulau + 120;
                  Offset posisi(int i) => Offset(
                    lebar * _posisiX[i % _posisiX.length],
                    tinggi - 90 - i * _jarakPulau,
                  );

                  return SingleChildScrollView(
                    reverse: true,
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Column(
                      children: [
                        SizedBox(
                          height: tinggi,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _PelukisJalur(
                                    titik: [
                                      for (var i = 0; i < topik.length; i++)
                                        posisi(i),
                                    ],
                                    terbuka: [
                                      for (final t in topik)
                                        data.statusTopik(t.id) !=
                                                StatusTopik.terkunci &&
                                            data.statusTopik(t.id) !=
                                                StatusTopik.belumTersedia,
                                    ],
                                  ),
                                ),
                              ),
                              for (final (i, t) in topik.indexed)
                                Positioned(
                                  left: posisi(i).dx - 70,
                                  top: posisi(i).dy - 70,
                                  width: 140,
                                  child: PulauTopik(
                                    topik: t,
                                    status: data.statusTopik(t.id),
                                    lessonSelesai: lessonUntuk(t.id)
                                        .where((l) => data.lessonSelesai(l.id))
                                        .length,
                                    direkomendasikan:
                                        rekomendasi?.topik.id == t.id,
                                    onTap: () =>
                                        tampilkanTopikSheet(context, t),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const _Keterangan(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Kepala extends StatelessWidget {
  const _Kepala({
    required this.data,
    required this.streak,
    required this.terancam,
    required this.level,
  });

  final DataBelajar data;
  final int streak;
  final bool terancam;
  final int level;

  @override
  Widget build(BuildContext context) {
    final terang = data.jumlahBuktiAwal;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: kertasKrayon('panel-mint'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hai, ${data.siswa?.namaPanggilan ?? 'Teman'}!',
                  style: const TextStyle(
                    color: NumiWarna.tinta,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$terang dari ${daftarTopik.length} topik punya bukti awal',
                  style: const TextStyle(
                    color: NumiWarna.tinta,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _Lencong(
            ikon: terancam ? '🕯️' : '🔥',
            nilai: '$streak',
            redup: terancam,
          ),
          const SizedBox(width: 8),
          _Lencong(ikon: '✨', nilai: 'Lv $level'),
        ],
      ),
    );
  }
}

class _Lencong extends StatelessWidget {
  const _Lencong({required this.ikon, required this.nilai, this.redup = false});

  final String ikon;
  final String nilai;
  final bool redup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: NumiWarna.kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: redup
              ? NumiWarna.garis
              : NumiWarna.cahaya.withValues(alpha: 0.6),
        ),
      ),
      child: Text(
        '$ikon $nilai',
        style: const TextStyle(
          color: NumiWarna.tinta,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/// Satu pulau di peta. Tampilannya berubah sesuai status topik (STATE-001).
class PulauTopik extends StatefulWidget {
  const PulauTopik({
    super.key,
    required this.topik,
    required this.status,
    required this.lessonSelesai,
    required this.direkomendasikan,
    required this.onTap,
  });

  final Topik topik;
  final StatusTopik status;
  final int lessonSelesai;
  final bool direkomendasikan;
  final VoidCallback onTap;

  @override
  State<PulauTopik> createState() => _PulauTopikState();
}

class _PulauTopikState extends State<PulauTopik>
    with SingleTickerProviderStateMixin {
  late final AnimationController _denyut = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();
  bool _ditekan = false;

  @override
  void dispose() {
    _denyut.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final terkunci =
        status == StatusTopik.terkunci || status == StatusTopik.belumTersedia;
    final terang = status == StatusTopik.mastered;
    final kolom = kolomPulauKrayon(widget.topik.id);
    // Kemajuan pulau: 2 lesson ditambah mastery test.
    final kemajuan = terang ? 1.0 : widget.lessonSelesai / 3;

    return Semantics(
      button: true,
      label: '${widget.topik.namaPulau}, ${status.label}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _ditekan = true),
        onTapCancel: () => setState(() => _ditekan = false),
        onTapUp: (_) {
          setState(() => _ditekan = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _ditekan ? 0.92 : 1,
          duration: const Duration(milliseconds: 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedBuilder(
                      animation: _denyut,
                      builder: (context, _) => CustomPaint(
                        size: const Size(120, 120),
                        painter: _PelukisPulau(
                          status: status,
                          gambarKrayon: kolom != null,
                          kemajuan: kemajuan,
                          denyut: _denyut.value,
                          sorot: widget.direkomendasikan,
                        ),
                      ),
                    ),
                    if (kolom != null)
                      IlustrasiKrayon(
                        kolom: kolom,
                        lebar: 120,
                        tinggi: 102,
                        posisiY: 18 / 17,
                        skalaY: 50 / 17,
                      )
                    else
                      Opacity(
                        opacity: terkunci ? 0.35 : 1,
                        child: Text(
                          widget.topik.ikon,
                          style: const TextStyle(fontSize: 38),
                        ),
                      ),
                    if (terkunci)
                      const Positioned(
                        bottom: 20,
                        child: Icon(
                          Icons.lock_rounded,
                          color: NumiWarna.tinta,
                          size: 22,
                        ),
                      ),
                    if (terang)
                      const Positioned(
                        top: 4,
                        right: 14,
                        child: Text('⭐', style: TextStyle(fontSize: 24)),
                      ),
                    if (widget.direkomendasikan)
                      const Positioned(
                        top: -58,
                        child: NumiMascot(
                          ukuran: 64,
                          ekspresi: EkspresiMaskot.semangat,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                widget.topik.namaPulau,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NumiWarna.tinta,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PelukisPulau extends CustomPainter {
  _PelukisPulau({
    required this.status,
    required this.kemajuan,
    required this.denyut,
    required this.sorot,
    required this.gambarKrayon,
  });

  final StatusTopik status;
  final double kemajuan;
  final double denyut;
  final bool sorot;
  final bool gambarKrayon;

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = size.center(Offset.zero);
    final r = size.width * 0.36;

    if (sorot) {
      final gelombang = r * (1.05 + denyut * 0.45);
      canvas.drawCircle(
        pusat,
        gelombang,
        Paint()
          ..color = NumiWarna.cahaya.withValues(alpha: 0.6 * (1 - denyut))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }

    if (gambarKrayon) return;

    final (pasir, rumput, cahaya) = switch (status) {
      StatusTopik.terkunci || StatusTopik.belumTersedia => (
        const Color(0xFF3D4170),
        const Color(0xFF30345E),
        0.0,
      ),
      StatusTopik.belumDikuasai ||
      StatusTopik.belumDiuji ||
      StatusTopik.siapLanjut => (
        const Color(0xFFCDB98F),
        const Color(0xFF5E9A6A),
        0.15,
      ),
      StatusTopik.perluLatihan => (
        const Color(0xFFE9D19A),
        const Color(0xFF63B071),
        0.35,
      ),
      StatusTopik.mastered => (
        const Color(0xFFF7DE9C),
        const Color(0xFF6CC47A),
        0.75,
      ),
    };

    if (cahaya > 0) {
      canvas.drawCircle(
        pusat,
        r * 1.5,
        Paint()
          ..shader = RadialGradient(
            colors: [
              NumiWarna.cahaya.withValues(
                alpha: cahaya * (0.8 + 0.2 * sin(denyut * 2 * pi)),
              ),
              NumiWarna.cahaya.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: pusat, radius: r * 1.5)),
      );
    }

    // Air di sekeliling pulau.
    canvas.drawOval(
      Rect.fromCenter(
        center: pusat.translate(0, r * 0.25),
        width: r * 2.5,
        height: r * 1.3,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.07),
    );
    canvas.drawCircle(
      pusat.translate(0, r * 0.1),
      r,
      Paint()..color = Color.lerp(pasir, Colors.black, 0.25)!,
    );
    canvas.drawCircle(pusat, r, Paint()..color = pasir);
    canvas.drawCircle(
      pusat.translate(0, -r * 0.08),
      r * 0.72,
      Paint()..color = rumput,
    );

    if (status == StatusTopik.perluLatihan || status == StatusTopik.mastered) {
      final cincin = Rect.fromCircle(center: pusat, radius: r * 1.18);
      canvas.drawArc(
        cincin,
        -pi / 2,
        2 * pi,
        false,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
      );
      canvas.drawArc(
        cincin,
        -pi / 2,
        2 * pi * kemajuan,
        false,
        Paint()
          ..color = NumiWarna.cahaya
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisPulau lama) =>
      lama.gambarKrayon != gambarKrayon ||
      lama.denyut != denyut ||
      lama.status != status ||
      lama.kemajuan != kemajuan ||
      lama.sorot != sorot;
}

class _PelukisJalur extends CustomPainter {
  _PelukisJalur({required this.titik, required this.terbuka});

  final List<Offset> titik;
  final List<bool> terbuka;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < titik.length - 1; i++) {
      final a = titik[i];
      final b = titik[i + 1];
      final kendali = Offset(
        (a.dx + b.dx) / 2 + (i.isEven ? 40 : -40),
        (a.dy + b.dy) / 2,
      );
      final jalur = Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(kendali.dx, kendali.dy, b.dx, b.dy);
      final nyala = terbuka[i + 1];
      final cat = Paint()
        ..color = nyala
            ? NumiWarna.cahaya.withValues(alpha: 0.8)
            : NumiWarna.garis
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      for (final m in jalur.computeMetrics()) {
        for (var d = 70.0; d < m.length - 70; d += 16) {
          canvas.drawPath(m.extractPath(d, d + 7), cat);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisJalur lama) => true;
}

/// Keterangan peta dikumpulkan di dasar halaman dan tertutup sejak awal.
class _Keterangan extends StatelessWidget {
  const _Keterangan();

  @override
  Widget build(BuildContext context) {
    const baris = [
      ('🔒', 'Terkunci', 'Kuasai dulu pulau sebelumnya.'),
      ('🏝️', 'Belum dikuasai', 'Pulau sudah terbuka dan siap dijelajahi.'),
      (
        '🟡',
        'Perlu latihan',
        'Cincin kuning menunjukkan lesson yang sudah selesai.',
      ),
      ('⭐', 'Dikuasai', 'Mercusuar menyala setelah lulus mastery test.'),
      (
        '🐞',
        'Numi melayang',
        'Pulau yang disarankan untuk dipelajari berikutnya.',
      ),
    ];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: NumiWarna.tinta,
        collapsedIconColor: NumiWarna.tintaPudar,
        title: const Text(
          'Keterangan peta',
          style: TextStyle(color: NumiWarna.tinta, fontWeight: FontWeight.w700),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final (ikon, judul, isi) in baris)
            ListTile(
              dense: true,
              leading: Text(ikon, style: const TextStyle(fontSize: 22)),
              title: Text(
                judul,
                style: const TextStyle(
                  color: NumiWarna.tinta,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                isi,
                style: const TextStyle(color: NumiWarna.tintaPudar),
              ),
            ),
        ],
      ),
    );
  }
}
