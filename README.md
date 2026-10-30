# Numi

Platform belajar matematika adaptif berbasis gamifikasi untuk siswa SD kelas 1 sampai 6.
Numi mendeteksi learning gap numerasi dasar lewat diagnostic test, memetakan kemampuan siswa
di skill map, lalu menyusun jalur belajar personal. Materi mengacu ke Capaian Pembelajaran
Matematika Kurikulum Merdeka (BSKAP 046/H/KR/2025). Cakupan awal berisi 12 topik numerasi.
Kelas membantu menentukan titik awal, sementara rancangan pembelajaran mengikuti bukti
kemampuan per keterampilan. Profil berisi nama panggilan dan satu kelas 1–6. Rancangan terbaru
memakai akun Google wali dan beberapa profil anak. Adapter serta alur profil lokal per akun
sudah tersedia; konfigurasi Firebase tim dan login nyata belum diverifikasi.

Baseline pengembangan berdasarkan seluruh PRD serta PPL/doktek Bab I–III tersedia di
[`docs/03-implementasi`](docs/03-implementasi/README.md). Urutan dan kriteria pekerjaan ada di
[`tasks/plan.md`](tasks/plan.md) dan [`tasks/todo.md`](tasks/todo.md).

Proyek mata kuliah Rekayasa Perangkat Lunak, Teknik Informatika Unpad, semester ganjil 2026.
Metodologi Waterfall, 13 minggu (7 September sampai 6 Desember 2026).

## Tim

| Nama | NPM | Peran |
|---|---|---|
| Yarfi Setya Nugraha | 140810240003 | Ketua |
| Muhammad Andri Firmansyah | 140810240009 | Anggota |
| Alfrandiano Immanuel Rionaldo Holle | 140810247001 | Anggota |
| Khalit Putra Afana | 140810240007 | Anggota |
| Nabil Rizky Aulia Utomo | 140810240045 | Anggota |

Dosen: Dr. Mira Suryani, S.Pd., M.Kom.
Asisten praktikum: Hafizh Fadhl Muhammad, Dafa Ghani Abdul Rabbani.

## Isi folder

```
numi/
  materi draft1/          bahan awal (proposal Bab 1, doktek, project charter, UCD canvas, link)
  docs/
    01-inisiasi/          minggu 1
    02-perancangan/       minggu 2-3
      kurikulum/          pemetaan CP Kurikulum Merdeka ke 12 topik
      uml/                diagram UML dan ERD (sumber PlantUML, PNG, SVG)
        target-v3-2026-10-29/  sepuluh diagram rancangan terbaru
      doktek-bab2/        Bab 2 doktek v1.2 (Markdown dan .docx siap tempel)
      imun Gantt Chart.xlsx
    03-presentasi/        presentasi RPL Numi di Figma dan pratinjau slide
    03-implementasi/      minggu 4-9
    04-pengujian/         minggu 10-11
    05-deployment/        minggu 12-13
  design/
    cerita/               alur cerita Samudra Angka
    maskot/               SVG sebelas ekspresi Numi dan panduannya
    aset/                 SVG pulau, mercusuar, lencana, ikon, benda hitung, api streak
    wajah/                SVG 11 wajah emosi untuk base plate mob
    barang/barang.json    136 barang esensial dalam 7 tema
    figma-plugin/         plugin Numi Builder: page mob, emote, bg animasi, item
    pratinjau-aset.html   semua aset dalam satu halaman
    tools/buat_svg.mjs    pembuat aset SVG
  prd/                    PRD, kajian UI anak, kurikulum kelas 1-3 dan 4-6, redesign UI dan mockup
  app/                    aplikasi Flutter
  firebase/               rancangan aturan Firestore
  output/                 PDF dokumen dan arsip UML
```

