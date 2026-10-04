import 'dart:math';

import '../../core/utils/tanggal.dart';
import '../models/soal.dart';

typedef _Templat = Soal Function(int tingkat);

/// Membangkitkan soal dari templat per topik (lihat dokumen kurikulum bagian 5).
///
/// Tingkat 1 dipakai untuk diagnostic dan lesson kenalan, tingkat 2 untuk
/// lesson latihan dan mastery test.
class GeneratorSoal {
  GeneratorSoal([Random? rng]) : _rng = rng ?? Random();

  final Random _rng;

  static const _benda = ['🍎', '⭐', '🐟', '🌸', '🎈', '🍓', '🐥', '⚽'];
  static const _nama = ['Adi', 'Sari', 'Budi', 'Ayu', 'Dimas', 'Rina', 'Tono', 'Lala'];

  List<Soal> buat(String topikId, int jumlah, {int tingkat = 1}) {
    final templat = _templatUntuk(topikId);
    final hasil = <Soal>[];
    final kunci = <String>{};
    final mulai = _rng.nextInt(templat.length);
    var coba = 0;
    // Templat dipakai bergiliran supaya bentuk soal dalam satu sesi bervariasi.
    while (hasil.length < jumlah && coba < jumlah * 30) {
      final soal = templat[(mulai + coba) % templat.length](tingkat);
      coba++;
      if (kunci.add(soal.id)) hasil.add(soal);
    }
    return hasil;
  }

  List<_Templat> _templatUntuk(String topikId) => switch (topikId) {
        'T01' => [_t01Hitung, _t01Banding, _t01Urutan, _t01Pasang, _t01Sesudah],
        'T02' => [_t02NilaiTempat, _t02Urai, _t02Banding, _t02Terbesar],
        'T03' => [_t03Hitung, _t03Kotak, _t03Pasang, _t03Pilih],
        'T04' => [_t04Hitung, _t04Kotak, _t04Pasang, _t04Banding],
        'T05' => [_t05Gambar, _t05Nama, _t05Setengah, _t05Banding],
        'T06' => [_t06Pilih, _t06Kotak, _t06Banding, _t06Cerita],
        'T07' => [_t07Pilih, _t07Kotak, _t07Cerita, _t07Berulang],
        'T08' => [_t08Pilih, _t08Kotak, _t08Cerita, _t08Kebalikan],
        'T09' => [_t09Senilai, _t09Banding, _t09Gambar],
        'T10' => [_t10Belanja, _t10Hitung, _t10Kembalian, _t10Kali],
        'T11' => [_t11Tambah, _t11Kurang, _t11Beda, _t11Cerita],
        'T12' => [_t12Kpk, _t12Fpb, _t12CeritaKpk, _t12CeritaFpb],
        _ => throw ArgumentError('Topik $topikId tidak dikenal'),
      };

  // alat bantu

  int _acak(int min, int max) => min + _rng.nextInt(max - min + 1);

  T _pilih<T>(List<T> daftar) => daftar[_rng.nextInt(daftar.length)];

  List<String> _acakUrutan(Iterable<String> isi) => isi.toList()..shuffle(_rng);

  List<String> _opsiAngka(int benar, {int sebar = 3, int min = 0, String Function(int)? tampil}) {
    final opsi = <int>{benar};
    var jarak = sebar;
    var coba = 0;
    while (opsi.length < 4) {
      final calon = benar + _rng.nextInt(jarak * 2 + 1) - jarak;
      if (calon >= min) opsi.add(calon);
      if (++coba % 10 == 0) jarak++;
    }
    return _acakUrutan(opsi.map(tampil ?? (v) => v.toString()));
  }

  /// Pengecoh yang meniru salah hitung yang umum: meleset 1, 10, atau 100.
  List<String> _opsiDekat(int benar, List<int> langkah, {int min = 0, String Function(int)? tampil}) {
    final opsi = <int>{benar};
    final calon = [for (final l in langkah) ...[benar + l, benar - l]]..shuffle(_rng);
    for (final c in calon) {
      if (opsi.length == 4) break;
      if (c >= min) opsi.add(c);
    }
    if (opsi.length < 4) {
      return _opsiAngka(benar, sebar: langkah.first + 2, min: min, tampil: tampil);
    }
    return _acakUrutan(opsi.map(tampil ?? (v) => v.toString()));
  }

  /// Menambah pengecoh angka sampai pilihannya genap empat.
  List<String> _lengkapi(Set<String> opsi, int benar, {int min = 0}) {
    var geser = 1;
    while (opsi.length < 4) {
      final calon = benar + geser;
      if (calon >= min) opsi.add('$calon');
      geser = geser > 0 ? -geser : -geser + 1;
    }
    return _acakUrutan(opsi.take(4));
  }

  List<String> _lengkapiPecahan(Set<String> opsi, int penyebut) {
    var pembilang = 1;
    while (opsi.length < 4) {
      opsi.add('$pembilang/$penyebut');
      pembilang++;
    }
    return _acakUrutan(opsi.take(4));
  }

  String _tanda(num kiri, num kanan) => kiri < kanan ? '<' : (kiri > kanan ? '>' : '=');

