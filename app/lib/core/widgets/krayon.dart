import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const _folder = 'assets/krayon';

class LatarKrayon extends StatelessWidget {
  const LatarKrayon({
    super.key,
    required this.child,
    this.topikId,
    this.ilustrasi,
  });

  final Widget child;
  final String? topikId;
  final String? ilustrasi;

  @override
  Widget build(BuildContext context) {
    final latar =
        ilustrasi ??
        switch (topikId) {
          'T03' => 'pulau-pelangi',
          'T05' => 'pulau-pecahan',
          _ => 'samudra',
        };
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: NumiWarna.krem),
        Image.asset(
          '$_folder/$latar.png',
          fit: BoxFit.cover,
          excludeFromSemantics: true,
        ),
        child,
      ],
    );
  }
}

BoxDecoration kertasKrayon(String aset) => BoxDecoration(
  image: DecorationImage(
    image: AssetImage('$_folder/$aset.png'),
    fit: BoxFit.fill,
  ),
);

int? kolomPulauKrayon(String topikId) => switch (topikId) {
  'T01' => 0,
  'T02' => 1,
  'T03' => 2,
  'T04' => 3,
  _ => null,
};

/// Menampilkan satu bagian atlas sesuai posisi dan potongan di Figma.
class IlustrasiKrayon extends StatelessWidget {
  const IlustrasiKrayon({
    super.key,
    required this.kolom,
    required this.lebar,
    required this.tinggi,
    this.posisiY = 0,
    this.skalaY = 3,
  });

  final int kolom;
  final double lebar;
  final double tinggi;
  final double posisiY;
  final double skalaY;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: lebar,
    height: tinggi,
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: lebar * 4,
        maxWidth: lebar * 4,
        minHeight: tinggi * skalaY,
        maxHeight: tinggi * skalaY,
        child: Transform.translate(
          offset: Offset(-lebar * kolom, -tinggi * posisiY),
          child: Image.asset(
            '$_folder/atlas.png',
            fit: BoxFit.fill,
            excludeFromSemantics: true,
          ),
        ),
      ),
    ),
  );
}