Desain visual, aset, dan prototype Numi ada di [Figma](https://www.figma.com/design/y0iET9hEQwy0xMFtV95Pek/numi-lebih-lengkap).
Presentasi RPL berisi 21 slide ada di halaman [04 Presentasi RPL Numi](https://www.figma.com/design/y0iET9hEQwy0xMFtV95Pek/numi-lebih-lengkap?node-id=2038-3126).

## Dokumen dan UML

- [Daftar UML beserta sumber dan hasil render](docs/02-perancangan/uml/README.md).
- [UML target terbaru](docs/02-perancangan/uml/target-v3-2026-10-29/README.md).
- [Keputusan kurikulum, usia, UI/UX, dan asesmen](docs/02-perancangan/audit-kurikulum-2026-10-29/keputusan-v3.md).
- [Presentasi RPL Numi](docs/03-presentasi/figma-rpl-2026-10-30/README.md).
- [PDF dokumen proyek](output/pdf/).

Diagram target menjelaskan rancangan pengembangan. Sebagian aturan asesmen dan checkpoint
per jawaban belum diterapkan pada kode. Materi luas, volume, geometri, serta data dan peluang
belum termasuk 12 topik awal.

## Struktur aplikasi

```
app/lib/
  main.dart               memuat data, lalu menjalankan aplikasi
  app.dart
  core/                   konfigurasi, tema, utilitas, widget bersama
  data/
    models/               entitas sesuai ERD (Siswa, Topik, Soal, Jawaban, SkillMap, ...)
    content/              12 topik, lesson, lencana, kalimat maskot, generator soal
    repositories/         kontrak NumiRepository dan penyimpanan lokal
  domain/                 diagnostic adaptif, skill map, learning path, progres, maskot
  state/                  NumiController (Riverpod)
  features/               layar per fitur
app/test/                 pengujian logika dan widget, termasuk tampilan responsif
```

Tiap folder fitur bisa ditelusuri ke kebutuhan di SRS, sehingga baris RTM di Bab 5 doktek cukup
menunjuk ke folder atau berkasnya.

| Folder | Kebutuhan | Use case |
|---|---|---|
| `features/onboarding` | NFR-005, DATA-001 | UC-008 |
| `features/diagnostic`, `domain/diagnostic_engine.dart` | FR-001 | UC-001 |
| `features/skill_map`, `domain/skill_map_service.dart` | FR-002 | UC-002 |
| `domain/learning_path_service.dart` | FR-003 | UC-009 |
| `features/lesson`, `features/quiz`, `data/content/generator_soal.dart` | FR-004a, FR-004b | UC-003 |
| `features/feedback` | FR-005 | UC-004 |
| `domain/progress_service.dart` | FR-006 | UC-010 |
| `features/mastery` | FR-007 | UC-005 |
| `features/progress` | FR-008 | UC-006 |
| `features/mascot`, `domain/companion_service.dart` | FR-009 | UC-007 |

## Menjalankan

Flutter 3.47 terpasang di `D:\khalee\flutter`. Dari folder `app`:

```bash
flutter pub get
```

```bash
flutter test
```

```bash
flutter run -d chrome --dart-define=NUMI_LOCAL_DEMO=true
```

Demo memakai `LocalNumiRepository` dan hanya tersedia pada build non-release. Alur akun bawaan
memakai adapter Google/Firebase dan `LocalProfilRepository` per UID; data belajar tetap di
perangkat. Sebelum konfigurasi Firebase, aplikasi menampilkan layanan akun belum tersedia.
Ikuti [panduan Firebase](firebase/README.md) setelah proyek tim dibuat. Firestore, migrasi data
tanpa UID ke akun, serta checkpoint lesson/diagnostic belum diintegrasikan. Checkpoint mastery
lokal sudah tersedia; lihat [catatan implementasi](docs/03-implementasi/CHECKPOINT-MASTERY.md).
`firebase/firestore.rules` masih rancangan
jalur lama dan belum menjadi aturan final beberapa profil.

## Tautan kerja

Semua tautan Google Docs, Slides, Figma, dan Sheets ada di `materi draft1/link.txt`.
