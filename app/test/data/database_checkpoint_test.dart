import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numi/data/models/sesi_mastery.dart';
import 'package:numi/data/models/checkpoint_diagnostic.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';
import 'package:numi/data/repositories/local_numi_repository.dart';

import '../state/checkpoint_mastery_test.dart'
    show soalCheckpoint, jawabCheckpoint, profilSiap;
import '../state/checkpoint_alur_test.dart' show responsSoal;
import '../domain/checkpoint_diagnostic_test.dart' show jawabDiagnostic;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory direktori;
  late Database db;
  late SharedPreferences prefs;
  String? uid = 'wali-a';
  LocalProfilRepository repo() => LocalProfilRepository(
    prefs,
    uid: 'wali-a',
    uidAktif: () => uid,
    database: db,
  );
  setUp(() async {
    direktori = await Directory.systemTemp.createTemp('numi-checkpoint-');
    db = await databaseFactoryIo.openDatabase('${direktori.path}/data.db');
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    uid = 'wali-a';
  });
  tearDown(() async {
    await db.close();
    await direktori.delete(recursive: true);
  });

  test('file profil memulihkan blok adaptif berikutnya dan pembahasan lesson, saudara tetap terpisah', () async {
    final wali = repo();
    final a = await wali.tambah(nama: 'Sari', kelas: 1);
    final b = await wali.tambah(nama: 'Budi', kelas: 2);
    final belajar = wali.untukProfil(a.id);
    final awal = await belajar.muat();
    var diagnostic = CheckpointDiagnostic.mulai('diag-file', 1);
    final blok = diagnostic.blok.first;
    for (var i = 0; i < 2; i++) {
      diagnostic = diagnostic.catat(
        blok.commandId(i),
        jawabDiagnostic(blok, i),
      );
    }
    var lesson = SesiSoal(
      id: 'lesson-file',
      topikId: 'T01',
      soal: soalCheckpoint,
      konteks: KonteksJawaban.lesson,
      lessonId: 'T01-kenalan',
      mulaiPada: DateTime(2026),
    );
    lesson = lesson.catat(
      lesson.commandId(0),
      responsSoal(lesson.soal.first, lesson.konteks),
    );
    await belajar.simpan(
      awal.copyWith(
        sesiDiagnostic: diagnostic,
        sesiLesson: {lesson.lessonId!: lesson},
      ),
    );
    await db.close();
    db = await databaseFactoryIo.openDatabase('${direktori.path}/data.db');
    final pulih = await repo().untukProfil(a.id).muat();
    expect(pulih.sesiDiagnostic!.toJson(), diagnostic.toJson());
    expect(pulih.sesiLesson[lesson.lessonId]!.toJson(), lesson.toJson());
    expect(pulih.sesiLesson[lesson.lessonId]!.menungguLanjut, isTrue);
    expect((await repo().untukProfil(b.id).muat()).sesiDiagnostic, isNull);
  });

  test(
    'database dibuka sesudah UID diperiksa dan kegagalan buka bisa dicoba lagi',
    () async {
      var dibuka = 0;
      final wali = LocalProfilRepository(
        prefs,
        uid: 'wali-a',
        uidAktif: () => uid,
        databaseUntuk: () async {
          dibuka++;
          if (dibuka == 1) throw StateError('Direktori belum tersedia');
          return db;
        },
      );
      uid = null;
      await expectLater(wali.daftar(), throwsStateError);
      expect(dibuka, 0);
      uid = 'wali-a';
      await expectLater(wali.daftar(), throwsStateError);
      expect(await wali.daftar(), isEmpty);
      expect(dibuka, 2);
      await wali.daftar();
      expect(dibuka, 2);
    },
  );

  test(
    'migrasi cache ber-UID menjaga progres dan checkpoint pulih dari file',
    () async {
      final lama = LocalProfilRepository(
        prefs,
        uid: 'wali-a',
        uidAktif: () => uid,
      );
      final anak = await lama.tambah(nama: 'Sari', kelas: 1);
      final lamaProfil = lama.untukProfil(anak.id);
      await lamaProfil.simpan((await lamaProfil.muat()).copyWith(xp: 70));
      final baru = repo();
      final belajar = baru.untukProfil(anak.id);
      final data = await belajar.muat();
      final sesi = SesiMastery(
        id: 'sesi-a',
        topikId: 'T01',
        soal: soalCheckpoint,
      );
      await belajar.simpan(
        data.copyWith(
          sesiMastery: {
            'T01': sesi.catat(
              sesi.commandId(0),
              jawabCheckpoint(sesi.soal.first),
            ),
          },
        ),
      );
      await db.close();
      db = await databaseFactoryIo.openDatabase('${direktori.path}/data.db');
      final pulih = await repo().untukProfil(anak.id).muat();
      expect(pulih.xp, 70);
      expect(pulih.sesiMastery['T01']!.jawaban.length, 1);
      expect(
        pulih.sesiMastery['T01']!.soal.map((s) => s.toJson()),
        sesi.soal.map((s) => s.toJson()),
      );
      expect(
        prefs.getKeys(),
        hasLength(1),
        reason: 'Salinan lama dipertahankan.',
      );
      uid = 'wali-b';
      await expectLater(repo().daftar(), throwsStateError);
    },
  );

  test(
    'snapshot dari sesi lain ditolak, perubahan profil saudara tetap utuh',
    () async {
      final wali = repo();
      final a = await wali.tambah(nama: 'Sari', kelas: 1);
      final b = await wali.tambah(nama: 'Budi', kelas: 2);
      final pertama = wali.untukProfil(a.id);
      final kedua = repo().untukProfil(a.id);
      final da = await pertama.muat();
      final dbLama = await kedua.muat();
      await pertama.simpan(da.copyWith(xp: 70));
      await expectLater(kedua.simpan(dbLama.copyWith(xp: 5)), throwsStateError);
      expect((await wali.untukProfil(a.id).muat()).xp, 70);
      expect((await wali.untukProfil(b.id).muat()).xp, 0);
      await expectLater(
        wali.untukProfil(a.id).simpan(da),
        throwsStateError,
        reason: 'Wajib muat sebelum menulis.',
      );
    },
  );

  test('database tertutup menolak simpan dan demo reset tidak menghidupkan cache lama', () async {
    final demo = LocalNumiRepository(prefs, database: db);
    await prefs.setString(
      'numi.data_belajar.v1',
      jsonEncode(profilSiap().copyWith(xp: 70).toJson()),
    );
    expect((await demo.muat()).xp, 70);
    await demo.hapus();
    expect((await demo.muat()).sudahDaftar, isFalse);
    await db.close();
    await expectLater(demo.simpan(profilSiap()), throwsA(isA<Exception>()));
    db = await databaseFactoryIo.openDatabase('${direktori.path}/data.db');
    expect((await LocalNumiRepository(prefs, database: db).muat()).xp, 0);
  });

  test('cache ber-UID rusak tidak diimpor atau ditimpa database', () async {
    final kunci = 'numi.wali.v1.${base64Url.encode(utf8.encode('wali-a'))}';
    await prefs.setString(kunci, '{rusak');
    await expectLater(
      repo().tambah(nama: 'Sari', kelas: 1),
      throwsFormatException,
    );
    expect(
      await StoreRef<String, String>('wali').record('wali-a').get(db),
      isNull,
    );
    expect(prefs.getString(kunci), '{rusak');
  });
}
