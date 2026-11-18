import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../data/models/data_belajar.dart';
import '../../data/models/siswa.dart';
import '../../data/repositories/akun_repository.dart';
import '../../data/repositories/local_profil_repository.dart';
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
  GlobalKey<NavigatorState> _navigatorProfil = GlobalKey<NavigatorState>();
  Timer? _ulangSinkron;

  LocalProfilRepository? get _cloud {
    final repo = _repository;
    return repo is LocalProfilRepository && repo.cloud != null ? repo : null;
  }

  int _gantiGenerasi() {
    _navigatorProfil = GlobalKey<NavigatorState>();
    return ++_generasi;
  }

  @override
  void initState() {
    super.initState();
    final cloud = _cloud;
    if (cloud != null) {
      cloud.kirimKeCloud();
      _ulangSinkron = Timer.periodic(const Duration(seconds: 30), (_) {
        if (!cloud.cloudAktif) return;
        unawaited(_ulangKirim(cloud));
      });
    }
  }

  Future<void> _ulangKirim(LocalProfilRepository repo) async {
    final sebelum = repo.hasilSinkron;
    final sesudah = await repo.sinkron(tarik: false);
    if (mounted && _aktif == null && !_menunggu && sebelum != sesudah) {
      setState(() => _pesan = null);
    }
  }

  @override
  void dispose() {
    _ulangSinkron?.cancel();
    super.dispose();
  }

  Future<void> _aturSinkron(LocalProfilRepository repo) async {
    final dialogContext = _navigatorProfil.currentState?.overlay?.context;
    if (dialogContext == null || _menunggu) return;
    final pilihan = await showDialog<bool>(
      context: dialogContext,
      builder: (context) => AlertDialog(
        title: const Text('Sinkronisasi antarperangkat'),
        content: const Text(
          'Akun wali ini dapat menyimpan nama panggilan, kelas, jawaban, dan '
          'progres anak ke Firebase untuk dipakai di perangkat lain. '
          'Mematikan sinkronisasi di perangkat ini menghentikan pengiriman '
          'berikutnya. Salinan yang sudah tersimpan tetap tersedia.',
        ),
        actions: [
          if (repo.cloudAktif)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Matikan di perangkat ini'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(repo.cloudAktif ? 'Sinkronkan sekarang' : 'Setujui'),
          ),
        ],
      ),
    );
    if (!mounted || pilihan == null || _menunggu) return;
    _gantiGenerasi();
    setState(() => _menunggu = true);
    String pesan;
    try {
      await repo.aturCloud(pilihan);
      final hasil = pilihan
          ? await repo.sinkron(tarik: true)
          : HasilSinkronProfil.lokal;
      pesan = switch (hasil) {
        HasilSinkronProfil.selesai => 'Sinkronisasi selesai.',
        HasilSinkronProfil.tertunda =>
          'Sinkronisasi tertunda. Data di perangkat masih tersedia.',
        HasilSinkronProfil.konflik =>
          'Profil berubah di dua perangkat. Kedua salinan dipertahankan.',
        HasilSinkronProfil.dataTidakValid =>
          'Ada profil cloud yang tidak valid. Profil lain tetap disinkronkan; '
              'data di perangkat ini tetap tersedia.',
        HasilSinkronProfil.lokal => 'Sinkronisasi di perangkat ini dimatikan.',
      };
    } catch (_) {
      pesan = 'Pengaturan sinkronisasi belum tersimpan. Coba lagi.';
    }
    if (!mounted) return;
    setState(() {
      _menunggu = false;
      _pesan = pesan;
    });
  }

  Future<void> _pilih(Siswa siswa, bool baru) async {
    if (_menunggu) return;
    final generasi = _gantiGenerasi();
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

  Future<void> _atasiKonflik(LocalProfilRepository repo) async {
    final contextDialog = _navigatorProfil.currentState?.overlay?.context;
    if (_menunggu || contextDialog == null || repo.konflik.isEmpty) return;
    final konflik = repo.konflik.first;
    String ringkas(DataBelajar data) =>
        '${data.siswa!.nama}, kelas ${data.siswa!.kelas}\n'
        '${data.xp} XP · ${data.progresLesson.values.where((l) => l.selesai).length} lesson selesai\n'
        '${data.hasilMastery.length} percobaan mastery';
    final gunakanCloud = await showDialog<bool>(
      context: contextDialog,
      builder: (context) => AlertDialog(
        title: const Text('Pilih progres yang dipakai'),
        content: SingleChildScrollView(
          child: Text(
            'Perangkat ini:\n${ringkas(konflik.lokal)}\n\n'
            'Cloud:\n${ringkas(konflik.cloud)}\n\n'
            'Pilihan ini mengganti progres profil dengan salinan yang dipilih. '
            'Kedua salinan dicadangkan di perangkat ini sebelum perubahan.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pakai cloud'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Pakai perangkat ini'),
          ),
        ],
      ),
    );
    if (!mounted || gunakanCloud == null || _menunggu) return;
    _gantiGenerasi();
    setState(() => _menunggu = true);
    String pesan;
    try {
      await repo.selesaikanKonflik(konflik, gunakanCloud: gunakanCloud);
      pesan =
          'Pilihan tersimpan dan kedua salinan dicadangkan di perangkat ini. '
          'Ketuk Sinkronisasi untuk memeriksa profil lainnya.';
    } catch (_) {
      pesan =
          'Konflik belum selesai. Data atau koneksi mungkin berubah. '
          'Ketuk Sinkronisasi sebelum memilih lagi; salinan lokal tetap tersedia.';
    }
    if (!mounted) return;
    setState(() {
      _menunggu = false;
      _pesan = pesan;
    });
  }

  void _kelola() {
    _gantiGenerasi();
    setState(() {
      _aktif = null;
      _pesan = null;
    });
  }

  Future<void> _keluar() async {
    if (_menunggu) return;
    _gantiGenerasi();
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
      final cloud = _cloud;
      return NumiApp(
        key: ValueKey('profil-$_generasi'),
        navigatorKey: _navigatorProfil,
        bilahWali: cloud == null
            ? null
            : SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: [
                      if (cloud.konflik.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _atasiKonflik(cloud),
                          icon: const Icon(Icons.compare_arrows),
                          label: const Text('Selesaikan konflik'),
                        ),
                      TextButton.icon(
                        onPressed: () => _aturSinkron(cloud),
                        icon: const Icon(Icons.cloud_outlined),
                        label: const Text('Sinkronisasi'),
                      ),
                    ],
                  ),
                ),
              ),
        home: ProfilScreen(
          repository: _repository,
          onPilih: _pilih,
          onKeluar: _keluar,
          pesan:
              _pesan ??
              (cloud?.cloudAktif == true
                  ? switch (cloud!.hasilSinkron) {
                      HasilSinkronProfil.konflik => 'Profil berubah di dua perangkat. Kedua salinan dipertahankan.',
                      HasilSinkronProfil.tertunda => 'Sinkronisasi tertunda. Ketuk Sinkronisasi untuk mencoba lagi.',
                      HasilSinkronProfil.dataTidakValid => 'Ada profil cloud yang tidak valid. Profil lain tetap disinkronkan; data di perangkat ini tetap tersedia.',
                      _ => null,
                    }
                  : null),
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
