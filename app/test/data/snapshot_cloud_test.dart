import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/data/repositories/cloud_profil_repository.dart';

void main() {
  final data = DataBelajar(
    siswa: Siswa(
      id: 'profil-123',
      waliUid: 'wali',
      nama: 'QA',
      kelas: 1,
      dibuatPada: DateTime(2026),
    ),
  );
  Map<String, dynamic> snapshot(DataBelajar d) => {
    'data': d.toJson(),
    'versi': sidikDataBelajar(d),
    'dasar': null,
  };

  test('profil rusak diisolasi tanpa membuang profil sehat', () {
    final hasil = DaftarProfilCloud.urai('wali', {
      'profil-123': snapshot(data),
      'profil-rusak': {
        'data': {
          'sesiLesson': [
            {'id': 'tidak-lengkap'},
          ],
        },
      },
    });
    expect(hasil.profil.keys, ['profil-123']);
    expect(hasil.tidakValid, {'profil-rusak'});
  });

  test('digest salah dan UID asing tidak masuk cache', () {
    for (final isi in [
      {...snapshot(data), 'versi': '0' * 64},
      {
        ...snapshot(data),
        'data': {
          ...data.toJson(),
          'siswa': {...data.siswa!.toJson(), 'waliUid': 'asing'},
        },
      },
    ]) {
      final hasil = DaftarProfilCloud.urai('wali', {'profil-123': isi});
      expect(hasil.profil, isEmpty);
      expect(hasil.tidakValid, {'profil-123'});
    }
  });

  test('XP tanpa riwayat finalisasi tetap ditolak walau digest cocok', () {
    final hasil = DaftarProfilCloud.urai('wali', {
      'profil-123': snapshot(data.copyWith(xp: 999999999)),
    });
    expect(hasil.profil, isEmpty);
    expect(hasil.tidakValid, {'profil-123'});
  });

  test('XP dari latihan berulang dan mastery tetap dapat dipulihkan', () {
    final belajar = data.copyWith(
      xp: 240,
      progresLesson: {
        'T01-latihan': LessonProgress(
          lessonId: 'T01-latihan',
          topikId: 'T01',
          selesai: true,
          skorTerbaik: 100,
          jumlahPercobaan: 2,
          waktu: DateTime(2026),
        ),
      },
      hasilMastery: [
        MasteryResult(
          topikId: 'T01',
          skor: 100,
          lulus: true,
          waktu: DateTime(2026),
        ),
      ],
    );
    final hasil = DaftarProfilCloud.urai('wali', {
      'profil-123': snapshot(belajar),
    });
    expect(hasil.tidakValid, isEmpty);
    expect(hasil.profil['profil-123']!.xp, 240);
    expect(
      DaftarProfilCloud.urai('wali', {
        'profil-123': snapshot(belajar.copyWith(xp: 241)),
      }).tidakValid,
      {'profil-123'},
    );
  });
}
