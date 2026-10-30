import 'package:flutter/material.dart';

import '../../core/widgets/latar_malam.dart';
import '../../core/widgets/tombol_numi.dart';
import '../../data/repositories/akun_repository.dart';

class MasukScreen extends StatefulWidget {
  const MasukScreen({super.key, required this.akun});
  final AkunRepository akun;
  @override
  State<MasukScreen> createState() => _MasukScreenState();
}

class _MasukScreenState extends State<MasukScreen> {
  bool _menunggu = false;
  String? _pesan;

  Future<void> _masuk() async {
    if (_menunggu) return;
    setState(() {
      _menunggu = true;
      _pesan = null;
    });
    try {
      final hasil = await widget.akun.masukGoogle();
      if (!mounted) return;
      setState(() {
        // Berhasil tetap menunggu stream Firebase sebelum membuka profil.
        _menunggu = hasil == HasilMasuk.berhasil;
        if (hasil == HasilMasuk.dibatalkan) {
          _pesan = 'Masuk dibatalkan. Silakan coba lagi.';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _menunggu = false;
        _pesan = 'Belum berhasil masuk. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: LatarMalam(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.family_restroom_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Petualangan dimulai bersama wali',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ayah, ibu, atau wali masuk dengan akun Google. Anak belajar lewat profilnya sendiri.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  if (_pesan != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _pesan!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 28),
                  TombolNumi(
                    label: _menunggu
                        ? 'Sedang masuk...'
                        : 'Masuk dengan Google',
                    lebar: double.infinity,
                    onTap: _menunggu ? null : _masuk,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class LayananAkunScreen extends StatelessWidget {
  const LayananAkunScreen({super.key, this.onCoba});
  final VoidCallback? onCoba;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 64),
              const SizedBox(height: 20),
              const Text(
                'Layanan akun belum tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Data belajar belum dibuka. Silakan coba lagi nanti.',
                textAlign: TextAlign.center,
              ),
              if (onCoba != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TombolNumi(label: 'Coba lagi', onTap: onCoba),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
