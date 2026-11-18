import 'package:flutter/material.dart';

import 'krayon.dart';

/// Mercusuar krayon dari atlas Samudra Angka.
class PulauHias extends StatelessWidget {
  const PulauHias({super.key, required this.menyala, this.ukuran = 100});

  final bool menyala;
  final double ukuran;

  @override
  Widget build(BuildContext context) => IlustrasiKrayon(
    kolom: menyala ? 0 : 1,
    lebar: ukuran * 1.6,
    tinggi: ukuran * 1.4,
    posisiY: 7 / 3,
    skalaY: 10 / 3,
  );
}
