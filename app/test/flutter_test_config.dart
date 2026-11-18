import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Muat font nyata (Roboto + MaterialIcons dari SDK Flutter) supaya golden
/// file berisi teks yang benar-benar terbaca, bukan kotak placeholder.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final kandidatAkar = <String>[
    if (Platform.environment['FLUTTER_ROOT'] != null)
      Platform.environment['FLUTTER_ROOT']!,
    r'E:/D/khalee/flutter',
    r'D:/khalee/flutter',
  ];
  String? cari(String relatif) {
    for (final akar in kandidatAkar) {
      final f = File('$akar/$relatif');
      if (f.existsSync()) return f.path;
    }
    return null;
  }

  final fontMateri =
      cari('bin/cache/artifacts/material_fonts/materialicons-regular.otf') ??
      cari('bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');

  Future<void> muat(String keluarga, List<String?> berkas) async {
    final ada = berkas.whereType<String>().toList();
    if (ada.isEmpty) return;
    final loader = FontLoader(keluarga);
    for (final p in ada) {
      final byte = File(p).readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(byte.buffer)));
    }
    await loader.load();
  }

  await muat('Roboto', [
    cari('bin/cache/artifacts/material_fonts/roboto-regular.ttf'),
    cari('bin/cache/artifacts/material_fonts/roboto-bold.ttf'),
    cari('bin/cache/artifacts/material_fonts/roboto-medium.ttf'),
  ]);
  await muat('MaterialIcons', [fontMateri]);
  // Beberapa widget memakai keluarga kosong -> ikutkan Roboto sebagai default.
  await muat('', [
    cari('bin/cache/artifacts/material_fonts/roboto-regular.ttf'),
  ]);

  await testMain();
}