  String _kataBanding(String tanda) => switch (tanda) {
        '<' => 'lebih kecil dari',
        '>' => 'lebih besar dari',
        _ => 'sama dengan',
      };

  int _fpb(int a, int b) => b == 0 ? a : _fpb(b, a % b);
  int _kpk(int a, int b) => a * b ~/ _fpb(a, b);

  String _rp(int nilai) => 'Rp${formatAngka(nilai)}';

  // T01 mengenal bilangan sampai 20

  Soal _t01Hitung(int tingkat) {
    final n = _acak(2, tingkat == 1 ? 10 : 20);
    final benda = _pilih(_benda);
    return Soal(
      id: 'T01-hitung-$n-$benda',
      topikId: 'T01',
      jenis: JenisSoal.hitungBenda,
      tingkat: tingkat,
      pertanyaan: 'Ada berapa benda di bawah ini?',
      benda: benda,
      jumlahBenda: n,
      pilihan: _opsiAngka(n, sebar: 2, min: 1),
      jawabanBenar: '$n',
      penjelasan: 'Sentuh satu per satu sambil membilang. Semuanya ada $n.',
    );
  }

  Soal _t01Banding(int tingkat) {
    final a = _acak(1, 20);
    final b = _rng.nextInt(5) == 0 ? a : _acak(1, 20);
    final tanda = _tanda(a, b);
    return Soal(
      id: 'T01-banding-$a-$b',
      topikId: 'T01',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Pilih tanda yang tepat.',
      kalimat: '$a ☐ $b',
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: '$a ${_kataBanding(tanda)} $b, jadi tandanya $tanda.',
    );
  }

  Soal _t01Urutan(int tingkat) {
    final s = _acak(1, tingkat == 1 ? 7 : 16);
    return Soal(
      id: 'T01-urutan-$s',
      topikId: 'T01',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Bilangan berapa yang hilang?',
      kalimat: '$s ${s + 1} ☐ ${s + 3}',
      pilihan: _opsiAngka(s + 2, sebar: 2, min: 1),
      jawabanBenar: '${s + 2}',
      penjelasan: 'Bilangannya naik satu-satu: $s, ${s + 1}, ${s + 2}, ${s + 3}.',
    );
  }

  Soal _t01Pasang(int tingkat) {
    final angka = <int>{};
    while (angka.length < 3) {
      angka.add(_acak(1, 6));
    }
    final benda = _pilih(_benda);
    final pasangan = [for (final n in angka) PasanganSoal(benda * n, '$n')];
    return Soal(
      id: 'T01-pasang-${angka.join('.')}-$benda',
      topikId: 'T01',
      jenis: JenisSoal.pasangkan,
      tingkat: tingkat,
      pertanyaan: 'Pasangkan gambar dengan angkanya.',
      pasangan: pasangan,
      pilihan: _acakUrutan(pasangan.map((p) => p.kanan)),
      jawabanBenar: pasangan.map((p) => p.kanan).join('|'),
      penjelasan: 'Hitung benda di tiap baris, lalu cari angka yang sama.',
    );
  }

  Soal _t01Sesudah(int tingkat) {
    final n = _acak(1, 19);
    return Soal(
      id: 'T01-sesudah-$n',
      topikId: 'T01',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Bilangan sesudah $n adalah?',
      pilihan: _opsiAngka(n + 1, sebar: 2, min: 1),
      jawabanBenar: '${n + 1}',
      penjelasan: 'Sesudah $n berarti tambah satu, yaitu ${n + 1}.',
    );
  }

  // T02 bilangan sampai 100 dan nilai tempat

  int _duaAngka() {
    while (true) {
      final n = _acak(21, 98);
      if (n % 10 != 0 && n ~/ 10 != n % 10) return n;
    }
  }

  Soal _t02NilaiTempat(int tingkat) {
    final n = _duaAngka();
    final puluhan = n ~/ 10;
    return Soal(
      id: 'T02-nilai-$n',
      topikId: 'T02',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Pada bilangan $n, angka $puluhan bernilai?',
      pilihan: _acakUrutan(['${puluhan * 10}', '$puluhan', '${n % 10}', '$n']),
      jawabanBenar: '${puluhan * 10}',
      penjelasan: 'Angka $puluhan ada di tempat puluhan, jadi nilainya ${puluhan * 10}.',
    );
  }

  Soal _t02Urai(int tingkat) {
    final n = _duaAngka();
    final puluh = n ~/ 10 * 10;
    final satuan = n % 10;
    return Soal(
      id: 'T02-urai-$n',
      topikId: 'T02',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Lengkapi kalimatnya.',
      kalimat: '$n = $puluh + ☐',
      pilihan: _lengkapi({'$satuan', '${n ~/ 10}', '$puluh'}, satuan),
      jawabanBenar: '$satuan',
      penjelasan: '$n terdiri dari $puluh dan $satuan.',
    );
  }

  Soal _t02Banding(int tingkat) {
    final a = _acak(10, 99);
    final b = _rng.nextInt(6) == 0 ? a : _acak(10, 99);
    final tanda = _tanda(a, b);
    return Soal(
      id: 'T02-banding-$a-$b',
      topikId: 'T02',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Pilih tanda yang tepat.',
      kalimat: '$a ☐ $b',
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: 'Bandingkan puluhannya dulu. $a ${_kataBanding(tanda)} $b.',
    );
  }

