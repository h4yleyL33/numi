// Jalankan dari app/: dart run tool/verifikasi_checkpoint_proses.dart
// Probe file Sembast pada host; pengujian proses Android tetap terpisah.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sembast/sembast_io.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/data/models/soal.dart';

Future<void> main(List<String> args) async {
  final record = StoreRef<String, String>('probe').record('sesi');
  if (args.isNotEmpty && args.first == 'tulis') {
    final db = await databaseFactoryIo.openDatabase(args[1]);
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
    final sesi = SesiMastery(id: 'probe-sesi', topikId: 'T01', soal: soal);
    final tersimpan = sesi.catat(
      sesi.commandId(0),
      Jawaban(
        soalId: soal.first.id,
        topikId: 'T01',
        jawaban: '3',
        benar: false,
        waktu: DateTime.utc(2026, 10, 30),
        konteks: KonteksJawaban.mastery,
        versiButir: 'probe-v1',
      ),
    );
    await db.transaction(
      (txn) => record.put(txn, jsonEncode(tersimpan.toJson())),
    );
    stdout.writeln('COMMIT');
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
    final path = '${direktori.path}/probe.db';
    proses = await Process.start(Platform.resolvedExecutable, [
      '--packages=${File('.dart_tool/package_config.json').absolute.path}',
      Platform.script.toFilePath(),
      'tulis',
      path,
    ]);
    final galat = proses.stderr.transform(utf8.decoder).join();
    final siap = await proses.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first
        .timeout(const Duration(seconds: 15));
    if (siap != 'COMMIT') throw StateError('Writer belum commit: $siap');
    if (!proses.kill()) throw StateError('Writer tidak dapat dihentikan.');
    await proses.exitCode;
    final stderr = await galat;
    if (stderr.isNotEmpty) throw StateError(stderr);
    db = await databaseFactoryIo.openDatabase(path);
    final teks = await record.get(db);
    if (teks == null) {
      throw StateError('Checkpoint hilang sesudah proses berhenti.');
    }
    final sesi = SesiMastery.fromJson(jsonDecode(teks) as Map<String, dynamic>);
    if (sesi.jawaban.length != 1 ||
        sesi.jawaban.single.jawaban != '3' ||
        sesi.jawaban.single.benar ||
        sesi.soal.length != 5 ||
        sesi.soal.first.pilihan.join(',') != '3,2' ||
        sesi.soal.first.versi != 'probe-v1' ||
        sesi.commandId(0) != 'probe-sesi/respons/0') {
      throw StateError('Respons, cursor, atau snapshot berubah.');
    }
    stdout.writeln(
      'LULUS: writer dihentikan tanpa close; 1 respons pertama, '
      'cursor, 5 soal, urutan pilihan, versi, dan command ID pulih.',
    );
  } finally {
    proses?.kill();
    await db?.close();
    await direktori.delete(recursive: true);
  }
}
