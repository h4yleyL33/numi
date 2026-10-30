// Jalankan dari app/: dart run tool/verifikasi_checkpoint_proses.dart
// Probe file Sembast pada host; pengujian proses Android tetap terpisah.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sembast/sembast_io.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/checkpoint_diagnostic.dart';
import 'package:numi/data/models/sesi_soal.dart';
import 'package:numi/data/models/soal.dart';

Map<String, dynamic> buatSnapshot(KonteksJawaban konteks) {
  Jawaban respons(Soal s, bool benar) => Jawaban(
    soalId: s.id,
    topikId: s.topikId,
    jawaban: benar
        ? s.jawabanBenar
        : s.pilihan.firstWhere((p) => p != s.jawabanBenar),
    benar: benar,
    waktu: DateTime.utc(2026, 10, 30),
    konteks: konteks,
    skillId: s.skillId,
    versiButir: s.versi,
  );
  if (konteks == KonteksJawaban.diagnostic) {
    var sesi = CheckpointDiagnostic.mulai('probe-diagnostic', 1);
    final blok = sesi.blok.first;
    for (var i = 0; i < 2; i++) {
      sesi = sesi.catat(blok.commandId(i), respons(blok.soal[i], true));
    }
    return sesi.toJson();
  }
  final soal = [
    for (var i = 0; i < 5; i++)
      Soal(
        id: 'probe-$i',
        topikId: 'T01',
        jenis: JenisSoal.pilihanGanda,
        pertanyaan: 'Satu tambah satu?',
        pilihan: ['3', '2'],
        jawabanBenar: '2',
        penjelasan: 'Dua.',
        versi: 'probe-v1',
      ),
  ];
  final sesi = SesiSoal(
    id: 'probe-sesi',
    topikId: 'T01',
    soal: soal,
    konteks: konteks,
    lessonId: konteks == KonteksJawaban.lesson ? 'T01-kenalan' : null,
    mulaiPada: konteks == KonteksJawaban.lesson
        ? DateTime.utc(2026, 10, 30)
        : null,
  );
  return sesi.catat(sesi.commandId(0), respons(soal.first, false)).toJson();
}

Future<void> main(List<String> args) async {
  final record = StoreRef<String, String>('probe').record('sesi');
  if (args.isNotEmpty && args.first == 'tulis') {
    final db = await databaseFactoryIo.openDatabase(args[1]);
    final snapshot = jsonEncode(
      buatSnapshot(KonteksJawaban.values.byName(args[2])),
    );
    await db.transaction((txn) => record.put(txn, snapshot));
    stdout.writeln('COMMIT $snapshot');
    await stdout.flush();
    Timer.periodic(const Duration(seconds: 1), (_) {});
    await Completer<void>().future;
    return;
  }
  final direktori = await Directory.systemTemp.createTemp(
    'numi-process-probe-',
  );
  Process? proses;
  Database? db;
  try {
    for (final konteks in KonteksJawaban.values) {
      final path = '${direktori.path}/${konteks.name}.db';
      proses = await Process.start(Platform.resolvedExecutable, [
        '--packages=${File('.dart_tool/package_config.json').absolute.path}',
        Platform.script.toFilePath(),
        'tulis',
        path,
        konteks.name,
      ]);
      final galat = proses.stderr.transform(utf8.decoder).join();
      final siap = await proses.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .first
          .timeout(const Duration(seconds: 15));
      if (!siap.startsWith('COMMIT ')) throw StateError('Writer belum commit.');
      if (!proses.kill()) throw StateError('Writer tidak dapat dihentikan.');
      await proses.exitCode;
      final stderr = await galat;
      if (stderr.isNotEmpty) throw StateError(stderr);
      db = await databaseFactoryIo.openDatabase(path);
      final teks = await record.get(db);
      if (teks == null || teks != siap.substring(7)) {
        throw StateError(
          'Snapshot berubah atau hilang sesudah proses berhenti.',
        );
      }
      final json = jsonDecode(teks) as Map<String, dynamic>;
      if (konteks == KonteksJawaban.diagnostic) {
        final sesi = CheckpointDiagnostic.fromJson(json);
        if (sesi.blok.length != 2 ||
            sesi.jawaban.length != 2 ||
            sesi.blok.last.lengkap) {
          throw StateError('Blok adaptif berikutnya tidak pulih.');
        }
      } else {
        final sesi = SesiSoal.fromJson(json);
        if (sesi.jawaban.length != 1 ||
            sesi.jawaban.single.benar ||
            sesi.menungguLanjut != (konteks == KonteksJawaban.lesson)) {
          throw StateError('Respons pertama atau pembahasan tidak pulih.');
        }
      }
      await db.close();
      db = null;
      stdout.writeln(
        'LULUS ${konteks.name}: writer dihentikan tanpa close; '
        'snapshot, respons pertama, posisi, versi dan urutan pulih identik.',
      );
    }
  } finally {
    proses?.kill();
    await db?.close();
    await direktori.delete(recursive: true);
  }
}
