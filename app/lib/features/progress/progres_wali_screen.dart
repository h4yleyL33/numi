import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/tanggal.dart';
import '../../core/widgets/transisi.dart';
import '../../data/content/daftar_lesson.dart';
import '../../data/content/daftar_topik.dart';
import '../../data/models/catatan_belajar.dart';
import '../../state/numi_controller.dart';
import '../mastery/mastery_screen.dart';

class ProgresWaliScreen extends ConsumerWidget {
  const ProgresWaliScreen({super.key, required this.onReset});

  final Future<void> Function(BuildContext, WidgetRef) onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(numiControllerProvider);
    final jalur = ref.watch(learningPathProvider);
    final saran = jalur.rekomendasi(data);
    final hariIni = ref.watch(jamProvider)();
    final diagnostik = data.sesiDiagnostic;
    final hasilTes = [...data.hasilMastery]
      ..sort((a, b) => b.waktu.compareTo(a.waktu));
    final aktivitasTerakhir = data.streakLog
        .map((e) => e.tanggal)
        .fold<String?>(null, (a, b) => a == null || b.compareTo(a) > 0 ? b : a);
    final judul = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      appBar: AppBar(title: const Text('Progres untuk wali')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (data.siswa case final siswa?)
            Text('${siswa.nama} · Kelas ${siswa.kelas ?? "belum dipilih"}'),
          const SizedBox(height: 16),
          Text('Langkah berikutnya', style: judul),
          Text(
            data.perluDiagnostic
                ? 'Selesaikan tes penempatan agar Numi dapat menyarankan latihan.'
                : saran == null
                ? 'Belum ada latihan berikutnya yang direkomendasikan.'
                : '${saran.lesson?.judul ?? 'Tes penguasaan'} · ${saran.topik.nama}\n${saran.alasan}',
          ),
          const SizedBox(height: 24),
          Text('Kemampuan per topik', style: judul),
          for (final topik in daftarTopik)
            Builder(
              builder: (context) {
                final bukti = data.buktiSkill[topik.id];
                final lesson = lessonUntuk(topik.id);
                final selesai = lesson.where((l) => data.lessonSelesai(l.id));
                final status = data.statusTopik(topik.id);
                final periksaUlang = jalur.jadwalPeriksaUlang(topik.id, data);
                final siapPeriksa =
                    periksaUlang != null &&
                    !hariIni.isBefore(periksaUlang) &&
                    status != StatusTopik.terkunci &&
                    status != StatusTopik.belumTersedia;
                final label =
                    bukti?.label ??
                    (status == StatusTopik.belumTersedia
                        ? 'Materi belum tersedia'
                        : 'Belum diukur');
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(topik.nama),
                  subtitle: Text(
                    [
                      label,
                      if (bukti != null)
                        '${bukti.benar}/${bukti.total} benar · ${bukti.bantuan} bantuan · ${kunciTanggal(bukti.waktu)}',
                      if (lesson.isNotEmpty)
                        '${selesai.length}/${lesson.length} lesson selesai',
                      if (periksaUlang != null)
                        'Periksa ulang ${kunciTanggal(periksaUlang)}',
                    ].join('\n'),
                  ),
                  trailing: siapPeriksa
                      ? IconButton(
                          tooltip: 'Mulai periksa ulang ${topik.nama}',
                          icon: const Icon(Icons.replay_rounded),
                          onPressed: () => Navigator.of(context).push(
                            transisiPudar(
                              MasteryScreen(topik: topik, periksaUlang: true),
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          const SizedBox(height: 16),
          Text('Hasil tes penempatan terakhir', style: judul),
          if (data.hasilDiagnostic.isEmpty)
            const Text('Tes penempatan belum selesai.')
          else ...[
            if (diagnostik != null && diagnostik.ditutup)
              Text(kunciTanggal(diagnostik.jawaban.last.waktu)),
            for (final hasil in data.hasilDiagnostic)
              Text(
                '${_namaTopik(hasil.topikId)} · ${hasil.benar}/${hasil.total} benar',
              ),
          ],
          const SizedBox(height: 24),
          Text('Tes penguasaan terakhir', style: judul),
          if (hasilTes.isEmpty) const Text('Belum ada tes penguasaan.'),
          for (final hasil in hasilTes.take(8))
            Text(
              '${_namaTopik(hasil.topikId)} · ${hasil.skor}% · '
              '${hasil.lulus ? 'Bukti awal tercatat' : 'Ambang tes belum tercapai'} · '
              '${kunciTanggal(hasil.waktu)}',
            ),
          const SizedBox(height: 24),
          Text('Aktivitas belajar', style: judul),
          Text(
            aktivitasTerakhir == null
                ? 'Belum ada aktivitas tersimpan.'
                : 'Terakhir belajar $aktivitasTerakhir. '
                      '${data.streakLog.length} hari aktif tercatat.',
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => onReset(context, ref),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Hapus data dan mulai dari awal'),
          ),
        ],
      ),
    );
  }

  String _namaTopik(String id) =>
      daftarTopik.where((t) => t.id == id).firstOrNull?.nama ?? id;
}
