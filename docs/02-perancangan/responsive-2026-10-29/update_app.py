from pathlib import Path
root=Path('app/lib')
(root/'core/widgets/latar_malam.dart').write_text('''import 'package:flutter/material.dart';
import 'latar_numi.dart';

/// Panel gelap untuk cerita dan peta, memakai ilustrasi Numi yang sama.
class LatarMalam extends StatelessWidget {
  const LatarMalam({super.key, required this.child, this.jumlahBintang = 60});
  final Widget child;
  final int jumlahBintang;
  @override
  Widget build(BuildContext context) => LatarNumi(gelap: true, child: child);
}
''',encoding='utf-8')
p=root/'features/onboarding/onboarding_screen.dart';s=p.read_text(encoding='utf-8')
start=s.index('    return Padding(',s.index('class _HalamanCerita'))
end=s.index('\n  }\n}',start)
s=s[:start]+'''    return LayoutBuilder(builder: (context, batas) {
      final mendatar = batas.maxWidth >= 700;
      final gambar = SizedBox(
        width: mendatar ? 240 : batas.maxWidth - 48,
        height: mendatar ? 160 : 220,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(left: 0, bottom: 20, child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 90)),
          Positioned(right: 0, bottom: 40, child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 70)),
          Positioned(top: 0, child: NumiMascot(ukuran: mendatar ? 120 : 150, ekspresi: adegan.ekspresi)),
        ]),
      );
      final teks = Text(adegan.teks, textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 21, height: 1.45, fontWeight: FontWeight.w700));
      return Center(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: mendatar
          ? Row(children: [gambar, const SizedBox(width: 32), Expanded(child: teks)])
          : Column(children: [gambar, const SizedBox(height: 28), teks]),
      ));
    });'''+s[end:]
p.write_text(s,encoding='utf-8')
p=root/'features/diagnostic/diagnostic_intro_screen.dart';s=p.read_text(encoding='utf-8')
s=s.replace('                const Spacer(),','                Expanded(child: SingleChildScrollView(child: Column(children: [',1)
s=s.replace('                const Spacer(),','                ]))),\n                const SizedBox(height: 12),',1)
p.write_text(s,encoding='utf-8')
p=root/'features/onboarding/splash_screen.dart';s=p.read_text(encoding='utf-8')
s=s.replace('child: Column(\n            mainAxisSize:', 'child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(\n            mainAxisSize:',1)
s=s.replace('            ],\n          ),\n        ),','            ],\n          )),\n        ),',1)
p.write_text(s,encoding='utf-8')
print('Updated shared background, story, intro, and splash')
