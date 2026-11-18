import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/data/models/soal.dart';
import 'package:numi/data/repositories/cloud_profil_repository.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';
import 'package:numi/firebase_options.dart';

void periksa(bool kondisi, String pesan) {
  if (!kondisi) throw StateError(pesan);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<void>(
            future: _verifikasi(),
            builder: (context, hasil) {
              return Text(
                hasil.hasError
                    ? 'NUMI_FIREBASE_GAGAL: ${hasil.error}'
                    : hasil.connectionState == ConnectionState.done
                    ? 'NUMI_FIREBASE_LULUS'
                    : 'Memeriksa Firebase Emulator',
              );
            },
          ),
        ),
      ),
    ),
  );
}

Future<void> _verifikasi() async {
  try {
    await _ujiEmulator();
    debugPrint('NUMI_FIREBASE_LULUS');
  } catch (e, stack) {
    debugPrint('NUMI_FIREBASE_GAGAL: $e\n$stack');
    rethrow;
  }
}

Future<void> _ujiEmulator() async {
  const host = String.fromEnvironment(
    'NUMI_FIREBASE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );
  final app = await Firebase.initializeApp(
    name: 'numi-integrasi',
    options: DefaultFirebaseOptions.emulator,
  );
  final auth = FirebaseAuth.instanceFor(app: app);
  final firestore = FirebaseFirestore.instanceFor(app: app);
  firestore.settings = const Settings(
    persistenceEnabled: false,
    webExperimentalForceLongPolling: true,
  );
  await auth.useAuthEmulator(host, 9099);
  firestore.useFirestoreEmulator(host, 8080);

  final uid = (await auth.signInAnonymously()).user!.uid;
  final cloud = FirestoreProfilRepository(firestore, uid);
  final prefs = await SharedPreferences.getInstance();
  final factory = newDatabaseFactoryMemory();
  final dbA = await factory.openDatabase('perangkat-a');
  final dbB = await factory.openDatabase('perangkat-b');
  LocalProfilRepository repo(Database db) => LocalProfilRepository(
    prefs,
    uid: uid,
    uidAktif: () => auth.currentUser?.uid,
    database: db,
    cloud: cloud,
  );

  final a = repo(dbA);
  final b = repo(dbB);
  final siswa = await a.tambah(nama: 'Profil uji', kelas: 1);
  final soal = GeneratorSoal().buat('T01', 5);
  periksa(
    soal.any((s) => s.jenis == JenisSoal.pasangkan),
    'Butir pasangan absen',
  );
  final sesi = SesiSoal(
    id: 'lesson-uji',
    topikId: 'T01',
    soal: soal,
    konteks: KonteksJawaban.lesson,
    lessonId: 'T01-L1',
    mulaiPada: DateTime.now(),
  );
  final belajar = a.untukProfil(siswa.id);
  await belajar.simpan(
    (await belajar.muat()).copyWith(sesiLesson: {sesi.lessonId!: sesi}),
  );
  await a.aturCloud(true);
  periksa(
    await a.sinkron(tarik: false) == HasilSinkronProfil.selesai,
    'Unggah',
  );
  periksa(
    await b.sinkron(tarik: true) == HasilSinkronProfil.selesai,
    'Pulihkan',
  );
  final pulih = await b.untukProfil(siswa.id).muat();
  periksa(
    pulih.sesiLesson[sesi.lessonId]?.soal.length == soal.length,
    'Checkpoint tidak utuh',
  );

  await auth.signOut();
  final orangLain = (await auth.signInAnonymously()).user!.uid;
  periksa(orangLain != uid, 'UID uji harus berbeda');
  try {
    await cloud.daftar();
    throw StateError('Pembacaan antar-UID diizinkan.');
  } on FirebaseException catch (e) {
    periksa(e.code == 'permission-denied', 'Penolakan tidak sesuai: ${e.code}');
  }
  await auth.signOut();
  await dbA.close();
  await dbB.close();
}
