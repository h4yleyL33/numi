import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../diagnostic/diagnostic_intro_screen.dart';
import '../mascot/numi_mascot.dart';
import '../home/home_shell.dart';
import '../../core/widgets/pulau_hias.dart';
import '../../core/widgets/transisi.dart';

/// Cerita pembuka lalu pengisian profil (UC-008). Isi cerita mengikuti
/// design/cerita/README.md.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.tampilkanCerita = false});
  final bool tampilkanCerita;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _AdeganCerita {
  const _AdeganCerita(this.teks, this.ekspresi, this.pulauMenyala);
  final String teks;
  final EkspresiMaskot ekspresi;
  final bool pulauMenyala;
}

const _cerita = [
  _AdeganCerita(
    'Di tengah Samudra Angka ada dua belas pulau. Dulu setiap pulau punya mercusuar yang menyala terang.',
    EkspresiMaskot.senang,
    true,
  ),
  _AdeganCerita(
    'Suatu malam Kabut Lupa datang dan memadamkan semua mercusuar. Pulau-pulau jadi gelap.',
    EkspresiMaskot.sedih,
    false,
  ),
  _AdeganCerita(
    'Aku Numi, kunang-kunang penjaga cahaya. Aku bisa menyalakan mercusuar lagi, tapi aku butuh teman yang pandai berhitung. Maukah kamu membantuku?',
    EkspresiMaskot.semangat,
    false,
  ),
];

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _halaman;
  late final TextEditingController _nama;
  int _posisi = 0;
  int? _kelas;
  bool _menyimpan = false;
  String? _galat;

  @override
  void initState() {
    super.initState();
    final siswa = ref.read(numiControllerProvider).siswa;
    if (siswa != null && !widget.tampilkanCerita) _posisi = _cerita.length;
    _halaman = PageController(initialPage: _posisi);
    _nama = TextEditingController(text: siswa?.nama ?? '');
    _kelas = siswa?.perluKonfirmasiKelas == false ? siswa?.kelas : null;
  }

  @override
  void dispose() {
    _halaman.dispose();
    _nama.dispose();
    super.dispose();
  }

  void _berikut() {
    _halaman.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _mulai() async {
    if (_menyimpan || _kelas == null) return;
    setState(() {
      _menyimpan = true;
      _galat = null;
    });
    try {
      final controller = ref.read(numiControllerProvider.notifier);
      if (ref.read(numiControllerProvider).sudahDaftar) {
        await controller.ubahProfil(nama: _nama.text, kelas: _kelas!);
      } else {
        await controller.daftar(nama: _nama.text, kelas: _kelas!);
      }
      if (!mounted) return;
      final tujuan = ref.read(numiControllerProvider).diagnosticSelesai
          ? const HomeShell()
          : const DiagnosticIntroScreen();
      Navigator.of(context).pushReplacement(transisiPudar(tujuan));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _menyimpan = false;
        _galat = 'Profil belum tersimpan. Coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LatarMalam(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i <= _cerita.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _posisi ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: i == _posisi
                              ? NumiWarna.cahaya
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _halaman,
                  onPageChanged: (i) => setState(() => _posisi = i),
                  children: [
                    for (final adegan in _cerita)
                      _HalamanCerita(adegan: adegan),
                    _FormProfil(
                      nama: _nama,
                      kelas: _kelas,
                      onKelas: (k) => setState(() => _kelas = k),
                      onUbah: () => setState(() {}),
                    ),
                  ],
                ),
              ),
              if (_galat != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _galat!,
                    semanticsLabel: _galat,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: _posisi < _cerita.length
                    ? TombolNumi(
                        label: _posisi == _cerita.length - 1
                            ? 'Aku mau membantu!'
                            : 'Lanjut',
                        lebar: double.infinity,
                        onTap: _berikut,
                      )
                    : TombolNumi(
                        label: _menyimpan
                            ? 'Menyimpan...'
                            : 'Mulai Petualangan',
                        lebar: double.infinity,
                        onTap:
                            _menyimpan ||
                                _nama.text.trim().isEmpty ||
                                _kelas == null
                            ? null
                            : _mulai,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HalamanCerita extends StatelessWidget {
  const _HalamanCerita({required this.adegan});

  final _AdeganCerita adegan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, batas) {
        final mendatar = batas.maxWidth >= 700;
        final gambar = SizedBox(
          width: mendatar ? 240 : batas.maxWidth - 48,
          height: mendatar ? 160 : 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                bottom: 20,
                child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 90),
              ),
              Positioned(
                right: 0,
                bottom: 40,
                child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 70),
              ),
              Positioned(
                top: 0,
                child: NumiMascot(
                  ukuran: mendatar ? 120 : 150,
                  ekspresi: adegan.ekspresi,
                ),
              ),
            ],
          ),
        );
        final teks = Text(
          adegan.teks,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        );
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: mendatar
                ? Row(
                    children: [
                      gambar,
                      const SizedBox(width: 32),
                      Expanded(child: teks),
                    ],
                  )
                : Column(children: [gambar, const SizedBox(height: 28), teks]),
          ),
        );
      },
    );
  }
}

class _FormProfil extends StatelessWidget {
  const _FormProfil({
    required this.nama,
    required this.kelas,
    required this.onKelas,
    required this.onUbah,
  });

  final TextEditingController nama;
  final int? kelas;
  final ValueChanged<int> onKelas;
  final VoidCallback onUbah;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: NumiMascot(ukuran: 120, ekspresi: EkspresiMaskot.senang),
          ),
          const Text(
            'Halo, Teman!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Isi bersama ayah, ibu, atau wali ya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            'Siapa namamu?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nama,
            textCapitalization: TextCapitalization.words,
            maxLength: 30,
            onChanged: (_) => onUbah(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              hintText: 'Contoh: Adi',
              counterText: '',
              prefixIcon: Icon(Icons.person_rounded),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sekarang kelas berapa?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var k = 1; k <= 6; k++)
                Semantics(
                  selected: kelas == k,
                  child: SizedBox(
                    width: 100,
                    height: 64,
                    child: OutlinedButton(
                      onPressed: () => onKelas(k),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: kelas == k
                            ? NumiWarna.cahaya
                            : Colors.white.withValues(alpha: 0.12),
                        foregroundColor: kelas == k
                            ? NumiWarna.tinta
                            : Colors.white,
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: kelas == k ? Colors.white : Colors.white24,
                        ),
                      ),
                      child: Text(
                        'Kelas $k',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 16, color: Colors.white54),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Data tersimpan aman di perangkat ini',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
