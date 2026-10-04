import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/teks_matematika.dart';
import '../../data/models/soal.dart';

/// Menampilkan satu soal sesuai jenisnya.
///
/// Widget ini hanya mengurus pilihan siswa dan melaporkannya lewat [onPilih].
/// Pemeriksaan jawaban dan umpan balik dikerjakan layar pemanggil, sehingga
/// soal yang sama bisa dipakai di diagnostic, lesson, dan mastery test.
class TampilanSoal extends StatefulWidget {
  const TampilanSoal({
    super.key,
    required this.soal,
    required this.onPilih,
    this.terkunci = false,
    this.tampilkanKunci = false,
  });

  final Soal soal;
  final ValueChanged<String?> onPilih;

  /// Setelah dicek, pilihan tidak bisa diubah lagi.
  final bool terkunci;

  /// Menandai jawaban benar dengan warna hijau. Dimatikan saat diagnostic.
  final bool tampilkanKunci;

  @override
  State<TampilanSoal> createState() => _TampilanSoalState();
}

class _TampilanSoalState extends State<TampilanSoal> {
  String? _pilihan;

  void _pilih(String? nilai) {
    if (widget.terkunci) return;
    setState(() => _pilihan = nilai);
    widget.onPilih(nilai);
  }

  @override
  Widget build(BuildContext context) {
    final soal = widget.soal;
    final tema = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (soal.jenis != JenisSoal.soalCerita) ...[
          Text(soal.pertanyaan, style: tema.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 18),
        ],
        switch (soal.jenis) {
          JenisSoal.hitungBenda => _HitungBenda(soal: soal),
          JenisSoal.pecahanGambar => Center(child: _GambarPecahan(pecahan: soal.gambarPecahan!)),
          JenisSoal.soalCerita => _KartuCerita(soal: soal),
          JenisSoal.seretKeKotak => const SizedBox.shrink(),
          JenisSoal.pasangkan => const SizedBox.shrink(),
          JenisSoal.bandingkan => const SizedBox.shrink(),
          JenisSoal.pilihanGanda => soal.kalimat == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TeksMatematika(soal.kalimat!, ukuran: 42),
                ),
        },
        const SizedBox(height: 20),
        switch (soal.jenis) {
          JenisSoal.seretKeKotak => _SeretKeKotak(
              soal: soal,
              isi: _pilihan,
              terkunci: widget.terkunci,
              onIsi: _pilih,
            ),
          JenisSoal.pasangkan => _Pasangkan(soal: soal, terkunci: widget.terkunci, onLengkap: _pilih),
          JenisSoal.bandingkan => _Bandingkan(
              soal: soal,
              pilihan: _pilihan,
              terkunci: widget.terkunci,
              tampilkanKunci: widget.tampilkanKunci,
              onPilih: _pilih,
            ),
          _ => _GridPilihan(
              pilihan: soal.pilihan,
              terpilih: _pilihan,
              kunci: widget.tampilkanKunci ? soal.jawabanBenar : null,
              terkunci: widget.terkunci,
              onPilih: _pilih,
            ),
        },
      ],
    );
  }
}

// pilihan jawaban

class _GridPilihan extends StatelessWidget {
  const _GridPilihan({
    required this.pilihan,
    required this.terpilih,
    required this.kunci,
    required this.terkunci,
    required this.onPilih,
  });

  final List<String> pilihan;
  final String? terpilih;
  final String? kunci;
  final bool terkunci;
  final ValueChanged<String> onPilih;

  @override
  Widget build(BuildContext context) {
    final panjang = pilihan.any((p) => p.length > 9);
    return GridView.count(
      crossAxisCount: panjang ? 1 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: panjang ? 5.2 : 2.1,
      children: [
        for (final (i, p) in pilihan.indexed)
          KartuPilihan(
            key: ValueKey(p),
            label: p,
            urutan: i,
            terpilih: terpilih == p,
            status: kunci == null || !terkunci
                ? StatusKartu.biasa
                : (p == kunci ? StatusKartu.benar : (terpilih == p ? StatusKartu.salah : StatusKartu.biasa)),
            onTap: terkunci ? null : () => onPilih(p),
          ),
      ],
    );
  }
}

enum StatusKartu { biasa, benar, salah }

/// Kartu jawaban yang muncul bergantian, terangkat saat dipilih, dan bergetar
/// kalau ternyata salah.
class KartuPilihan extends StatefulWidget {
  const KartuPilihan({
    super.key,
    required this.label,
    required this.terpilih,
    required this.status,
    required this.onTap,
    this.urutan = 0,
    this.keterangan,
  });

