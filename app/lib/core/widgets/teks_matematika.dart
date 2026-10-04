import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Menampilkan kalimat matematika. Token dipisah spasi; token berbentuk `a/b`
/// digambar sebagai pecahan bersusun, dan ☐ digambar sebagai kotak kosong.
class TeksMatematika extends StatelessWidget {
  const TeksMatematika(this.kalimat, {super.key, this.ukuran = 40, this.kotak, this.warna});

  final String kalimat;
  final double ukuran;

  /// Pengganti kotak kosong, misalnya DragTarget di soal seret ke kotak.
  final Widget? kotak;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    final token = kalimat.split(' ').where((t) => t.isNotEmpty).toList();
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: ukuran * 0.25,
      runSpacing: 8,
      children: [
        for (final t in token)
          if (t == '☐')
            kotak ?? KotakKosong(ukuran: ukuran)
          else if (_pecahan.hasMatch(t))
            TeksPecahan(t, ukuran: ukuran, warna: warna)
          else
            Text(
              t,
              style: TextStyle(fontSize: ukuran, fontWeight: FontWeight.w900, color: warna ?? NumiWarna.tinta),
            ),
      ],
    );
  }

  static final _pecahan = RegExp(r'^\d+/\d+$');
}

class KotakKosong extends StatelessWidget {
  const KotakKosong({super.key, required this.ukuran, this.isi, this.sorot = false});

  final double ukuran;
  final String? isi;
  final bool sorot;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: BoxConstraints(minWidth: ukuran * 1.5),
      height: ukuran * 1.45,
      padding: EdgeInsets.symmetric(horizontal: ukuran * 0.2),
      decoration: BoxDecoration(
        color: sorot ? NumiWarna.cahayaMuda : (isi == null ? Colors.white : NumiWarna.cahayaMuda.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(ukuran * 0.3),
        border: Border.all(
          color: sorot ? NumiWarna.cahaya : NumiWarna.tintaPudar.withValues(alpha: 0.5),
          width: 3,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: isi == null
            ? Text('?', style: TextStyle(fontSize: ukuran * 0.8, color: NumiWarna.tintaPudar.withValues(alpha: 0.5), fontWeight: FontWeight.w900))
            : TeksPecahanAtauAngka(isi!, ukuran: ukuran),
      ),
    );
  }
}

/// Satu nilai jawaban, bisa angka biasa atau pecahan.
class TeksPecahanAtauAngka extends StatelessWidget {
  const TeksPecahanAtauAngka(this.teks, {super.key, required this.ukuran, this.warna});

  final String teks;
  final double ukuran;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    if (TeksMatematika._pecahan.hasMatch(teks)) return TeksPecahan(teks, ukuran: ukuran, warna: warna);
    return Text(
      teks,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: ukuran, fontWeight: FontWeight.w900, color: warna ?? NumiWarna.tinta),
    );
  }
}

class TeksPecahan extends StatelessWidget {
  const TeksPecahan(this.teks, {super.key, required this.ukuran, this.warna});

  final String teks;
  final double ukuran;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    final bagian = teks.split('/');
    final gaya = TextStyle(
      fontSize: ukuran * 0.62,
      fontWeight: FontWeight.w900,
      height: 1.05,
      color: warna ?? NumiWarna.tinta,
    );
    return Semantics(
      label: '${bagian[0]} per ${bagian[1]}',
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(bagian[0], textAlign: TextAlign.center, style: gaya),
            Container(height: ukuran * 0.07, color: warna ?? NumiWarna.tinta, margin: const EdgeInsets.symmetric(vertical: 2)),
            Text(bagian[1], textAlign: TextAlign.center, style: gaya),
          ],
        ),
      ),
    );
  }
}
