import 'package:flutter/material.dart';

import '../../data/models/catatan_belajar.dart';
import '../theme/app_theme.dart';

/// Label status topik dengan warna dan ikon yang sama di semua layar.
class ChipStatus extends StatelessWidget {
  const ChipStatus({super.key, required this.status});

  final StatusTopik status;

  @override
  Widget build(BuildContext context) {
    final (warna, ikon) = switch (status) {
      StatusTopik.mastered => (NumiWarna.cahaya, Icons.star_rounded),
      StatusTopik.perluLatihan => (NumiWarna.langit, Icons.trending_up_rounded),
      StatusTopik.belumDikuasai => (const Color(0xFFB9B6D3), Icons.circle_outlined),
      StatusTopik.terkunci => (const Color(0xFF6E6B8F), Icons.lock_rounded),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: warna, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 14, color: NumiWarna.tinta),
          const SizedBox(width: 4),
          Text(status.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: NumiWarna.tinta)),
        ],
      ),
    );
  }
}