  final String label;
  final bool terpilih;
  final StatusKartu status;
  final VoidCallback? onTap;
  final int urutan;
  final String? keterangan;

  @override
  State<KartuPilihan> createState() => _KartuPilihanState();
}

class _KartuPilihanState extends State<KartuPilihan> with TickerProviderStateMixin {
  late final AnimationController _muncul =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final AnimationController _getar =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  Timer? _tunda;

  @override
  void initState() {
    super.initState();
    _tunda = Timer(Duration(milliseconds: 70 * widget.urutan), () {
      if (mounted) _muncul.forward();
    });
  }

  @override
  void didUpdateWidget(covariant KartuPilihan lama) {
    super.didUpdateWidget(lama);
    if (widget.status == StatusKartu.salah && lama.status != StatusKartu.salah) _getar.forward(from: 0);
  }

  @override
  void dispose() {
    _tunda?.cancel();
    _muncul.dispose();
    _getar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (latar, garis) = switch (widget.status) {
      StatusKartu.benar => (NumiWarna.benarMuda, NumiWarna.benar),
      StatusKartu.salah => (NumiWarna.salahMuda, NumiWarna.salah),
      StatusKartu.biasa => widget.terpilih
          ? (const Color(0xFFFFF0CF), NumiWarna.cahaya)
          : (Colors.white, const Color(0xFFE6E0D2)),
    };
    final angkat = widget.terpilih && widget.status == StatusKartu.biasa ? -4.0 : 0.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_muncul, _getar]),
      builder: (context, child) {
        final skala = Curves.easeOutBack.transform(_muncul.value);
        final geser = sin(_getar.value * pi * 6) * 10 * (1 - _getar.value);
        return Transform.translate(
          offset: Offset(geser, angkat),
          child: Transform.scale(scale: skala, child: child),
        );
      },
      child: Semantics(
        button: true,
        selected: widget.terpilih,
        label: widget.label,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: latar,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: garis, width: 3),
              boxShadow: [
                BoxShadow(color: garis.withValues(alpha: 0.9), offset: Offset(0, widget.terpilih ? 2 : 5)),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(child: TeksPecahanAtauAngka(widget.label, ukuran: 30)),
                  if (widget.keterangan != null)
                    Text(widget.keterangan!, style: const TextStyle(fontSize: 12, color: NumiWarna.tintaPudar)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// hitung benda

class _HitungBenda extends StatelessWidget {
  const _HitungBenda({required this.soal});

  final Soal soal;

  @override
  Widget build(BuildContext context) {
    final kelompok2 = soal.jumlahBenda2 > 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEDE7DA), width: 2),
      ),
      child: Column(
        children: [
          if (kelompok2)
            Row(
              children: [
                Expanded(child: _KumpulanBenda(benda: soal.benda!, jumlah: soal.jumlahBenda)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('+', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: NumiWarna.cahaya)),
                ),
                Expanded(
                  child: _KumpulanBenda(benda: soal.benda!, jumlah: soal.jumlahBenda2, jedaAwal: soal.jumlahBenda),
                ),
              ],
            )
          else
            _KumpulanBenda(benda: soal.benda!, jumlah: soal.jumlahBenda, dicoret: soal.jumlahDicoret),
          if (soal.kalimat != null) ...[
            const SizedBox(height: 12),
            TeksMatematika(soal.kalimat!, ukuran: 30),
          ],
          const SizedBox(height: 6),
          const Text('Ketuk benda untuk menandai yang sudah dihitung',
              style: TextStyle(fontSize: 12, color: NumiWarna.tintaPudar)),
        ],
      ),
    );
  }
}

class _KumpulanBenda extends StatefulWidget {
  const _KumpulanBenda({required this.benda, required this.jumlah, this.dicoret = 0, this.jedaAwal = 0});

  final String benda;
  final int jumlah;
  final int dicoret;
  final int jedaAwal;

  @override
  State<_KumpulanBenda> createState() => _KumpulanBendaState();
}

class _KumpulanBendaState extends State<_KumpulanBenda> {
  final _dihitung = <int>{};