  Soal _t02Terbesar(int tingkat) {
    final isi = <int>{};
    while (isi.length < 4) {
      isi.add(_acak(10, 99));
    }
    final terbesar = isi.reduce(max);
    return Soal(
      id: 'T02-terbesar-${isi.join('.')}',
      topikId: 'T02',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Mana bilangan yang paling besar?',
      pilihan: _acakUrutan(isi.map((e) => '$e')),
      jawabanBenar: '$terbesar',
      penjelasan: 'Lihat angka puluhannya dulu. Yang paling besar adalah $terbesar.',
    );
  }

  // T03 penjumlahan sampai 20

  (int, int) _pasanganJumlah(int tingkat) {
    final batas = tingkat == 1 ? 10 : 20;
    final a = _acak(1, batas - 1);
    final b = _acak(1, min(batas - a, 9));
    return (a, b);
  }

  Soal _t03Hitung(int tingkat) {
    final (a, b) = _pasanganJumlah(tingkat);
    final benda = _pilih(_benda);
    return Soal(
      id: 'T03-hitung-$a-$b-$benda',
      topikId: 'T03',
      jenis: JenisSoal.hitungBenda,
      tingkat: tingkat,
      pertanyaan: 'Berapa jumlah semuanya?',
      kalimat: '$a + $b = ☐',
      benda: benda,
      jumlahBenda: a,
      jumlahBenda2: b,
      pilihan: _opsiAngka(a + b, sebar: 2, min: 1),
      jawabanBenar: '${a + b}',
      penjelasan: 'Hitung $a, lalu lanjutkan $b lagi. Semuanya ${a + b}.',
    );
  }

  Soal _t03Kotak(int tingkat) {
    final (a, b) = _pasanganJumlah(tingkat);
    final cariTengah = tingkat > 1 && _rng.nextBool();
    return Soal(
      id: 'T03-kotak-$a-$b-$cariTengah',
      topikId: 'T03',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret angka yang tepat ke kotak.',
      kalimat: cariTengah ? '$a + ☐ = ${a + b}' : '$a + $b = ☐',
      pilihan: _opsiAngka(cariTengah ? b : a + b, sebar: 2, min: 0),
      jawabanBenar: cariTengah ? '$b' : '${a + b}',
      penjelasan: cariTengah
          ? 'Dari $a ke ${a + b} kurang $b, jadi kotaknya $b.'
          : '$a ditambah $b sama dengan ${a + b}.',
    );
  }

  Soal _t03Pasang(int tingkat) {
    final pasangan = <PasanganSoal>[];
    final hasil = <int>{};
    while (pasangan.length < 3) {
      final (a, b) = _pasanganJumlah(tingkat);
      if (hasil.add(a + b)) pasangan.add(PasanganSoal('$a + $b', '${a + b}'));
    }
    return Soal(
      id: 'T03-pasang-${pasangan.map((p) => p.kiri).join('.')}',
      topikId: 'T03',
      jenis: JenisSoal.pasangkan,
      tingkat: tingkat,
      pertanyaan: 'Pasangkan soal dengan hasilnya.',
      pasangan: pasangan,
      pilihan: _acakUrutan(pasangan.map((p) => p.kanan)),
      jawabanBenar: pasangan.map((p) => p.kanan).join('|'),
      penjelasan: pasangan.map((p) => '${p.kiri} = ${p.kanan}').join(', '),
    );
  }

  Soal _t03Pilih(int tingkat) {
    final (a, b) = _pasanganJumlah(tingkat);
    return Soal(
      id: 'T03-pilih-$a-$b',
      topikId: 'T03',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '$a + $b = ☐',
      pilihan: _opsiAngka(a + b, sebar: 2, min: 1),
      jawabanBenar: '${a + b}',
      penjelasan: '$a + $b = ${a + b}.',
    );
  }

  // T04 pengurangan sampai 20

  (int, int) _pasanganKurang(int tingkat) {
    final a = _acak(3, tingkat == 1 ? 10 : 20);
    final b = _acak(1, a - 1);
    return (a, b);
  }

  Soal _t04Hitung(int tingkat) {
    final (a, b) = _pasanganKurang(tingkat);
    final benda = _pilih(_benda);
    return Soal(
      id: 'T04-hitung-$a-$b-$benda',
      topikId: 'T04',
      jenis: JenisSoal.hitungBenda,
      tingkat: tingkat,
      pertanyaan: 'Ada $a, diambil $b. Sisa berapa?',
      kalimat: '$a - $b = ☐',
      benda: benda,
      jumlahBenda: a,
      jumlahDicoret: b,
      pilihan: _opsiAngka(a - b, sebar: 2, min: 0),
      jawabanBenar: '${a - b}',
      penjelasan: 'Yang dicoret ada $b. Hitung yang tidak dicoret: ${a - b}.',
    );
  }

