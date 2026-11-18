import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/krayon.dart';
import '../../core/widgets/tombol_numi.dart';
import '../mascot/numi_mascot.dart';

Future<bool> periksaProfilAnak(
  BuildContext context,
  String nama,
  int kelas,
) async {
  return await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (context) => Scaffold(
            body: LatarKrayon(
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: NumiMascot(ukuran: 96)),
                          Text(
                            'Periksa profil anak',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sudah sesuai dengan anak yang akan belajar?',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Card(
                            color: NumiWarna.kartu,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Nama panggilan'),
                                  Text(
                                    nama.trim(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Kelas saat ini'),
                                  Text(
                                    'Kelas $kelas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Kelas membantu memilih soal awal. Latihan selanjutnya mengikuti hasil anak.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TombolNumi(
                            label: 'Simpan dan lanjut',
                            onTap: () => Navigator.pop(context, true),
                          ),
                          const SizedBox(height: 12),
                          TombolNumi(
                            label: 'Ubah profil',
                            warna: NumiWarna.kartu,
                            onTap: () => Navigator.pop(context, false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ) ??
      false;
}
