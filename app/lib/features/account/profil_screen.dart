import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/siswa.dart';
import '../../data/repositories/profil_repository.dart';
import '../../core/widgets/tombol_numi.dart';
import '../mascot/numi_mascot.dart';
import 'periksa_profil.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({
    super.key,
    required this.repository,
    required this.onPilih,
    required this.onKeluar,
    this.pesan,
  });
  final ProfilRepository repository;
  final void Function(Siswa, bool baru) onPilih;
  final VoidCallback onKeluar;
  final String? pesan;
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late Future<List<Siswa>> _profil = widget.repository.daftar();
  Future<void> _form([Siswa? siswa]) async {
    final hasil = await showDialog<Siswa>(
      context: context,
      builder: (_) => _FormProfil(repository: widget.repository, siswa: siswa),
    );
    if (!mounted || hasil == null) return;
    if (siswa == null) {
      widget.onPilih(hasil, true);
    } else {
      setState(() {
        _profil = widget.repository.daftar();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 468),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Center(child: NumiMascot(ukuran: 110, melayang: false)),
              const SizedBox(height: 12),
              Text(
                'Pilih profil anak',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Ketuk profil anak yang akan belajar.',
                textAlign: TextAlign.center,
              ),
              if (widget.pesan != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(widget.pesan!),
                  ),
                ),
              const SizedBox(height: 16),
              FutureBuilder<List<Siswa>>(
                future: _profil,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        const Text(
                          'Profil belum dapat dibuka. Data sebelumnya tetap disimpan.',
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _profil = widget.repository.daftar();
                          }),
                          child: const Text('Coba muat lagi'),
                        ),
                      ],
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Belum ada profil. Tambahkan profil anak untuk memulai.',
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final siswa in snapshot.data!)
                        Card(
                          color: NumiWarna.krem,
                          child: ListTile(
                            minVerticalPadding: 16,
                            title: Text(siswa.nama),
                            subtitle: Text('Kelas ${siswa.kelas}'),
                            trailing: IconButton(
                              tooltip: 'Ubah profil ${siswa.nama}',
                              icon: const Icon(Icons.edit_rounded),
                              onPressed: () => _form(siswa),
                            ),
                            onTap: () => widget.onPilih(siswa, false),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              TombolNumi(label: 'Tambah profil anak', onTap: () => _form()),
              const SizedBox(height: 24),
              TombolNumi(
                onTap: widget.onKeluar,
                warna: NumiWarna.kartu,
                label: 'Keluar akun',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FormProfil extends StatefulWidget {
  const _FormProfil({required this.repository, this.siswa});
  final ProfilRepository repository;
  final Siswa? siswa;
  @override
  State<_FormProfil> createState() => _FormProfilState();
}

class _FormProfilState extends State<_FormProfil> {
  late final _nama = TextEditingController(text: widget.siswa?.nama ?? '');
  late int? _kelas = widget.siswa?.kelas;
  bool _menyimpan = false;
  String? _galat;
  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_menyimpan || _kelas == null) return;
    FocusScope.of(context).unfocus();
    if (!await periksaProfilAnak(context, _nama.text, _kelas!) || !mounted) {
      return;
    }
    setState(() {
      _menyimpan = true;
      _galat = null;
    });
    try {
      final lama = widget.siswa;
      final Siswa hasil;
      if (lama == null) {
        hasil = await widget.repository.tambah(
          nama: _nama.text,
          kelas: _kelas!,
        );
      } else {
        await widget.repository.ubah(lama.id, nama: _nama.text, kelas: _kelas!);
        hasil = lama.copyWith(nama: _nama.text.trim(), kelas: _kelas);
      }
      if (mounted) Navigator.pop(context, hasil);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _menyimpan = false;
        _galat = 'Profil belum tersimpan. Coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.siswa == null ? 'Profil anak baru' : 'Ubah profil anak'),
    content: SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: _menyimpan,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nama,
                maxLength: 30,
                decoration: const InputDecoration(labelText: 'Nama panggilan'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var kelas = 1; kelas <= 6; kelas++)
                    SizedBox(
                      height: 56,
                      child: ChoiceChip(
                        label: Text('Kelas $kelas'),
                        selected: kelas == _kelas,
                        onSelected: (_) => setState(() => _kelas = kelas),
                      ),
                    ),
                ],
              ),
              if (_galat != null)
                Semantics(liveRegion: true, child: Text(_galat!)),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _menyimpan ? null : () => Navigator.pop(context),
        child: const Text('Kembali'),
      ),
      TextButton(
        onPressed: _menyimpan || _kelas == null || _nama.text.trim().isEmpty
            ? null
            : _simpan,
        child: Text(_menyimpan ? 'Menyimpan...' : 'Periksa profil'),
      ),
    ],
  );
}
