import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_topik.dart';
import 'package:numi/data/models/bukti_skill.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/domain/skill_map_service.dart';
import 'package:numi/domain/learning_path_service.dart';

void main() {
  test('cache dua butir tidak dapat mengklaim bukti penguasaan awal', () {
    final json = BuktiSkill(
      topikId: 'T01',
      skillId: 'T01-jangkar',
      status: StatusBukti.buktiAwal,
      benar: 2,
      total: 2,
      bantuan: 0,
      sumberSesi: 'lama',
      waktu: DateTime(2026, 10, 30),
      versiKebijakan: 'numi-pilot-v1',
      versiButir: const ['generator-v1'],
    ).toJson();
    expect(() => BuktiSkill.fromJson(json), throwsFormatException);
  });
  test('rekomendasi untuk jangkar belum diuji tetap tersedia dan menjelaskan alasannya', () {
    final data = DataBelajar(
      aksesMateri: SkillMapService(daftarTopik).susunAkses({}),
    );
    final rekomendasi = LearningPathService(daftarTopik).rekomendasi(data);
    expect(rekomendasi!.topik.id, 'T01');
    expect(rekomendasi.lesson, isNotNull);
    expect(rekomendasi.alasan, isNotEmpty);
  });
  test('akses terbuka tidak berarti sudah diuji atau dikuasai', () {
    final data = DataBelajar(
      aksesMateri: {
        'T01': const AksesMateri(
          topikId: 'T01',
          terbuka: true,
          alasan: 'Materi awal',
        ),
      },
    );
    expect(data.statusTopik('T01'), StatusTopik.belumDiuji);
    expect(data.buktiSkill['T01'], isNull);
  });

  test('status gabungan lama tidak diangkat menjadi bukti penguasaan', () {
    final data = DataBelajar.fromJson({
      'versi': 2,
      'xp': 120,
      'skillMap': [
        {
          'topikId': 'T01',
          'status': 'mastered',
          'diperbarui': '2026-10-01T09:00:00.000',
        },
      ],
    });
    expect(data.xp, 120);
    expect(data.skillMap['T01']!.status, StatusTopik.mastered);
    expect(data.statusTopik('T01'), StatusTopik.belumDiuji);
    expect(data.buktiSkill, isEmpty);
  });

  test('bukti dan akses disimpan terpisah saat dimuat ulang', () {
    final bukti = BuktiSkill(
      topikId: 'T02',
      skillId: 'T02-jangkar',
      status: StatusBukti.indikasiSiap,
      benar: 2,
      total: 2,
      bantuan: 0,
      sumberSesi: 'diagnostic-1',
      waktu: DateTime(2026, 10, 30),
      versiKebijakan: 'pilot-v1',
      versiButir: const ['kelas-2-v1'],
    );
    final data = DataBelajar(
      buktiSkill: {'T02': bukti},
      aksesMateri: {
        'T02': const AksesMateri(
          topikId: 'T02',
          terbuka: false,
          alasan: 'Prasyarat perlu dilatih',
        ),
      },
    );
    final pulih = DataBelajar.fromJson(data.toJson());
    expect(pulih.buktiSkill['T02']!.status, StatusBukti.indikasiSiap);
    expect(pulih.buktiSkill['T02']!.total, 2);
    expect(pulih.statusTopik('T02'), StatusTopik.terkunci);
    expect(pulih.aksesMateri['T02']!.alasan, 'Prasyarat perlu dilatih');
  });

  test(
    'prasyarat indikasi siap membuka akses tanpa memberi bukti ke anak topik',
    () {
      final bukti = BuktiSkill(
        topikId: 'T01',
        skillId: 'T01-jangkar',
        status: StatusBukti.indikasiSiap,
        benar: 2,
        total: 2,
        bantuan: 0,
        sumberSesi: 'diagnostic-1',
        waktu: DateTime(2026, 10, 30),
        versiKebijakan: 'pilot-v1',
        versiButir: const ['kelas-1-v1'],
      );
      final akses = SkillMapService(daftarTopik).susunAkses({'T01': bukti});
      final data = DataBelajar(buktiSkill: {'T01': bukti}, aksesMateri: akses);
      expect(data.statusTopik('T01'), StatusTopik.siapLanjut);
      expect(data.statusTopik('T03'), StatusTopik.belumDiuji);
      expect(data.buktiSkill['T03'], isNull);
      expect(data.jumlahBuktiAwal, 0);
    },
  );
}
