import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/data/repositories/local_numi_repository.dart';

class PreferensiMenolak extends Fake implements SharedPreferences {
  @override
  Future<bool> setString(String key, String value) async => false;

  @override
  Future<bool> remove(String key) async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hasil tulis false menjadi gagal simpan, bukan keberhasilan', () async {
    final repo = LocalNumiRepository(PreferensiMenolak());
    await expectLater(
      repo.simpan(const DataBelajar(xp: 120)),
      throwsStateError,
    );
  });

  test('hasil hapus false menjadi kegagalan yang dapat ditangani', () async {
    final repo = LocalNumiRepository(PreferensiMenolak());
    await expectLater(repo.hapus(), throwsStateError);
  });

  test(
    'profil kelas dan progres dapat dimuat ulang melalui repository lokal',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = LocalNumiRepository(prefs);
      await repo.simpan(
        DataBelajar(
          siswa: Siswa(
            id: 'anak',
            nama: 'Sari',
            kelas: 6,
            dibuatPada: DateTime(2026, 10, 30),
          ),
          xp: 120,
        ),
      );
      final pulih = await LocalNumiRepository(prefs).muat();
      expect(pulih.siswa!.kelas, 6);
      expect(pulih.siswa!.id, 'anak');
      expect(pulih.xp, 120);
      await repo.hapus();
      expect((await repo.muat()).siswa, isNull);
    },
  );
}
