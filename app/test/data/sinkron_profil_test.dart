import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/repositories/cloud_profil_repository.dart';
import 'package:numi/data/repositories/local_profil_repository.dart';

class ServerProfilUji implements CloudProfilRepository {
  final profil = <String, DataBelajar>{};
  bool offline = false;
  bool putusSesudahCommit = false;
  int baca = 0;
  int commit = 0;
  final tidakValid = <String>{};

  @override
  Future<DaftarProfilCloud> daftar() async {
    baca++;
    if (offline) throw StateError('Offline');
    return DaftarProfilCloud({...profil}, tidakValid: tidakValid);
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
      final server = ServerProfilUji();
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
      final server = ServerProfilUji();
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
      final konflik = b.konflik.single;
      await b.selesaikanKonflik(konflik, gunakanCloud: true);
      expect((await b.untukProfil(anak.id).muat()).xp, 10);
      expect(await b.sinkron(tarik: true), HasilSinkronProfil.selesai);

      await sesiA.simpan((await sesiA.muat()).copyWith(xp: 30));
      final sesiBaruB = b.untukProfil(anak.id);
      await sesiBaruB.simpan((await sesiBaruB.muat()).copyWith(xp: 40));
      await a.sinkron(tarik: false);
      expect(await b.sinkron(tarik: true), HasilSinkronProfil.konflik);
      final konflikKedua = b.konflik.single;
      // Versi cloud berubah setelah dialog dibuka: pilihan lama harus ditolak.
      await sesiA.simpan((await sesiA.muat()).copyWith(xp: 50));
      await a.sinkron(tarik: false);
      await expectLater(
        b.selesaikanKonflik(konflikKedua, gunakanCloud: false),
        throwsStateError,
      );
      expect(server.profil[anak.id]!.xp, 50);
      expect((await sesiBaruB.muat()).xp, 40);
      await b.sinkron(tarik: true);
      await b.selesaikanKonflik(b.konflik.single, gunakanCloud: false);
      expect(server.profil[anak.id]!.xp, 40);
      expect(await b.sinkron(tarik: true), HasilSinkronProfil.selesai);
      final cadangan = await stringMapStoreFactory
          .store('cadangan-konflik')
          .find(b.database!);
      expect(cadangan, hasLength(2));
      expect(cadangan.first.value.keys, containsAll(['lokal', 'cloud']));
    },
  );

  test(
    'profil tidak valid tidak ditimpa, profil sehat tetap dikirim',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = await newDatabaseFactoryMemory().openDatabase('rusak');
      addTearDown(db.close);
      final server = ServerProfilUji();
      final repo = LocalProfilRepository(
        prefs,
        uid: 'wali',
        uidAktif: () => 'wali',
        database: db,
        cloud: server,
      );
      final rusak = await repo.tambah(nama: 'Lokal tetap aman', kelas: 1);
      final sehat = await repo.tambah(nama: 'Sehat', kelas: 2);
      server.tidakValid.add(rusak.id);
      await repo.aturCloud(true);
      expect(
        await repo.sinkron(tarik: true),
        HasilSinkronProfil.dataTidakValid,
      );
      expect(server.profil.keys, [sehat.id]);
      expect((await repo.daftar()).map((s) => s.id), contains(rusak.id));
    },
  );
}