  @override
  Widget build(BuildContext context) {
    final ukuran = widget.jumlah > 12 ? 30.0 : 38.0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < widget.jumlah; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 350 + (i + widget.jedaAwal) * 45),
            curve: Curves.easeOutBack,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            child: GestureDetector(
              onTap: () => setState(() => _dihitung.contains(i) ? _dihitung.remove(i) : _dihitung.add(i)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: i >= widget.jumlah - widget.dicoret ? 0.35 : 1,
                    child: Text(widget.benda, style: TextStyle(fontSize: ukuran)),
                  ),
                  if (i >= widget.jumlah - widget.dicoret)
                    Icon(Icons.close_rounded, color: NumiWarna.salah, size: ukuran * 1.1),
                  if (_dihitung.contains(i))
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: NumiWarna.benar, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// pecahan bergambar

class _GambarPecahan extends StatelessWidget {
  const _GambarPecahan({required this.pecahan});

  final Pecahan pecahan;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Transform.rotate(
        angle: (1 - v) * -pi / 2,
        child: SizedBox.square(
          dimension: 190,
          child: CustomPaint(painter: _PelukisPecahan(pecahan, v)),
        ),
      ),
    );
  }
}

class _PelukisPecahan extends CustomPainter {
  _PelukisPecahan(this.pecahan, this.t);

  final Pecahan pecahan;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = size.center(Offset.zero);
    final r = size.width / 2 - 6;
    final kotak = Rect.fromCircle(center: pusat, radius: r);
    final sudut = 2 * pi / pecahan.penyebut;

    canvas.drawCircle(pusat.translate(0, 6), r, Paint()..color = const Color(0xFFE7C9A0));
    canvas.drawCircle(pusat, r, Paint()..color = const Color(0xFFFFF3DE));
    for (var i = 0; i < pecahan.pembilang; i++) {
      canvas.drawArc(kotak, -pi / 2 + i * sudut, sudut * t, true, Paint()..color = const Color(0xFFFF8FA3));
    }
    final garis = Paint()
      ..color = const Color(0xFF8A5A3C)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < pecahan.penyebut; i++) {
      final a = -pi / 2 + i * sudut;
      canvas.drawLine(pusat, pusat + Offset(cos(a), sin(a)) * r, garis);
    }
    canvas.drawCircle(pusat, r, garis);
  }

  @override
  bool shouldRepaint(covariant _PelukisPecahan lama) => lama.t != t || lama.pecahan != pecahan;
}

// soal cerita

class _KartuCerita extends StatelessWidget {
  const _KartuCerita({required this.soal});

  final Soal soal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEDE7DA), width: 2),
      ),
      child: Column(
        children: [
          if (soal.benda != null)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, v, child) => Transform.scale(scale: v, child: child),
              child: Text(soal.benda!, style: const TextStyle(fontSize: 56)),
            ),
          const SizedBox(height: 8),
          Text(
            soal.pertanyaan,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.45, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// seret ke kotak

class _SeretKeKotak extends StatelessWidget {
  const _SeretKeKotak({required this.soal, required this.isi, required this.terkunci, required this.onIsi});

  final Soal soal;
  final String? isi;
  final bool terkunci;
  final ValueChanged<String?> onIsi;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFEDE7DA), width: 2),
          ),
          child: TeksMatematika(
            soal.kalimat!,
            ukuran: 38,
            kotak: DragTarget<String>(
              onWillAcceptWithDetails: (_) => !terkunci,
              onAcceptWithDetails: (d) => onIsi(d.data),
              builder: (context, calon, _) => GestureDetector(
                onTap: terkunci ? null : () => onIsi(null),
                child: KotakKosong(ukuran: 38, isi: isi, sorot: calon.isNotEmpty),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          terkunci ? '' : 'Seret atau ketuk kartu angka',
          style: const TextStyle(color: NumiWarna.tintaPudar, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (i, p) in soal.pilihan.indexed)
              _KartuSeret(nilai: p, urutan: i, dipakai: isi == p, terkunci: terkunci, onTap: () => onIsi(p)),
          ],
        ),
      ],
    );
  }
}

class _KartuSeret extends StatelessWidget {
  const _KartuSeret({
    required this.nilai,
    required this.urutan,
    required this.dipakai,
    required this.terkunci,
    required this.onTap,
  });

  final String nilai;
  final int urutan;
  final bool dipakai;
  final bool terkunci;
  final VoidCallback onTap;

  Widget _kartu({bool melayang = false}) => Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minWidth: 72),
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NumiWarna.cahaya, width: 3),
            boxShadow: [
              BoxShadow(
                color: melayang ? Colors.black26 : NumiWarna.cahaya,
                blurRadius: melayang ? 18 : 0,
                offset: Offset(0, melayang ? 10 : 5),
              ),
            ],
          ),
          child: Center(child: TeksPecahanAtauAngka(nilai, ukuran: 28)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final kartu = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: dipakai ? 0.3 : 1,
      child: _kartu(),
    );
    if (terkunci) return kartu;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + urutan * 80),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Transform.translate(offset: Offset(0, (1 - v) * 40), child: child),
      child: Draggable<String>(
        data: nilai,
        feedback: Transform.rotate(angle: -0.06, child: _kartu(melayang: true)),
        childWhenDragging: Opacity(opacity: 0.25, child: _kartu()),
        child: GestureDetector(onTap: onTap, child: kartu),
      ),
    );
  }
}

