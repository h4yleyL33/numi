import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numi/data/content/daftar_lesson.dart';
import 'package:numi/data/models/catatan_belajar.dart';
import 'package:numi/data/models/companion_message.dart';
import 'package:numi/data/models/data_belajar.dart';
import 'package:numi/data/models/siswa.dart';
import 'package:numi/data/repositories/numi_repository.dart';
import 'package:numi/domain/diagnostic_engine.dart';
import 'package:numi/state/numi_controller.dart';

class RepositoryMemori implements NumiRepository {
  DataBelajar? tersimpan;
  int jumlahSimpan = 0;

  @override
  Future<DataBelajar> muat() async => tersimpan ?? const DataBelajar();

  @override
  Future<void> simpan(DataBelajar data) async {
    tersimpan = data;
    jumlahSimpan++;
  }

  @override
  Future<void> hapus() async => tersimpan = null;
}

void main() {
  late RepositoryMemori repo;
  late ProviderContainer container;
  var sekarang = DateTime(2026, 9, 26, 9);

  List<Jawaban> jawaban(String topikId, int benar, int total, KonteksJawaban konteks) => [
        for (var i = 0; i < total; i++)
          Jawaban(
            soalId: '$topikId-$i',
            topikId: topikId,
            jawaban: 'x',
            benar: i < benar,
            waktu: sekarang,
            konteks: konteks,
          ),
      ];

  setUp(() {
    repo = RepositoryMemori();
    sekarang = DateTime(2026, 9, 26, 9);
    container = ProviderContainer(overrides: [
      repositoryProvider.overrideWithValue(repo),
      jamProvider.overrideWithValue(() => sekarang),
    ]);
  });

  tearDown(() => container.dispose());

  NumiController controller() => container.read(numiControllerProvider.notifier);
  DataBelajar data() => container.read(numiControllerProvider);

  Future<void> daftarDanDiagnostic() async {
    await controller().daftar(nama: 'Adi Pratama', usia: 7);
    await controller().simpanDiagnostic(
      const HasilAkhirDiagnostic(
        hasilPerTopik: [
          DiagnosticResult(topikId: 'T01', benar: 2, total: 2, statusPenguasaan: StatusTopik.mastered),
          DiagnosticResult(topikId: 'T02', benar: 0, total: 2, statusPenguasaan: StatusTopik.belumDikuasai),
        ],
        statusAwal: {
          'T01': StatusTopik.mastered,
          'T02': StatusTopik.belumDikuasai,
          'T03': StatusTopik.terkunci,
          'T04': StatusTopik.terkunci,
          'T05': StatusTopik.terkunci,
          'T06': StatusTopik.terkunci,
          'T07': StatusTopik.terkunci,
          'T08': StatusTopik.terkunci,
          'T09': StatusTopik.terkunci,
          'T10': StatusTopik.terkunci,
          'T11': StatusTopik.terkunci,
          'T12': StatusTopik.terkunci,
        },
        kelompok: KelompokBelajar.kecil,
      ),
      jawaban('T01', 2, 2, KonteksJawaban.diagnostic),
    );
  }

  test('pendaftaran dan diagnostic tersimpan, dan topik berprasyarat T01 terbuka', () async {
    await daftarDanDiagnostic();
    expect(data().siswa!.namaPanggilan, 'Adi');
    expect(data().siswa!.kelompokBelajar, KelompokBelajar.kecil);
    expect(data().statusTopik('T03'), StatusTopik.belumDikuasai, reason: 'prasyarat T03 hanya T01');
    expect(data().statusTopik('T04'), StatusTopik.terkunci);
    expect(repo.tersimpan!.diagnosticSelesai, isTrue);
  });

  test('lesson lulus memberi XP, menandai selesai, dan membuka lencana', () async {
    await daftarDanDiagnostic();
    final lesson = lessonUntuk('T02').first;
    await controller().mulaiLesson('T02');
    expect(data().statusTopik('T02'), StatusTopik.perluLatihan);

    final r = await controller().selesaiLesson(
      lesson,
      jawaban('T02', 5, 5, KonteksJawaban.lesson),
      const Duration(seconds: 90),
    );
    expect(r.lulus, isTrue);
    expect(r.xpDidapat, 70);
    expect(data().xp, 70);
    expect(data().lessonSelesai(lesson.id), isTrue);
    expect(r.lencanaBaru.map((l) => l.id), containsAll(['pemula', 'teliti', 'cepat']));
    expect(r.pesan.trigger, JenisTrigger.badgeBaru);
  });

  test('lesson dengan benar kurang dari minimum tidak dianggap selesai', () async {
    await daftarDanDiagnostic();
    final lesson = lessonUntuk('T02').first;
    final r = await controller().selesaiLesson(
      lesson,
      jawaban('T02', 2, 5, KonteksJawaban.lesson),
      const Duration(minutes: 3),
    );
    expect(r.lulus, isFalse);
    expect(data().lessonSelesai(lesson.id), isFalse);
    expect(r.pesan.trigger, JenisTrigger.lessonGagal);
  });

  test('mastery test lulus menguasai topik dan membuka topik berikutnya', () async {
    await daftarDanDiagnostic();
    final r = await controller().selesaiMastery('T02', jawaban('T02', 5, 5, KonteksJawaban.mastery));
    expect(r.lulus, isTrue);
    expect(data().statusTopik('T02'), StatusTopik.mastered);
    expect(data().statusTopik('T05'), StatusTopik.belumDikuasai, reason: 'prasyarat T05 adalah T02');
    expect(data().hasilMastery.single.skor, 100);
  });

  test('mastery test di bawah ambang tetap perlu latihan', () async {
    await daftarDanDiagnostic();
    await controller().mulaiLesson('T02');
    final r = await controller().selesaiMastery('T02', jawaban('T02', 4, 5, KonteksJawaban.mastery));
    expect(r.lulus, isFalse);
    expect(data().statusTopik('T02'), StatusTopik.perluLatihan);
  });

  test('maskot menyapa sekali sehari dan mengingatkan saat streak terancam', () async {
    await daftarDanDiagnostic();
    expect((await controller().periksaPesanMaskot())!.trigger, JenisTrigger.sambutan);
    expect(await controller().periksaPesanMaskot(), isNull, reason: 'tidak muncul dua kali sehari');

    sekarang = DateTime(2026, 9, 27, 18);
    expect((await controller().periksaPesanMaskot())!.trigger, JenisTrigger.streakTerancam);

    sekarang = DateTime(2026, 10, 2, 18);
    expect((await controller().periksaPesanMaskot())!.trigger, JenisTrigger.lamaTidakAktif);
  });

  test('data disimpan setiap aktivitas selesai', () async {
    await daftarDanDiagnostic();
    expect(repo.jumlahSimpan, 2);
    await controller().mulaiUlang();
    expect(data().sudahDaftar, isFalse);
    expect(repo.tersimpan, isNull);
  });
}