  Soal _t04Kotak(int tingkat) {
    final (a, b) = _pasanganKurang(tingkat);
    final cariTengah = tingkat > 1 && _rng.nextBool();
    return Soal(
      id: 'T04-kotak-$a-$b-$cariTengah',
      topikId: 'T04',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret angka yang tepat ke kotak.',
      kalimat: cariTengah ? '$a - ☐ = ${a - b}' : '$a - $b = ☐',
      pilihan: _opsiAngka(cariTengah ? b : a - b, sebar: 2, min: 0),
      jawabanBenar: cariTengah ? '$b' : '${a - b}',
      penjelasan: cariTengah
          ? '$a dikurangi $b tinggal ${a - b}, jadi kotaknya $b.'
          : '$a dikurangi $b sama dengan ${a - b}.',
    );
  }

  Soal _t04Pasang(int tingkat) {
    final pasangan = <PasanganSoal>[];
    final hasil = <int>{};
    while (pasangan.length < 3) {
      final (a, b) = _pasanganKurang(tingkat);
      if (hasil.add(a - b)) pasangan.add(PasanganSoal('$a - $b', '${a - b}'));
    }
    return Soal(
      id: 'T04-pasang-${pasangan.map((p) => p.kiri).join('.')}',
      topikId: 'T04',
      jenis: JenisSoal.pasangkan,
      tingkat: tingkat,
      pertanyaan: 'Pasangkan soal dengan hasilnya.',
      pasangan: pasangan,
      pilihan: _acakUrutan(pasangan.map((p) => p.kanan)),
      jawabanBenar: pasangan.map((p) => p.kanan).join('|'),
      penjelasan: pasangan.map((p) => '${p.kiri} = ${p.kanan}').join(', '),
    );
  }

  Soal _t04Banding(int tingkat) {
    final (a, b) = _pasanganKurang(tingkat);
    final c = max(0, a - b + _acak(-2, 2));
    final tanda = _tanda(a - b, c);
    return Soal(
      id: 'T04-banding-$a-$b-$c',
      topikId: 'T04',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Hitung dulu, lalu pilih tandanya.',
      kalimat: '$a - $b ☐ $c',
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: '$a - $b = ${a - b}, dan ${a - b} ${_kataBanding(tanda)} $c.',
    );
  }

  // T05 pecahan setengah dan seperempat

  Soal _t05Gambar(int tingkat) {
    final penyebut = _pilih([2, 4]);
    return Soal(
      id: 'T05-gambar-$penyebut-${_acak(0, 999)}',
      topikId: 'T05',
      jenis: JenisSoal.pecahanGambar,
      tingkat: tingkat,
      pertanyaan: 'Bagian yang diwarnai adalah?',
      gambarPecahan: Pecahan(1, penyebut),
      pilihan: _acakUrutan(['1/2', '1/4', '1/3', '1']),
      jawabanBenar: '1/$penyebut',
      penjelasan: 'Kuenya dibagi $penyebut sama besar dan 1 bagian diwarnai, jadi 1/$penyebut.',
    );
  }

  Soal _t05Nama(int tingkat) {
    final penyebut = _pilih([2, 4]);
    final benda = _pilih(['semangka', 'roti', 'kue', 'pizza']);
    final jawaban = penyebut == 2 ? 'setengah' : 'seperempat';
    return Soal(
      id: 'T05-nama-$penyebut-$benda',
      topikId: 'T05',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Satu $benda dibagi $penyebut sama besar. Satu bagiannya disebut?',
      pilihan: _acakUrutan(['setengah', 'seperempat', 'sepertiga', 'satu']),
      jawabanBenar: jawaban,
      penjelasan: 'Dibagi $penyebut sama besar, satu bagiannya disebut $jawaban.',
    );
  }

  Soal _t05Setengah(int tingkat) {
    final seperempat = tingkat > 1 && _rng.nextBool();
    final n = seperempat ? _pilih([4, 8, 12, 16]) : _pilih([2, 4, 6, 8, 10, 12]);
    final hasil = seperempat ? n ~/ 4 : n ~/ 2;
    final kata = seperempat ? 'Seperempat' : 'Setengah';
    return Soal(
      id: 'T05-bagian-$n-$seperempat',
      topikId: 'T05',
      jenis: JenisSoal.hitungBenda,
      tingkat: tingkat,
      pertanyaan: '$kata dari benda ini ada berapa?',
      benda: _pilih(_benda),
      jumlahBenda: n,
      pilihan: _opsiAngka(hasil, sebar: 2, min: 1),
      jawabanBenar: '$hasil',
      penjelasan: 'Bagi $n benda menjadi ${seperempat ? 4 : 2} kelompok sama banyak. '
          'Tiap kelompok berisi $hasil.',
    );
  }

  Soal _t05Banding(int tingkat) {
    final setengahDulu = _rng.nextBool();
    final kalimat = setengahDulu ? '1/2 ☐ 1/4' : '1/4 ☐ 1/2';
    final tanda = setengahDulu ? '>' : '<';
    return Soal(
      id: 'T05-banding-$setengahDulu',
      topikId: 'T05',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Mana yang lebih besar? Pilih tandanya.',
      kalimat: kalimat,
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: 'Setengah kue lebih besar dari seperempat kue, karena dibagi lebih sedikit.',
    );
  }

