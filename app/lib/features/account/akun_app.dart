import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../data/models/data_belajar.dart';
import '../../data/models/siswa.dart';
import '../../data/repositories/akun_repository.dart';
import '../../data/repositories/numi_repository.dart';
import '../../data/repositories/profil_repository.dart';
import '../../state/numi_controller.dart';
import '../onboarding/onboarding_screen.dart';
import '../onboarding/splash_screen.dart';
import 'gerbang_wali.dart';
import 'masuk_screen.dart';
import 'profil_screen.dart';

/// Akun/profil memiliki Navigator dan ProviderScope sendiri. Pergantian konteks
/// membuang seluruh route privat, termasuk layar soal yang sedang terbuka.
class AkunApp extends StatefulWidget {
  const AkunApp({super.key, required this.akun, required this.profilUntuk});
  final AkunRepository akun;
  final ProfilRepository Function(AkunWali) profilUntuk;
  @override
  State<AkunApp> createState() => _AkunAppState();
}

class _AkunAppState extends State<AkunApp> {
  late Stream<AkunWali?> _perubahan = widget.akun.perubahanAkun;
  // Satu antrean tulis per UID, juga saat wali keluar lalu masuk kembali.
  final _repositoryPerAkun = <String, ProfilRepository>{};

  ProfilRepository _profilUntuk(AkunWali wali) =>
      _repositoryPerAkun.putIfAbsent(wali.uid, () => widget.profilUntuk(wali));
  @override
  Widget build(BuildContext context) => StreamBuilder<AkunWali?>(
    stream: _perubahan,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return NumiApp(
          key: const ValueKey('galat-akun'),
          home: LayananAkunScreen(
            onCoba: () =>
                setState(() => _perubahan = widget.akun.perubahanAkun),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const NumiApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }
      final wali = snapshot.data;
      if (wali == null) {
        return NumiApp(
          key: const ValueKey('masuk'),
          home: MasukScreen(akun: widget.akun),
        );
      }
      return _SesiWali(
        key: ValueKey(wali.uid),
        akun: widget.akun,
        wali: wali,
        profilUntuk: _profilUntuk,
      );
    },
  );
}

class _ProfilAktif {
  const _ProfilAktif(this.data, this.repository, this.baru, this.generasi);
  final DataBelajar data;
  final NumiRepository repository;
  final bool baru;
  final int generasi;
}

class _SesiWali extends StatefulWidget {
  const _SesiWali({
    super.key,
    required this.akun,
    required this.wali,
    required this.profilUntuk,
  });
  final AkunRepository akun;
  final AkunWali wali;
  final ProfilRepository Function(AkunWali) profilUntuk;
  @override
  State<_SesiWali> createState() => _SesiWaliState();
}

class _SesiWaliState extends State<_SesiWali> {
  late final _repository = widget.profilUntuk(widget.wali);
  _ProfilAktif? _aktif;
  bool _menunggu = false;
  String? _pesan;
  int _generasi = 0;
  final _navigator = GlobalKey<NavigatorState>();

  Future<void> _pilih(Siswa siswa, bool baru) async {
    if (_menunggu) return;
    final generasi = ++_generasi;
    setState(() {
      _aktif = null;
      _menunggu = true;
      _pesan = null;
    });
    try {
      final repo = _repository.untukProfil(
        siswa.id,
        masihAktif: () => mounted && _generasi == generasi,
      );
      final data = await repo.muat();
      if (!mounted || generasi != _generasi) return;
      setState(() {
        _aktif = _ProfilAktif(data, repo, baru, generasi);
        _menunggu = false;
      });
    } catch (_) {
      if (!mounted || generasi != _generasi) return;
      setState(() {
        _menunggu = false;
        _pesan = 'Profil belum dapat dibuka. Coba lagi.';
      });
    }
  }

  void _kelola() {
    _generasi++;
    setState(() => _aktif = null);
  }

  Future<void> _keluar() async {
    if (_menunggu) return;
    _generasi++;
    // Tutup data dan route sebelum menunggu SDK keluar.
    setState(() {
      _aktif = null;
      _menunggu = true;
      _pesan = null;
    });
    try {
      await widget.akun.keluar();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _menunggu = false;
        _pesan = 'Belum berhasil keluar akun. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_menunggu) {
      return const NumiApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    final aktif = _aktif;
    if (aktif == null) {
      return NumiApp(
        key: ValueKey('profil-$_generasi'),
        home: ProfilScreen(
          repository: _repository,
          onPilih: _pilih,
          onKeluar: _keluar,
          pesan: _pesan,
        ),
      );
    }
    return ProviderScope(
      key: ValueKey('belajar-${aktif.generasi}'),
      overrides: [
        repositoryProvider.overrideWithValue(aktif.repository),
        dataAwalProvider.overrideWithValue(aktif.data),
      ],
      child: NumiApp(
        navigatorKey: _navigator,
        home: aktif.baru
            ? const OnboardingScreen(tampilkanCerita: true)
            : const SplashScreen(),
        bilahWali: _BilahWali(onKelola: _kelola, navigator: _navigator),
      ),
    );
  }
}

class _BilahWali extends StatelessWidget {
  const _BilahWali({required this.onKelola, required this.navigator});
  final VoidCallback onKelola;
  final GlobalKey<NavigatorState> navigator;
  @override
  Widget build(BuildContext context) => Material(
    child: SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          icon: const Icon(Icons.family_restroom_rounded),
          label: const Text('Ruang wali'),
          style: TextButton.styleFrom(minimumSize: const Size(120, 48)),
          onPressed: () async {
            final dialogContext = navigator.currentState?.overlay?.context;
            if (dialogContext == null) return;
            if (await bukaGerbangWali(dialogContext) && dialogContext.mounted) {
              onKelola();
            }
          },
        ),
      ),
    ),
  );
}
