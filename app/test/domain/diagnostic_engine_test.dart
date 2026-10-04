import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/content/generator_soal.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/domain/diagnostic_engine.dart';
import 'package:numi/domain/skill_map_service.dart';

void main() {
  SesiDiagnostic sesiBaru(int usia) =>
      SesiDiagnostic(topik: daftarTopik, usia: usia, generator: GeneratorSoal(Random(1)));

  /// Menjalankan sesi dengan pola jawaban: fungsi menerima id topik dan
  /// mengembalikan berapa soal yang dijawab benar.
  HasilAkhirDiagnostic jalankan(SesiDiagnostic sesi, int Function(String topikId) benar) {
    final diuji = <String>[];
    while (!sesi.selesai) {
      diuji.add(sesi.topikSekarang.id);
      sesi.catat(benar(sesi.topikSekarang.id));
    }
    return sesi.hasilAkhir();
  }

  test('usia menentukan topik pertama yang diuji', () {
    expect(sesiBaru(6).topikSekarang.id, 'T01');
    expect(sesiBaru(8).topikSekarang.id, 'T03');
    expect(sesiBaru(9).topikSekarang.id, 'T06');
    expect(sesiBaru(10).topikSekarang.id, 'T07');
    expect(sesiBaru(12).topikSekarang.id, 'T08');
  });

  test('setiap topik diuji dengan dua soal', () {
    expect(sesiBaru(7).soalSekarang, hasLength(2));
  });

  test('semua benar: tes naik sampai batas topik diagnostic', () {
    final hasil = jalankan(sesiBaru(7), (_) => 2);
    expect(hasil.hasilPerTopik, hasLength(6));
    for (final id in ['T01', 'T02', 'T03', 'T04', 'T05', 'T06']) {
      expect(hasil.statusAwal[id], StatusTopik.mastered, reason: id);
    }
    expect(hasil.statusAwal['T07'], StatusTopik.terkunci);
    expect(hasil.kelompok, KelompokBelajar.besar);
  });

  test('salah di topik awal: tes turun sampai menemukan topik yang dikuasai', () {
    final hasil = jalankan(sesiBaru(10), (id) => id == 'T07' ? 0 : 2);
    expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T07', 'T06']);
    expect(hasil.statusAwal['T07'], StatusTopik.belumDikuasai);
    expect(hasil.statusAwal['T06'], StatusTopik.mastered);
    // Topik di bawah titik uji dianggap sudah dikuasai.
    expect(hasil.statusAwal['T01'], StatusTopik.mastered);
    expect(hasil.statusAwal['T12'], StatusTopik.terkunci);
    expect(hasil.kelompok, KelompokBelajar.besar);
  });

  test('salah terus sampai topik pertama: masuk kelas kecil', () {
    final hasil = jalankan(sesiBaru(8), (_) => 0);
    expect(hasil.hasilPerTopik.map((h) => h.topikId), ['T03', 'T02', 'T01']);
    expect(hasil.statusAwal['T01'], StatusTopik.belumDikuasai);
    expect(hasil.kelompok, KelompokBelajar.kecil);
  });

  test('satu dari dua benar dicatat sebagai perlu latihan', () {
    final hasil = jalankan(sesiBaru(6), (id) => id == 'T01' ? 2 : 1);
    expect(hasil.statusAwal['T02'], StatusTopik.perluLatihan);
    expect(hasil.kelompok, KelompokBelajar.kecil);
  });

  test('skill map membuka topik yang prasyaratnya sudah dikuasai', () {
    final hasil = jalankan(sesiBaru(10), (id) => id == 'T07' ? 0 : 2);
    final status = SkillMapService(daftarTopik).bukaTopik(hasil.statusAwal);
    expect(status['T07'], StatusTopik.belumDikuasai);
    expect(status['T08'], StatusTopik.terkunci, reason: 'T08 butuh T07');
    expect(status['T09'], StatusTopik.terkunci);
  });
}