  // T06 penjumlahan dan pengurangan sampai 1.000

  Soal _t06Pilih(int tingkat) {
    final tambah = _rng.nextBool();
    final a = tambah ? _acak(100, 600) : _acak(300, 999);
    final b = tambah ? _acak(20, 999 - a) : _acak(20, a - 50);
    final hasil = tambah ? a + b : a - b;
    final op = tambah ? '+' : '-';
    return Soal(
      id: 'T06-pilih-$a-$op-$b',
      topikId: 'T06',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '$a $op $b = ☐',
      pilihan: _opsiDekat(hasil, [10, 100, 1]),
      jawabanBenar: '$hasil',
      penjelasan: 'Kerjakan per kolom mulai dari satuan. $a $op $b = $hasil.',
    );
  }

  Soal _t06Kotak(int tingkat) {
    final a = _acak(100, 500);
    final b = _acak(50, 999 - a);
    return Soal(
      id: 'T06-kotak-$a-$b',
      topikId: 'T06',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret angka yang tepat ke kotak.',
      kalimat: '$a + ☐ = ${a + b}',
      pilihan: _opsiDekat(b, [10, 100, 1]),
      jawabanBenar: '$b',
      penjelasan: '${a + b} - $a = $b.',
    );
  }

  Soal _t06Banding(int tingkat) {
    final a = _acak(100, 500);
    final b = _acak(100, 450);
    final c = a + b + _pilih([-100, -10, 0, 10, 100]);
    final tanda = _tanda(a + b, c);
    return Soal(
      id: 'T06-banding-$a-$b-$c',
      topikId: 'T06',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Hitung dulu, lalu pilih tandanya.',
      kalimat: '$a + $b ☐ $c',
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: '$a + $b = ${a + b}, dan ${a + b} ${_kataBanding(tanda)} $c.',
    );
  }

  Soal _t06Cerita(int tingkat) {
    final a = _acak(120, 480);
    final b = _acak(100, 450);
    return Soal(
      id: 'T06-cerita-$a-$b',
      topikId: 'T06',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Di perpustakaan ada $a buku cerita dan $b buku pelajaran. '
          'Berapa banyak buku seluruhnya?',
      benda: '📚',
      pilihan: _opsiDekat(a + b, [10, 100, 1]),
      jawabanBenar: '${a + b}',
      penjelasan: 'Seluruhnya berarti dijumlahkan: $a + $b = ${a + b}.',
    );
  }

  // T07 perkalian sampai 100

  (int, int) _faktor(int tingkat) {
    final batas = tingkat == 1 ? 5 : 10;
    return (_acak(2, batas), _acak(2, 10));
  }

  Soal _t07Pilih(int tingkat) {
    final (a, b) = _faktor(tingkat);
    return Soal(
      id: 'T07-pilih-$a-$b',
      topikId: 'T07',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '$a × $b = ☐',
      pilihan: _lengkapi({'${a * b}', '${a + b}', '${a * (b + 1)}', '${(a - 1) * b}'}, a * b, min: 1),
      jawabanBenar: '${a * b}',
      penjelasan: '$a × $b artinya $a kelompok berisi $b, hasilnya ${a * b}.',
    );
  }

  Soal _t07Kotak(int tingkat) {
    final (a, b) = _faktor(tingkat);
    return Soal(
      id: 'T07-kotak-$a-$b',
      topikId: 'T07',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret angka yang tepat ke kotak.',
      kalimat: '$a × ☐ = ${a * b}',
      pilihan: _opsiAngka(b, sebar: 2, min: 1),
      jawabanBenar: '$b',
      penjelasan: '$a × $b = ${a * b}, jadi kotaknya $b.',
    );
  }

  Soal _t07Cerita(int tingkat) {
    final (a, b) = _faktor(tingkat);
    final isi = _pilih([('kotak', 'pensil', '✏️'), ('keranjang', 'jeruk', '🍊'), ('piring', 'kue', '🧁')]);
    return Soal(
      id: 'T07-cerita-$a-$b-${isi.$2}',
      topikId: 'T07',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Ada $a ${isi.$1}. Setiap ${isi.$1} berisi $b ${isi.$2}. '
          'Berapa banyak ${isi.$2} seluruhnya?',
      benda: isi.$3,
      pilihan: _opsiAngka(a * b, sebar: b, min: 1),
      jawabanBenar: '${a * b}',
      penjelasan: '$a ${isi.$1} berisi $b, jadi $a × $b = ${a * b}.',
    );
  }

  Soal _t07Berulang(int tingkat) {
    final kali = _acak(3, 5);
    final isi = _acak(2, 9);
    final jumlahan = List.filled(kali, '$isi').join(' + ');
    return Soal(
      id: 'T07-berulang-$kali-$isi',
      topikId: 'T07',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: '$jumlahan sama dengan?',
      pilihan: _acakUrutan(
          {'$kali × $isi', '$isi × $isi', '$kali + $isi', '${kali + 1} × $isi', '$kali × ${isi + 1}'}
              .take(4)),
      jawabanBenar: '$kali × $isi',
      penjelasan: 'Angka $isi dijumlahkan sebanyak $kali kali, jadi $kali × $isi.',
    );
  }

