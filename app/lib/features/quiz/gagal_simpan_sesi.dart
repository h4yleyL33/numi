import 'package:flutter/material.dart';

import '../../core/widgets/tombol_numi.dart';

class GagalSimpanSesi extends StatelessWidget {
  const GagalSimpanSesi({super.key, required this.onCobaLagi});
  final VoidCallback onCobaLagi;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sesi belum berhasil disimpan. Coba lagi. '
              'Jika tetap gagal, buka ulang profil untuk memuat data terbaru.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TombolNumi(label: 'Coba simpan lagi', onTap: onCobaLagi),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    ),
  );
}
