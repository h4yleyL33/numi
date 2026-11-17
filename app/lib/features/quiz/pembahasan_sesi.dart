import 'package:flutter/material.dart';

import '../../data/models/sesi_soal.dart';

class PembahasanSesi extends StatelessWidget {
  const PembahasanSesi({super.key, required this.blok});

  final List<SesiSoal> blok;

  @override
  Widget build(BuildContext context) {
    final item = [
      for (final sesi in blok)
        for (final (i, jawaban) in sesi.jawaban.indexed)
          (sesi.soal[i], jawaban),
    ];
    return ExpansionTile(
      title: const Text('Pembahasan jawaban'),
      children: [
        for (final (i, record) in item.indexed)
          ListTile(
            title: Text('${i + 1}. ${record.$1.pertanyaan}'),
            subtitle: Text(
              'Jawabanmu ${_teks(record.$2.jawaban)} · '
              '${record.$2.benar ? 'Benar' : 'Perlu latihan'}\n'
              'Kunci ${_teks(record.$1.jawabanBenar)}\n${record.$1.penjelasan}',
            ),
          ),
      ],
    );
  }

  String _teks(String nilai) => nilai.replaceAll('|', ', ');
}