  // T08 pembagian sampai 100

  Soal _t08Pilih(int tingkat) {
    final (a, b) = _faktor(tingkat);
    final c = a * b;
    return Soal(
      id: 'T08-pilih-$c-$a',
      topikId: 'T08',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '$c : $a = ☐',
      pilihan: _opsiAngka(b, sebar: 2, min: 1),
      jawabanBenar: '$b',
      penjelasan: 'Cari angka yang jika dikali $a hasilnya $c. Jawabannya $b.',
    );
  }

  Soal _t08Kotak(int tingkat) {
    final (a, b) = _faktor(tingkat);
    final c = a * b;
    return Soal(
      id: 'T08-kotak-$c-$b',
      topikId: 'T08',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret angka yang tepat ke kotak.',
      kalimat: '$c : ☐ = $b',
      pilihan: _opsiAngka(a, sebar: 2, min: 1),
      jawabanBenar: '$a',
      penjelasan: '$c : $a = $b, karena $a × $b = $c.',
    );
  }

  Soal _t08Cerita(int tingkat) {
    final (a, b) = _faktor(tingkat);
    final c = a * b;
    final nama = _pilih(_nama);
    return Soal(
      id: 'T08-cerita-$c-$a-$nama',
      topikId: 'T08',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Bu $nama membuat $c kue. Kue dibagi rata ke $a piring. '
          'Berapa kue di setiap piring?',
      benda: '🍪',
      pilihan: _opsiAngka(b, sebar: 2, min: 1),
      jawabanBenar: '$b',
      penjelasan: 'Dibagi rata berarti $c : $a = $b.',
    );
  }

  Soal _t08Kebalikan(int tingkat) {
    final (a, b) = _faktor(tingkat);
    final c = a * b;
    return Soal(
      id: 'T08-balik-$a-$b',
      topikId: 'T08',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Jika $a × $b = $c, maka $c : $a = ?',
      pilihan: _opsiAngka(b, sebar: 3, min: 1),
      jawabanBenar: '$b',
      penjelasan: 'Pembagian adalah kebalikan perkalian, jadi $c : $a = $b.',
    );
  }

  // T09 pecahan senilai dan membandingkan pecahan

  Soal _t09Senilai(int tingkat) {
    final (p, q) = _pilih([(1, 2), (1, 3), (2, 3), (1, 4), (3, 4), (2, 5)]);
    final k = _acak(2, 4);
    final benar = '${p * k}/${q * k}';
    final opsi = {benar, '${p * k}/$q', '${p + k}/${q + k}', '$p/${q * k}'};
    return Soal(
      id: 'T09-senilai-$p-$q-$k',
      topikId: 'T09',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Pecahan yang senilai dengan $p/$q adalah?',
      pilihan: _acakUrutan(opsi),
      jawabanBenar: benar,
      penjelasan: 'Pembilang dan penyebut dikali $k: $p/$q = $benar.',
    );
  }

  Soal _t09Banding(int tingkat) {
    final b = _acak(2, 8);
    final d = _acak(2, 8);
    final a = _acak(1, b - 1);
    final c = _acak(1, d - 1);
    final tanda = _tanda(a * d, c * b);
    return Soal(
      id: 'T09-banding-$a-$b-$c-$d',
      topikId: 'T09',
      jenis: JenisSoal.bandingkan,
      tingkat: tingkat,
      pertanyaan: 'Pilih tanda yang tepat.',
      kalimat: '$a/$b ☐ $c/$d',
      pilihan: const ['<', '=', '>'],
      jawabanBenar: tanda,
      penjelasan: 'Samakan penyebutnya: ${a * d}/${b * d} dan ${c * b}/${b * d}. '
          'Jadi $a/$b ${_kataBanding(tanda)} $c/$d.',
    );
  }

  Soal _t09Gambar(int tingkat) {
    final penyebut = _acak(3, 8);
    final pembilang = _acak(1, penyebut - 1);
    final benar = '$pembilang/$penyebut';
    final opsi = <String>{benar, '${penyebut - pembilang}/$penyebut', '$pembilang/${penyebut + 1}'};
    return Soal(
      id: 'T09-gambar-$pembilang-$penyebut',
      topikId: 'T09',
      jenis: JenisSoal.pecahanGambar,
      tingkat: tingkat,
      pertanyaan: 'Bagian yang diwarnai adalah?',
      gambarPecahan: Pecahan(pembilang, penyebut),
      pilihan: _lengkapiPecahan(opsi, penyebut),
      jawabanBenar: benar,
      penjelasan: 'Ada $penyebut bagian sama besar, $pembilang diwarnai, jadi $benar.',
    );
  }

  // T10 operasi hitung sampai 100.000 dan soal cerita

