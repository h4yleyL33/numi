import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/repositories/local_numi_repository.dart';
import 'state/numi_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Data dimuat sebelum layar pertama tampil, supaya splash langsung tahu
  // harus ke onboarding, diagnostic, atau peta.
  final repository = LocalNumiRepository(await SharedPreferences.getInstance());
  final data = await repository.muat();

  runApp(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
        dataAwalProvider.overrideWithValue(data),
      ],
      child: const NumiApp(),
    ),
  );
}
