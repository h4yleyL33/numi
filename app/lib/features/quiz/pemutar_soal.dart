import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/bilah_progres.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/models/catatan_belajar.dart';
import '../../data/models/soal.dart';
import '../feedback/banner_umpan_balik.dart';
import 'tampilan_soal.dart';

/// Menjalankan serangkaian soal: tampilkan, cek, beri umpan balik, lanjut.
class PemutarSoal extends StatefulWidget {
  const PemutarSoal({
    super.key,
    required this.soal,
    required this.konteks,
    required this.onSelesai,
    this.umpanBalik = true,
    this.judul,
    this.nomorAwal = 0,
    this.perkiraanTotal,
    this.onJawab,
    this.simpanJawaban,
    this.jawabanAwal = const [],
    this.menungguLanjut = false,
    this.simpanLanjut,
  });

  final List<Soal> soal;
  final KonteksJawaban konteks;
  final ValueChanged<List<Jawaban>> onSelesai;

  /// Hanya berlaku pada lesson. Tes selalu menunda pembahasan sampai blok selesai.
  final bool umpanBalik;
  final String? judul;
  final int nomorAwal;
  final int? perkiraanTotal;
  final ValueChanged<Jawaban>? onJawab;
  final Future<void> Function(Jawaban)? simpanJawaban;
  final List<Jawaban> jawabanAwal;
  final bool menungguLanjut;
  final Future<void> Function(int indeks)? simpanLanjut;

  @override
  State<PemutarSoal> createState() => _PemutarSoalState();
}

class _PemutarSoalState extends State<PemutarSoal> {
  late final _jawaban = [...widget.jawabanAwal];
  late int _indeks = _jawaban.length - (widget.menungguLanjut ? 1 : 0);
  String? _pilihan;
  late bool _sudahCek = widget.menungguLanjut;
  bool _tuntas = false;
  bool _menyimpan = false;
  bool _gagalSimpan = false;
  bool _gagalLanjut = false;
  Jawaban? _tertunda;

  bool get _umpanBalik =>
      widget.konteks == KonteksJawaban.lesson && widget.umpanBalik;

  Soal get _soal => widget.soal[_indeks];

  Future<void> _cek() async {
    final pilihan = _pilihan;
    if (pilihan == null || _sudahCek || _tuntas || _menyimpan) return;
    final jawaban =
        _tertunda ??
        Jawaban(
          soalId: _soal.id,
          skillId: _soal.skillId,
          versiButir: _soal.versi,
          topikId: _soal.topikId,
          jawaban: pilihan,
          benar: _soal.periksa(pilihan),
          waktu: DateTime.now(),
          konteks: widget.konteks,
        );
    final simpan = widget.simpanJawaban;
    if (simpan != null) {
      setState(() {
        _tertunda = jawaban;
        _menyimpan = true;
        _gagalSimpan = false;
      });
      try {
        await simpan(jawaban);
      } catch (_) {
        if (mounted) {
          setState(() {
            _menyimpan = false;
            _gagalSimpan = true;
          });
        }
        return;
      }
      if (!mounted) return;
      _menyimpan = false;
      _tertunda = null;
    }
    _jawaban.add(jawaban);
    widget.onJawab?.call(jawaban);
    if (_umpanBalik) {
      setState(() => _sudahCek = true);
    } else {
      _lanjut();
    }
  }

  Future<void> _lanjut() async {
    if (_tuntas || _menyimpan) return;
    final simpan = widget.simpanLanjut;
    if (simpan != null) {
      setState(() {
        _menyimpan = true;
        _gagalLanjut = false;
      });
      try {
        await simpan(_indeks);
      } catch (_) {
        if (mounted) {
          setState(() {
            _menyimpan = false;
            _gagalLanjut = true;
          });
        }
        return;
      }
      if (!mounted) return;
      _menyimpan = false;
    }
    if (_indeks == widget.soal.length - 1) {
      _tuntas = true;
      widget.onSelesai(List.unmodifiable(_jawaban));
      return;
    }
    setState(() {
      _indeks++;
      _pilihan = null;
      _sudahCek = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.perkiraanTotal ?? widget.soal.length;
    final nomor = widget.nomorAwal + _indeks + 1;
    final benarTerakhir =
        _sudahCek && _jawaban.isNotEmpty && _jawaban.last.benar;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 20, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Keluar',
                icon: const Icon(Icons.close_rounded, size: 30),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: BilahProgres(
                  nilai: nomor / total,
                  tinggi: 12,
                  latar: NumiWarna.kartu,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$nomor/$total',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: NumiWarna.tintaPudar,
                ),
              ),
            ],
          ),
        ),
        if (widget.judul != null)
          Text(
            widget.judul!,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: NumiWarna.tintaPudar,
            ),
          ),
        if (_gagalLanjut)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Posisi belum berhasil disimpan. Coba lagi. '
              'Jika tetap gagal, buka ulang profil.',
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            layoutBuilder: (aktif, sebelumnya) => Stack(
              alignment: Alignment.topCenter,
              children: [...sebelumnya, ?aktif],
            ),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: SingleChildScrollView(
              key: ValueKey('${_soal.id}-$_indeks'),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: TampilanSoal(
                soal: _soal,
                pilihanAwal: _sudahCek ? _jawaban[_indeks].jawaban : null,
                terkunci: _sudahCek || _tertunda != null || _menyimpan,
                tampilkanKunci: _umpanBalik && _sudahCek,
                onPilih: (p) => setState(() => _pilihan = p),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _menyimpan
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Semantics(
                    label: 'Menyimpan jawaban',
                    child: const CircularProgressIndicator(),
                  ),
                )
              : _sudahCek
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.52,
                  ),
                  child: SingleChildScrollView(
                    child: BannerUmpanBalik(
                      key: ValueKey('umpan-$_indeks'),
                      benar: benarTerakhir,
                      soal: _soal,
                      onLanjut: _lanjut,
                      labelLanjut: _gagalLanjut ? 'Coba simpan lagi' : 'Lanjut',
                      tampilkanXp: widget.konteks != KonteksJawaban.diagnostic,
                    ),
                  ),
                )
              : _pilihan == null
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: TombolNumi(
                    label: 'Pilih jawaban dulu',
                    lebar: double.infinity,
                    onTap: null,
                  ),
                )
              : Padding(
                  key: const ValueKey('cek'),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_gagalSimpan)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Jawaban belum berhasil disimpan. '
                              'Coba simpan lagi. Jika tetap gagal, buka ulang profil.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        TombolNumi(
                          label: _gagalSimpan
                              ? 'Coba simpan lagi'
                              : (_umpanBalik ? 'Cek Jawaban' : 'Kirim'),
                          lebar: double.infinity,
                          onTap: _cek,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