// pasangkan

class _Pasangkan extends StatefulWidget {
  const _Pasangkan({required this.soal, required this.terkunci, required this.onLengkap});

  final Soal soal;
  final bool terkunci;
  final ValueChanged<String?> onLengkap;

  @override
  State<_Pasangkan> createState() => _PasangkanState();
}

class _PasangkanState extends State<_Pasangkan> {
  static const _warna = [NumiWarna.ungu, NumiWarna.langit, Color(0xFFFF8A3D), NumiWarna.benar];

  /// indeks kiri -> nilai kanan
  final _pasangan = <int, String>{};
  int? _kiriAktif;

  void _ketukKiri(int i) {
    if (widget.terkunci) return;
    setState(() {
      _pasangan.remove(i);
      _kiriAktif = i;
    });
    widget.onLengkap(null);
  }

  void _ketukKanan(String nilai) {
    if (widget.terkunci || _kiriAktif == null) return;
    setState(() {
      _pasangan.removeWhere((_, v) => v == nilai);
      _pasangan[_kiriAktif!] = nilai;
      _kiriAktif = null;
    });
    final kiri = widget.soal.pasangan;
    if (_pasangan.length == kiri.length) {
      widget.onLengkap([for (var i = 0; i < kiri.length; i++) _pasangan[i]].join('|'));
    }
  }

  Color? _warnaKanan(String nilai) {
    for (final e in _pasangan.entries) {
      if (e.value == nilai) return _warna[e.key % _warna.length];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final kiri = widget.soal.pasangan;
    return Column(
      children: [
        Text(
          _kiriAktif == null ? 'Ketuk kartu kiri, lalu pasangannya di kanan' : 'Sekarang ketuk pasangannya',
          style: const TextStyle(color: NumiWarna.tintaPudar, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < kiri.length; i++)
                    _KartuPasang(
                      teks: kiri[i].kiri,
                      warna: _pasangan.containsKey(i) ? _warna[i % _warna.length] : null,
                      aktif: _kiriAktif == i,
                      onTap: () => _ketukKiri(i),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  for (final nilai in widget.soal.pilihan)
                    _KartuPasang(teks: nilai, warna: _warnaKanan(nilai), aktif: false, onTap: () => _ketukKanan(nilai)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KartuPasang extends StatelessWidget {
  const _KartuPasang({required this.teks, required this.warna, required this.aktif, required this.onTap});

  final String teks;
  final Color? warna;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final garis = warna ?? (aktif ? NumiWarna.cahaya : const Color(0xFFE6E0D2));
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        height: 72,
        transform: Matrix4.translationValues(aktif ? 6 : 0, 0, 0),
        decoration: BoxDecoration(
          color: warna?.withValues(alpha: 0.15) ?? Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: garis, width: 3),
          boxShadow: [BoxShadow(color: garis, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(teks, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            ),
          ),
        ),
      ),
    );
  }
}

// bandingkan

class _Bandingkan extends StatelessWidget {
  const _Bandingkan({
    required this.soal,
    required this.pilihan,
    required this.terkunci,
    required this.tampilkanKunci,
    required this.onPilih,
  });

  final Soal soal;
  final String? pilihan;
  final bool terkunci;
  final bool tampilkanKunci;
  final ValueChanged<String> onPilih;

  static const _arti = {'<': 'lebih kecil', '=': 'sama dengan', '>': 'lebih besar'};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFEDE7DA), width: 2),
          ),
          child: TeksMatematika(
            soal.kalimat!,
            ukuran: 40,
            kotak: KotakKosong(ukuran: 40, isi: pilihan),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            for (final (i, tanda) in soal.pilihan.indexed) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 96,
                  child: KartuPilihan(
                    label: tanda,
                    urutan: i,
                    keterangan: _arti[tanda],
                    terpilih: pilihan == tanda,
                    status: !terkunci || !tampilkanKunci
                        ? StatusKartu.biasa
                        : (tanda == soal.jawabanBenar
                            ? StatusKartu.benar
                            : (pilihan == tanda ? StatusKartu.salah : StatusKartu.biasa)),
                    onTap: terkunci ? null : () => onPilih(tanda),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