  Soal _t10Belanja(int tingkat) {
    final harga = _acak(4, 30) * 500;
    final n = _acak(2, 5);
    final barang = _pilih([('buku tulis', '📓'), ('kotak susu', '🥛'), ('pensil warna', '🖍️')]);
    return Soal(
      id: 'T10-belanja-$harga-$n-${barang.$1}',
      topikId: 'T10',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Harga satu ${barang.$1} ${_rp(harga)}. Ibu membeli $n ${barang.$1}. '
          'Berapa uang yang harus dibayar?',
      benda: barang.$2,
      pilihan: _opsiDekat(harga * n, [harga, 500, 1000], min: 500, tampil: _rp),
      jawabanBenar: _rp(harga * n),
      penjelasan: '$n × ${_rp(harga)} = ${_rp(harga * n)}.',
    );
  }

  Soal _t10Hitung(int tingkat) {
    final tambah = _rng.nextBool();
    final a = _acak(10000, 60000);
    final b = tambah ? _acak(1000, 99999 - a) : _acak(1000, a - 1000);
    final hasil = tambah ? a + b : a - b;
    final op = tambah ? '+' : '-';
    return Soal(
      id: 'T10-hitung-$a-$op-$b',
      topikId: 'T10',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '${formatAngka(a)} $op ${formatAngka(b)} = ☐',
      pilihan: _opsiDekat(hasil, [1000, 100, 10000], tampil: formatAngka),
      jawabanBenar: formatAngka(hasil),
      penjelasan: 'Susun ke bawah dan kerjakan per kolom. Hasilnya ${formatAngka(hasil)}.',
    );
  }

  Soal _t10Kembalian(int tingkat) {
    final harga = _acak(3, 38) * 500;
    final bayar = harga <= 5000 ? 5000 : (harga <= 10000 ? 10000 : 20000);
    final nama = _pilih(_nama);
    return Soal(
      id: 'T10-kembali-$harga-$nama',
      topikId: 'T10',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: '$nama membeli jajanan seharga ${_rp(harga)} dan membayar dengan '
          'uang ${_rp(bayar)}. Berapa uang kembaliannya?',
      benda: '🪙',
      pilihan: _opsiDekat(bayar - harga, [500, 1000, 2000], tampil: _rp),
      jawabanBenar: _rp(bayar - harga),
      penjelasan: 'Kembalian = uang dibayar - harga = ${_rp(bayar)} - ${_rp(harga)} '
          '= ${_rp(bayar - harga)}.',
    );
  }

  Soal _t10Kali(int tingkat) {
    final a = _acak(1200, 9999);
    final b = _acak(2, min(9, 100000 ~/ a));
    return Soal(
      id: 'T10-kali-$a-$b',
      topikId: 'T10',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret hasil yang tepat ke kotak.',
      kalimat: '${formatAngka(a)} × $b = ☐',
      pilihan: _opsiDekat(a * b, [a, 10, 100], min: 1, tampil: formatAngka),
      jawabanBenar: formatAngka(a * b),
      penjelasan: '${formatAngka(a)} × $b = ${formatAngka(a * b)}.',
    );
  }

  // T11 penjumlahan dan pengurangan pecahan

  Soal _t11Tambah(int tingkat) {
    final d = _acak(3, 10);
    final a = _acak(1, d - 2);
    final b = _acak(1, d - 1 - a);
    final benar = '${a + b}/$d';
    return Soal(
      id: 'T11-tambah-$a-$b-$d',
      topikId: 'T11',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'Berapa hasilnya?',
      kalimat: '$a/$d + $b/$d = ☐',
      pilihan: _acakUrutan({benar, '${a + b}/${d * 2}', '${a + b + 1}/$d', '$a/$d'}),
      jawabanBenar: benar,
      penjelasan: 'Penyebutnya sama, jadi jumlahkan pembilangnya: $a + $b = ${a + b}. '
          'Hasilnya $benar.',
    );
  }

  Soal _t11Kurang(int tingkat) {
    final d = _acak(3, 10);
    final a = _acak(2, d - 1);
    final b = _acak(1, a - 1);
    final benar = '${a - b}/$d';
    return Soal(
      id: 'T11-kurang-$a-$b-$d',
      topikId: 'T11',
      jenis: JenisSoal.seretKeKotak,
      tingkat: tingkat,
      pertanyaan: 'Seret hasil yang tepat ke kotak.',
      kalimat: '$a/$d - $b/$d = ☐',
      pilihan: _lengkapiPecahan({benar, '${a - b}/${d * 2}', '${a + b}/$d', '$b/$d'}, d),
      jawabanBenar: benar,
      penjelasan: 'Penyebutnya sama, kurangkan pembilangnya: $a - $b = ${a - b}.',
    );
  }

  Soal _t11Beda(int tingkat) {
    while (true) {
      final d1 = _acak(2, 5);
      final k = _acak(2, 3);
      final d2 = d1 * k;
      final a = _acak(1, d1 - 1);
      final b = _acak(1, d2 - 1);
      final pembilang = a * k + b;
      if (pembilang >= d2) continue;
      final benar = '$pembilang/$d2';
      final opsi = {benar, '${a + b}/${d1 + d2}', '${a + b}/$d2', '${pembilang + 1}/$d2'};
      if (opsi.length < 4) continue;
      return Soal(
        id: 'T11-beda-$a-$d1-$b-$d2',
        topikId: 'T11',
        jenis: JenisSoal.pilihanGanda,
        tingkat: tingkat,
        pertanyaan: 'Berapa hasilnya?',
        kalimat: '$a/$d1 + $b/$d2 = ☐',
        pilihan: _acakUrutan(opsi),
        jawabanBenar: benar,
        penjelasan: 'Samakan penyebut: $a/$d1 = ${a * k}/$d2. Lalu ${a * k}/$d2 + $b/$d2 = $benar.',
      );
    }
  }

