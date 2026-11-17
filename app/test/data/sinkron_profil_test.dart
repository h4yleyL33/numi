import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/repositories/cloud_profil_repository.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';

class _Server implements CloudProfilRepository {
  final profil = <String, DataBelajar>{};
  bool offline = false;
  bool putusSesudahCommit = false;
  int baca = 0;
  int commit = 0;

  @override
  Future<Map<String, DataBelajar>> daftar() async {
    baca++;
    if (offline) throw StateError('Offline');
    return {...profil};
  }

  @override
  Future<bool> simpan(DataBelajar data, {required String? versiDasar}) async {
    final id = data.siswa!.id;
    final lama = profil[id];
    if ((lama == null ? null : sidikDataBelajar(lama)) != versiDasar) {
      return false;
    }
    profil[id] = data;
    commit++;
    if (putusSesudahCommit) throw StateError('Respons commit terputus');
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'offline, restart dan respons commit hilang mempertahankan satu snapshot',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = await newDatabaseFactoryMemory().openDatabase('a');
      addTearDown(db.close);
      final server = _Server();
      LocalProfilRepository repo() => LocalProfilRepository(
        prefs,
        uid: 'wali',
        uidAktif: () => 'wali',
        database: db,
        cloud: server,
      );
      final awal = repo();
      final anak = await awal.tambah(nama: 'Raka', kelas: 2);
      expect(await awal.sinkron(tarik: false), HasilSinkronProfil.lokal);
      expect(server.baca, 0);

      await awal.aturCloud(true);
      server.offline = true;
      final sesi = awal.untukProfil(anak.id);
      await sesi.simpan((await sesi.muat()).copyWith(xp: 10));
      expect(await awal.sinkron(tarik: false), HasilSinkronProfil.tertunda);

      server.offline = false;
      server.putusSesudahCommit = true;
      expect(await repo().sinkron(tarik: false), HasilSinkronProfil.tertunda);
      expect(server.commit, 1);
      expect(server.profil[anak.id]!.xp, 10);

      await sesi.simpan((await sesi.muat()).copyWith(xp: 20));
      server.putusSesudahCommit = false;
      expect(await repo().sinkron(tarik: false), HasilSinkronProfil.selesai);
      expect(await repo().sinkron(tarik: false), HasilSinkronProfil.selesai);
      expect(server.commit, 2);
      expect(server.profil[anak.id]!.xp, 20);
    },
  );

  test(
    'perangkat baru dapat memulihkan profil dan konflik menjaga dua salinan',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final perangkat = newDatabaseFactoryMemory();
      final server = _Server();
      Future<LocalProfilRepository> buatRepo(String nama) async {
        final db = await perangkat.openDatabase(nama);
        addTearDown(db.close);
        final repo = LocalProfilRepository(
          prefs,
          uid: 'wali',
          uidAktif: () => 'wali',
          database: db,
          cloud: server,
        );
        await repo.aturCloud(true);
        return repo;
      }

      final a = await buatRepo('a');
      final b = await buatRepo('b');
      final anak = await a.tambah(nama: 'Sari', kelas: 4);
      expect(await a.sinkron(tarik: false), HasilSinkronProfil.selesai);
      expect(await b.sinkron(tarik: false), HasilSinkronProfil.tertunda);
      expect(await b.daftar(), isEmpty);
      expect(await b.sinkron(tarik: true), HasilSinkronProfil.selesai);
      expect((await b.daftar()).single.id, anak.id);

      final sesiA = a.untukProfil(anak.id);
      final sesiB = b.untukProfil(anak.id);
      await sesiA.simpan((await sesiA.muat()).copyWith(xp: 10));
      await sesiB.simpan((await sesiB.muat()).copyWith(xp: 20));
      expect(await a.sinkron(tarik: false), HasilSinkronProfil.selesai);
      expect(await b.sinkron(tarik: true), HasilSinkronProfil.konflik);
      expect((await sesiB.muat()).xp, 20);
      expect(server.profil[anak.id]!.xp, 10);
    },
  );
}
