import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../diagnostic/diagnostic_intro_screen.dart';
import '../mascot/numi_mascot.dart';
import '../../core/widgets/pulau_hias.dart';
import '../../core/widgets/transisi.dart';

/// Cerita pembuka lalu pengisian profil (UC-008). Isi cerita mengikuti
/// design/cerita/README.md.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

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
  final _halaman = PageController();
  final _nama = TextEditingController();
  int _posisi = 0;
  int? _usia;

  @override
  void dispose() {
    _halaman.dispose();
    _nama.dispose();
    super.dispose();
  }

  void _berikut() {
    _halaman.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
  }

  Future<void> _mulai() async {
    await ref.read(numiControllerProvider.notifier).daftar(nama: _nama.text, usia: _usia!);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(transisiPudar(const DiagnosticIntroScreen()));
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
                          color: i == _posisi ? NumiWarna.cahaya : Colors.white24,
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
                    for (final adegan in _cerita) _HalamanCerita(adegan: adegan),
                    _FormProfil(
                      nama: _nama,
                      usia: _usia,
                      onUsia: (u) => setState(() => _usia = u),
                      onUbah: () => setState(() {}),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: _posisi < _cerita.length
                    ? TombolNumi(
                        label: _posisi == _cerita.length - 1 ? 'Aku mau membantu!' : 'Lanjut',
                        lebar: double.infinity,
                        onTap: _berikut,
                      )
                    : TombolNumi(
                        label: 'Mulai Petualangan',
                        lebar: double.infinity,
                        onTap: _nama.text.trim().isEmpty || _usia == null ? null : _mulai,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(left: 0, bottom: 20, child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 90)),
                Positioned(right: 0, bottom: 40, child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 70)),
                Positioned(top: 0, child: NumiMascot(ukuran: 150, ekspresi: adegan.ekspresi)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            adegan.teks,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 21, height: 1.45, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _FormProfil extends StatelessWidget {
  const _FormProfil({required this.nama, required this.usia, required this.onUsia, required this.onUbah});

  final TextEditingController nama;
  final int? usia;
  final ValueChanged<int> onUsia;
  final VoidCallback onUbah;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: NumiMascot(ukuran: 120, ekspresi: EkspresiMaskot.senang)),
          const Text(
            'Halo, Teman!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Isi bersama ayah, ibu, atau wali ya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text('Siapa namamu?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
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
          const Text('Berapa umurmu?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var u = 6; u <= 12; u++)
                GestureDetector(
                  onTap: () => onUsia(u),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: usia == u ? NumiWarna.cahaya : Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: usia == u ? Colors.white : Colors.white24, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$u',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: usia == u ? NumiWarna.tinta : Colors.white,
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
                child: Text('Data tersimpan aman di perangkat ini', style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
