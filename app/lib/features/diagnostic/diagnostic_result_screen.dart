import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/companion_message.dart';
import '../../core/widgets/chip_status.dart';
import '../../domain/diagnostic_engine.dart';
import '../home/home_shell.dart';
import '../mascot/mascot_bubble.dart';

class DiagnosticResultScreen extends StatelessWidget {
  const DiagnosticResultScreen({super.key, required this.hasil});

  final HasilAkhirDiagnostic hasil;

  @override
  Widget build(BuildContext context) {
    final status = hasil.statusAwal;
    final dicoba = hasil.hasilPerTopik.length;
    final latihan = status.values.where((s) => s == StatusTopik.perluLatihan).length;
    final diuji = {for (final h in hasil.hasilPerTopik) h.topikId: h};

    return Scaffold(
      body: LatarMalam(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    MascotBubble(
                      gelap: true,
                      ekspresi: EkspresiMaskot.bangga,
                      ukuranMaskot: 96,
                      teks: '$dicoba jangkar sudah dicoba. $latihan bagian bisa kita latih. '
                          'Yang belum ditanyakan tetap Belum dicoba.',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: NumiWarna.cahaya,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Text('Titik awal: Kelas ${hasil.kelas}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(hasil.kelompok.label,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                          Text(hasil.kelompok.fase),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Hasil ini indikasi dari sampel soal, bukan penguasaan seluruh materi.',
                      style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    for (final (i, t) in daftarTopik.indexed)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + i * 90),
                        curve: Curves.easeOutBack,
                        builder: (context, v, child) => Opacity(
                          opacity: v.clamp(0, 1),
                          child: Transform.translate(offset: Offset((1 - v) * 60, 0), child: child),
                        ),
                        child: _BarisPulau(
                          ikon: t.ikon,
                          nama: t.namaPulau,
                          topik: t.nama,
                          status: status[t.id]!,
                          skor: diuji[t.id] == null ? null : '${diuji[t.id]!.benar}/${diuji[t.id]!.total}',
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: TombolNumi(
                  label: 'Lihat Peta',
                  lebar: double.infinity,
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    transisiPudar(const HomeShell()),
                    (_) => false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarisPulau extends StatelessWidget {
  const _BarisPulau({
    required this.ikon,
    required this.nama,
    required this.topik,
    required this.status,
    required this.skor,
  });

  final String ikon;
  final String nama;
  final String topik;
  final StatusTopik status;
  final String? skor;

  @override
  Widget build(BuildContext context) {
    final terang = status == StatusTopik.mastered;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: terang ? 0.16 : 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: terang ? NumiWarna.cahaya : Colors.white12),
      ),
      child: Row(
        children: [
          Opacity(opacity: status == StatusTopik.terkunci ? 0.4 : 1, child: Text(ikon, style: const TextStyle(fontSize: 28))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                Text(topik, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
          if (skor != null) Text(skor!, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          ChipStatus(status: status),
        ],
      ),
    );
  }
}
