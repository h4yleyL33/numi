import 'package:flutter/material.dart';

import 'latar_numi.dart';

/// Panel gelap untuk cerita dan peta, memakai ilustrasi Numi yang sama.
class LatarMalam extends StatelessWidget {
  const LatarMalam({super.key, required this.child, this.jumlahBintang = 60});
  final Widget child;
  final int jumlahBintang;
  @override
  Widget build(BuildContext context) => LatarNumi(gelap: true, child: child);
}
