import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/data/models/data_belajar.dart';

void main() {
  test('enam kelas diturunkan menjadi tiga kelompok fase', () {
    for (var kelas = 1; kelas <= 6; kelas++) {
      final siswa = Siswa(
        id: 'anak',
        nama: 'Sari',
        kelas: kelas,
        dibuatPada: DateTime(2026, 10, 30),
      );
      expect(siswa.kelompokKelas, KelompokKelas.values[(kelas - 1) ~/ 2]);
      expect(Siswa.fromJson(siswa.toJson()).kelas, kelas);
    }
  });

  test('usia lama tidak ditebak menjadi kelas dan riwayat tidak terhapus', () {
    final lama = DataBelajar.fromJson({
      'siswa': {
        'id': 'lama',
        'nama': 'Sari',
        'usia': 10,
        'kelompokBelajar': 'besar',
        'dibuatPada': '2026-09-20T09:00:00.000',
      },
      'xp': 120,
    });
    expect(lama.siswa!.kelas, isNull);
    expect(lama.siswa!.perluKonfirmasiKelas, isTrue);
    final baru = lama.copyWith(siswa: lama.siswa!.copyWith(kelas: 4));
    final pulih = DataBelajar.fromJson(baru.toJson());
    expect(pulih.siswa!.id, 'lama');
    expect(pulih.siswa!.kelas, 4);
    expect(pulih.xp, 120);
    expect(pulih.siswa!.dibuatPada, DateTime(2026, 9, 20, 9));
  });
}
