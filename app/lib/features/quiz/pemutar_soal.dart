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

  @override
  State<PemutarSoal> createState() => _PemutarSoalState();
}

class _PemutarSoalState extends State<PemutarSoal> {
  final _jawaban = <Jawaban>[];
  int _indeks = 0;
  String? _pilihan;
  bool _sudahCek = false;
  bool _tuntas = false;

  bool get _umpanBalik =>
      widget.konteks == KonteksJawaban.lesson && widget.umpanBalik;

  Soal get _soal => widget.soal[_indeks];

  void _cek() {
    final pilihan = _pilihan;
    if (pilihan == null || _sudahCek || _tuntas) return;
    final jawaban = Jawaban(
      soalId: _soal.id,
      topikId: _soal.topikId,
      jawaban: pilihan,
      benar: _soal.periksa(pilihan),
      waktu: DateTime.now(),
      konteks: widget.konteks,
    );
    _jawaban.add(jawaban);
    widget.onJawab?.call(jawaban);
    if (_umpanBalik) {
      setState(() => _sudahCek = true);
    } else {
      _lanjut();
    }
  }

  void _lanjut() {
    if (_tuntas) return;
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
                  nilai: (nomor - 1 + (_sudahCek ? 1 : 0)) / total,
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
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
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
                terkunci: _sudahCek,
                tampilkanKunci: _umpanBalik && _sudahCek,
                onPilih: (p) => setState(() => _pilihan = p),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _sudahCek
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
                      tampilkanXp: widget.konteks != KonteksJawaban.diagnostic,
                    ),
                  ),
                )
              : _pilihan == null
              ? const SizedBox.shrink()
              : Padding(
                  key: const ValueKey('cek'),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: SafeArea(
                    top: false,
                    child: TombolNumi(
                      label: _umpanBalik ? 'Cek Jawaban' : 'Kirim',
                      lebar: double.infinity,
                      warna: NumiWarna.malam,
                      warnaTeks: Colors.white,
                      onTap: _pilihan == null ? null : _cek,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
