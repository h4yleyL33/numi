import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/krayon.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/models/companion_message.dart';
import '../../state/numi_controller.dart';
import '../account/periksa_profil.dart';
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
    EkspresiMaskot.berpikir,
    false,
  ),
  _AdeganCerita(
    'Aku Numi, kunang-kunang penjaga cahaya. Aku bisa menyalakan mercusuar lagi, tapi aku butuh teman yang pandai berhitung. Maukah kamu membantuku?',
    EkspresiMaskot.semangat,
    false,
  ),
];

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _galatSimpan = 'Profil belum tersimpan. Coba lagi.';
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

  Future<void> _periksa() async {
    final kelas = _kelas;
    if (kelas == null || _nama.text.trim().isEmpty) {
      setState(() => _galat = 'Isi nama panggilan dan pilih kelas anak.');
      return;
    }
    FocusScope.of(context).unfocus();
    if (await periksaProfilAnak(context, _nama.text, kelas) && mounted) {
      await _mulai();
    }
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
      final tujuan = !ref.read(numiControllerProvider).perluDiagnostic
          ? const HomeShell()
          : const DiagnosticIntroScreen();
      Navigator.of(context).pushReplacement(transisiPudar(tujuan));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _menyimpan = false;
        _galat = _galatSimpan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LatarKrayon(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
                    child: Semantics(
                      label:
                          'Langkah ${_posisi + 1} dari ${_cerita.length + 1}',
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
                                    : NumiWarna.kartu,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ],
                      ),
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
                          onKelas: (k) => setState(() {
                            _kelas = k;
                            _galat = null;
                          }),
                          onUbah: () => setState(() => _galat = null),
                        ),
                      ],
                    ),
                  ),
                  if (_galat != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _galat!,
                          style: const TextStyle(color: NumiWarna.tinta),
                        ),
                      ),
                    ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 468),
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
                                : _galat == _galatSimpan
                                ? 'Coba simpan lagi'
                                : 'Periksa profil',
                            lebar: double.infinity,
                            onTap: _menyimpan
                                ? null
                                : _galat == _galatSimpan
                                ? _mulai
                                : _periksa,
                          ),
                  ),
                ],
              ),
            ),
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
          width: mendatar ? 240 : (batas.maxWidth - 48).clamp(0.0, 320.0),
          height: mendatar ? 208 : 266,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 90),
              ),
              Positioned(
                right: 0,
                bottom: 6,
                child: PulauHias(menyala: adegan.pulauMenyala, ukuran: 70),
              ),
              Positioned(
                top: 0,
                child: NumiMascot(
                  ukuran: mendatar ? 120 : 150,
                  ekspresi: adegan.ekspresi,
                  melayang: false,
                ),
              ),
            ],
          ),
        );
        final teks = DecoratedBox(
          decoration: kertasKrayon('panel-cerita'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
            child: Text(
              adegan.teks,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: NumiWarna.tinta,
                fontSize: 19,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        return Align(
          alignment: mendatar ? Alignment.center : Alignment.topCenter,
          child: SingleChildScrollView(
            padding: mendatar
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                : const EdgeInsets.fromLTRB(20, 36, 20, 12),
            child: mendatar
                ? Row(
                    children: [
                      gambar,
                      const SizedBox(width: 32),
                      Expanded(child: teks),
                    ],
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [gambar, const SizedBox(height: 24), teks],
                    ),
                  ),
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: NumiMascot(ukuran: 78, melayang: false)),
              Text(
                'Profil anak',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Diisi bersama ayah, ibu, atau wali.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 24),
              const Text(
                '1. Nama panggilan anak',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: kertasKrayon('kolom-nama'),
                child: TextField(
                  controller: nama,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  onChanged: (_) => onUbah(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ketuk untuk mengisi nama',
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    counterText: '',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Contoh: Adi. Tidak perlu nama lengkap.',
                style: TextStyle(color: NumiWarna.tintaPudar, fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Text(
                '2. Kelas anak saat ini',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih satu kelas SD, sesuai kelas sekarang.',
                style: TextStyle(color: NumiWarna.tintaPudar, fontSize: 13),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, batas) {
                  const jarak = 10.0;
                  final kolom = batas.maxWidth >= 300 ? 3 : 2;
                  final lebar = (batas.maxWidth - jarak * (kolom - 1)) / kolom;
                  return Wrap(
                    spacing: jarak,
                    runSpacing: jarak,
                    children: [
                      for (var k = 1; k <= 6; k++)
                        Semantics(
                          selected: kelas == k,
                          child: Container(
                            width: lebar,
                            height: 64,
                            decoration: kelas == k
                                ? BoxDecoration(
                                    color: NumiWarna.cahaya,
                                    border: Border.all(color: NumiWarna.garis),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : kertasKrayon('kelas-netral'),
                            child: TextButton(
                              onPressed: () => onKelas(k),
                              style: TextButton.styleFrom(
                                foregroundColor: NumiWarna.tinta,
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Kelas $k',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                kelas == null
                    ? 'Belum ada kelas yang dipilih.'
                    : 'Kelas $kelas dipilih.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
