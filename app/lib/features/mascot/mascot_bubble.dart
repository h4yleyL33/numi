import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/companion_message.dart';
import 'numi_mascot.dart';

/// Maskot dengan balon kata. Teksnya muncul huruf demi huruf seperti sedang bicara.
class MascotBubble extends StatelessWidget {
  const MascotBubble({
    super.key,
    required this.teks,
    this.ekspresi = EkspresiMaskot.senang,
    this.ukuranMaskot = 84,
    this.gelap = false,
  });

  final String teks;
  final EkspresiMaskot ekspresi;
  final double ukuranMaskot;
  final bool gelap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NumiMascot(ekspresi: ekspresi, ukuran: ukuranMaskot),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: ukuranMaskot * 0.35),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: gelap ? NumiWarna.malamTerang : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
                bottomRight: Radius.circular(22),
                bottomLeft: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: TeksMengetik(
              teks,
              key: ValueKey(teks),
              gaya: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: gelap ? Colors.white : NumiWarna.tinta,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class TeksMengetik extends StatefulWidget {
  const TeksMengetik(this.teks, {super.key, this.gaya});

  final String teks;
  final TextStyle? gaya;

  @override
  State<TeksMengetik> createState() => _TeksMengetikState();
}

class _TeksMengetikState extends State<TeksMengetik> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 22 * widget.teks.length + 150),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final n = (widget.teks.length * _c.value).round();
        // Sisa teks tetap digambar transparan supaya ukuran balon tidak melompat.
        return Text.rich(
          TextSpan(children: [
            TextSpan(text: widget.teks.substring(0, n)),
            TextSpan(text: widget.teks.substring(n), style: const TextStyle(color: Colors.transparent)),
          ]),
          style: widget.gaya,
        );
      },
    );
  }
}
