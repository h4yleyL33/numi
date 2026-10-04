import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/teks_matematika.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/models/companion_message.dart';
import '../../data/models/soal.dart';
import '../mascot/numi_mascot.dart';

/// Umpan balik langsung setelah siswa mengecek jawaban (FR-005, UC-004).
/// Kalau salah, penjelasan dan jawaban yang benar ikut ditampilkan.
class BannerUmpanBalik extends StatelessWidget {
  const BannerUmpanBalik({
    super.key,
    required this.benar,
    required this.soal,
    required this.onLanjut,
    this.tampilkanXp = true,
  });

  final bool benar;
  final Soal soal;
  final VoidCallback onLanjut;
  final bool tampilkanXp;

  static const _pujian = ['Hebat!', 'Tepat sekali!', 'Keren!', 'Pintar!', 'Mantap!'];

  @override
  Widget build(BuildContext context) {
    final warna = benar ? NumiWarna.benar : NumiWarna.salah;
    final judul = benar ? _pujian[soal.id.hashCode.abs() % _pujian.length] : 'Belum tepat, tidak apa-apa';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Transform.translate(offset: Offset(0, v * 260), child: child),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: benar ? NumiWarna.benarMuda : NumiWarna.salahMuda,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  NumiMascot(
                    ukuran: 64,
                    ekspresi: benar ? EkspresiMaskot.bangga : EkspresiMaskot.semangat,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      judul,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color.lerp(warna, Colors.black, 0.25)),
                    ),
                  ),
                  if (benar && tampilkanXp)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: NumiWarna.cahaya, borderRadius: BorderRadius.circular(20)),
                      child: const Text('+${AppConfig.xpPerBenar} XP', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                ],
              ),
              if (!benar) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Jawaban yang benar: ', style: TextStyle(fontWeight: FontWeight.w700)),
                    if (soal.jenis == JenisSoal.pasangkan)
                      const SizedBox.shrink()
                    else
                      TeksPecahanAtauAngka(soal.jawabanBenar, ukuran: 22),
                  ],
                ),
                const SizedBox(height: 6),
                Text(soal.penjelasan, style: const TextStyle(fontSize: 16, height: 1.4)),
              ],
              const SizedBox(height: 16),
              TombolNumi(label: 'Lanjut', warna: warna, warnaTeks: Colors.white, onTap: onLanjut),
            ],
          ),
        ),
      ),
    );
  }
}
