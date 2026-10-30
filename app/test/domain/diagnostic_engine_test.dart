import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/domain/diagnostic_engine.dart';
import 'package:numi/domain/skill_map_service.dart';

void main() {
  SesiDiagnostic sesiBaru(int kelas) => SesiDiagnostic(
    topik: daftarTopik,
    kelas: kelas,
    generator: GeneratorSoal(Random(1)),
  );

  /// Menjalankan sesi dengan pola jawaban: fungsi menerima id topik dan
  /// mengembalikan berapa soal yang dijawab benar.
  HasilAkhirDiagnostic jalankan(
    SesiDiagnostic sesi,
    int Function(String topikId) benar,
  ) {
    final diuji = <String>[];
    while (!sesi.selesai) {
      diuji.add(sesi.topikSekarang.id);
      sesi.catat(benar(sesi.topikSekarang.id));
    }
    return sesi.hasilAkhir();
  }

  test('enam kelas memilih enam titik awal yang berbeda', () {
    for (final (i, id) in ['T01', 'T02', 'T06', 'T07', 'T10', 'T11'].indexed) {
      expect(sesiBaru(i + 1).topikSekarang.id, id);
    }
    expect(() => sesiBaru(0), throwsRangeError);
    expect(() => sesiBaru(7), throwsRangeError);
  });

  test('setiap topik diuji dengan dua soal', () {
    expect(sesiBaru(1).soalSekarang, hasLength(2));
  });

  test('semua benar: tes naik sampai batas topik diagnostic', () {
    final hasil = jalankan(sesiBaru(1), (_) => 2);
    expect(hasil.hasilPerTopik, hasLength(6));
    for (final id in ['T01', 'T02', 'T03', 'T04', 'T05', 'T06']) {
      expect(hasil.statusAwal[id], StatusTopik.mastered, reason: id);
    }
    expect(hasil.statusAwal['T07'], StatusTopik.terkunci);
    expect(
      hasil.kelompok,
      KelompokKelas.faseA,
      reason: 'skor tidak mengubah kelas',
    );
  });

  test(
    'salah di topik awal: tes turun sampai menemukan topik yang dikuasai',
    () {
      final hasil = jalankan(sesiBaru(4), (id) => id == 'T07' ? 0 : 2);
      expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T07', 'T06']);
      expect(hasil.statusAwal['T07'], StatusTopik.belumDikuasai);
      expect(hasil.statusAwal['T06'], StatusTopik.mastered);
      // Topik di bawah titik uji dianggap sudah dikuasai.
      expect(hasil.statusAwal['T01'], StatusTopik.mastered);
      expect(hasil.statusAwal['T12'], StatusTopik.terkunci);
      expect(hasil.kelompok, KelompokKelas.faseB);
    },
  );

  test('salah terus sampai topik pertama tidak mengganti kelas profil', () {
    final hasil = jalankan(sesiBaru(2), (_) => 0);
    expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T02', 'T01']);
    expect(hasil.statusAwal['T01'], StatusTopik.belumDikuasai);
    expect(hasil.kelas, 2);
    expect(hasil.kelompok, KelompokKelas.faseA);
  });

  test('satu dari dua benar dicatat sebagai perlu latihan', () {
    final hasil = jalankan(sesiBaru(1), (id) => id == 'T01' ? 2 : 1);
    expect(hasil.statusAwal['T02'], StatusTopik.perluLatihan);
    expect(hasil.kelompok, KelompokKelas.faseA);
  });

  test('skill map membuka topik yang prasyaratnya sudah dikuasai', () {
    final hasil = jalankan(sesiBaru(4), (id) => id == 'T07' ? 0 : 2);
    final status = SkillMapService(daftarTopik).bukaTopik(hasil.statusAwal);
    expect(status['T07'], StatusTopik.belumDikuasai);
    expect(status['T08'], StatusTopik.terkunci, reason: 'T08 butuh T07');
    expect(status['T09'], StatusTopik.terkunci);
  });
}