  Soal _t11Cerita(int tingkat) {
    final d = _pilih([4, 5, 8, 10]);
    final a = _acak(2, d - 1);
    final b = _acak(1, a - 1);
    final benar = '${a - b}/$d';
    return Soal(
      id: 'T11-cerita-$a-$b-$d',
      topikId: 'T11',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Ibu punya $a/$d kg gula. Sebanyak $b/$d kg dipakai untuk membuat kue. '
          'Berapa kg gula yang tersisa?',
      benda: '🧁',
      pilihan: _lengkapiPecahan({benar, '${a + b}/$d', '${a - b}/${d * 2}', '$b/$d'}, d),
      jawabanBenar: benar,
      penjelasan: 'Sisa berarti dikurangi: $a/$d - $b/$d = $benar kg.',
    );
  }

  // T12 KPK dan FPB

  (int, int) _duaBilanganBeda(int min, int maks) {
    final a = _acak(min, maks);
    var b = _acak(min, maks);
    while (b == a) {
      b = _acak(min, maks);
    }
    return (a, b);
  }

  List<String> _opsiKpkFpb(int benar, List<int> pengecoh) {
    final opsi = <int>{benar, ...pengecoh.where((p) => p > 0)};
    var tambah = 1;
    while (opsi.length < 4) {
      opsi.add(benar + tambah);
      tambah++;
    }
    return _acakUrutan(opsi.take(4).map((e) => '$e'));
  }

  Soal _t12Kpk(int tingkat) {
    final (a, b) = _duaBilanganBeda(2, 12);
    final kpk = _kpk(a, b);
    return Soal(
      id: 'T12-kpk-$a-$b',
      topikId: 'T12',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'KPK dari $a dan $b adalah?',
      pilihan: _opsiKpkFpb(kpk, [a * b, _fpb(a, b), kpk * 2]),
      jawabanBenar: '$kpk',
      penjelasan: 'Kelipatan yang sama paling kecil dari $a dan $b adalah $kpk.',
    );
  }

  Soal _t12Fpb(int tingkat) {
    final f = _acak(2, 6);
    final (x, y) = _duaBilanganBeda(1, 6);
    if (_fpb(x, y) != 1) return _t12Fpb(tingkat);
    final a = f * x;
    final b = f * y;
    return Soal(
      id: 'T12-fpb-$a-$b',
      topikId: 'T12',
      jenis: JenisSoal.pilihanGanda,
      tingkat: tingkat,
      pertanyaan: 'FPB dari $a dan $b adalah?',
      pilihan: _opsiKpkFpb(f, [_kpk(a, b), min(a, b), f * 2]),
      jawabanBenar: '$f',
      penjelasan: 'Faktor yang sama paling besar dari $a dan $b adalah $f.',
    );
  }

  Soal _t12CeritaKpk(int tingkat) {
    final (a, b) = _duaBilanganBeda(2, 8);
    final n1 = _pilih(_nama);
    var n2 = _pilih(_nama);
    while (n2 == n1) {
      n2 = _pilih(_nama);
    }
    final kpk = _kpk(a, b);
    return Soal(
      id: 'T12-ceritakpk-$a-$b-$n1',
      topikId: 'T12',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: '$n1 berenang setiap $a hari sekali, $n2 setiap $b hari sekali. '
          'Hari ini mereka berenang bersama. Setelah berapa hari mereka berenang bersama lagi?',
      benda: '🏊',
      pilihan: _opsiKpkFpb(kpk, [a * b, a + b, kpk + a]),
      jawabanBenar: '$kpk',
      penjelasan: 'Cari KPK dari $a dan $b, yaitu $kpk hari.',
    );
  }

  Soal _t12CeritaFpb(int tingkat) {
    final f = _acak(2, 8);
    final (x, y) = _duaBilanganBeda(2, 6);
    if (_fpb(x, y) != 1) return _t12CeritaFpb(tingkat);
    final apel = f * x;
    final jeruk = f * y;
    return Soal(
      id: 'T12-ceritafpb-$apel-$jeruk',
      topikId: 'T12',
      jenis: JenisSoal.soalCerita,
      tingkat: tingkat,
      pertanyaan: 'Ada $apel apel dan $jeruk jeruk. Semua buah dimasukkan ke keranjang '
          'sehingga isi setiap keranjang sama. Paling banyak berapa keranjang yang dibutuhkan?',
      benda: '🧺',
      pilihan: _opsiKpkFpb(f, [_kpk(apel, jeruk), apel + jeruk, f + 1]),
      jawabanBenar: '$f',
      penjelasan: 'Cari FPB dari $apel dan $jeruk, yaitu $f keranjang.',
    );
  }
}
