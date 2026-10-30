import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/content/paket_kelas.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/domain/diagnostic_engine.dart';

void main() {
  SesiDiagnostic sesiBaru(int kelas) =>
      SesiDiagnostic(topik: daftarTopik, kelas: kelas);
  HasilAkhirDiagnostic jalankan(
    SesiDiagnostic sesi,
    int Function(String) benar,
  ) {
    while (!sesi.selesai) {
      sesi.catat(benar(sesi.topikSekarang.id));
    }
    return sesi.hasilAkhir();
  }

  test('enam kelas memakai butir awal berversi yang berbeda', () {
    final ids = <String>{};
    for (final paket in PaketKelas.daftar) {
      final sesi = sesiBaru(paket.kelas);
      expect(sesi.topikSekarang.id, paket.topikAwal);
      expect(
        sesi.soalSekarang.map((s) => s.id),
        paket.butirAwal.map((s) => s.id),
      );
      expect(sesi.soalSekarang, hasLength(2));
      expect(paket.statusValidasi, 'draft-belum-divalidasi');
      for (final soal in sesi.soalSekarang) {
        expect(ids.add(soal.id), isTrue);
        expect(soal.pilihan, contains(soal.jawabanBenar));
        expect(soal.versi, paket.versi);
        expect(soal.skillId, isNotEmpty);
        expect(soal.penjelasan, isNotEmpty);
      }
    }
    expect(ids, hasLength(12));
    expect(() => sesiBaru(0), throwsRangeError);
    expect(() => sesiBaru(7), throwsRangeError);
  });

  test(
    'semua benar hanya memberi indikasi siap pada paling banyak enam jangkar',
    () {
      final hasil = jalankan(sesiBaru(1), (_) => 2);
      expect(hasil.hasilPerTopik, hasLength(6));
      expect(hasil.statusAwal.values, isNot(contains(StatusTopik.mastered)));
      expect(hasil.statusAwal['T01'], StatusTopik.siapLanjut);
      expect(hasil.statusAwal['T07'], StatusTopik.belumDiuji);
      expect(hasil.kelompok, KelompokKelas.faseA);
    },
  );

  test('turun mencari prasyarat tidak menguasai topik yang tidak diuji', () {
    final hasil = jalankan(sesiBaru(4), (id) => id == 'T07' ? 0 : 2);
    expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T07', 'T06']);
    expect(hasil.statusAwal['T07'], StatusTopik.perluLatihan);
    expect(hasil.statusAwal['T06'], StatusTopik.siapLanjut);
    expect(hasil.statusAwal['T01'], StatusTopik.belumDiuji);
    expect(hasil.statusAwal['T12'], StatusTopik.belumDiuji);
    expect(hasil.kelompok, KelompokKelas.faseB);
  });

  test(
    'salah terus tidak mengubah kelas dan semua hasil hanya indikasi latihan',
    () {
      final hasil = jalankan(sesiBaru(2), (_) => 0);
      expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T02', 'T01']);
      expect(
        hasil.hasilPerTopik.every(
          (h) => h.statusPenguasaan == StatusTopik.perluLatihan,
        ),
        isTrue,
      );
      expect(hasil.kelas, 2);
    },
  );

  test('hasil belum selesai dan jumlah benar di luar batas ditolak', () {
    final sesi = sesiBaru(1);
    expect(() => sesi.hasilAkhir(), throwsStateError);
    expect(() => sesi.catat(-1), throwsRangeError);
    expect(() => sesi.catat(3), throwsRangeError);
  });
}
