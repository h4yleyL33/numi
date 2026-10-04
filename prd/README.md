# PRD Numi

Product Requirements Document untuk Numi versi 1.0 (MVP semester ganjil 2026). Dokumen ini
merangkum apa yang dibangun, untuk siapa, dan kapan dianggap berhasil. Rinciannya dipecah ke
beberapa berkas di folder ini supaya tiap orang di tim cukup membuka bagian yang ia pegang.

| Berkas | Isi | Dipakai oleh |
|---|---|---|
| `README.md` | PRD utama: masalah, pengguna, fitur, ukuran keberhasilan | semua |
| `kajian-ui-anak.md` | Kajian UI/UX untuk anak 6-12 tahun dan aturan desain turunannya | desain, frontend |
| `kurikulum-kelas-1-3.md` | Materi, bentuk soal, dan tampilan untuk kelas kecil | konten, frontend |
| `kurikulum-kelas-4-6.md` | Materi, bentuk soal, dan tampilan untuk kelas besar | konten, frontend |
| `redesign-ui.md` | Audit UI lama (terlalu banyak tombol) dan rancangan baru | desain, Figma |
| `mockup/*.svg` | Mockup layar hasil redesign, bisa diseret langsung ke Figma | desain |

Sumber kebutuhan tetap doktek Bab 1 (FR, NFR, DATA). PRD ini tidak menambah kebutuhan baru;
yang ditambahkan hanya keputusan produk dan desain yang belum tertulis di doktek. Kalau ada
yang bertentangan, doktek yang dipakai, lalu PRD ini direvisi.

## 1. Ringkasan

Numi adalah aplikasi Android untuk siswa SD usia 6 sampai 12 tahun yang belum kuat di
numerasi dasar. Anak mengikuti tes penempatan singkat, lalu melihat peta dua belas pulau.
Setiap pulau adalah satu topik Kurikulum Merdeka. Anak menyalakan mercusuar di tiap pulau
dengan menyelesaikan lesson dan mastery test, ditemani maskot kunang-kunang bernama Numi.

## 2. Masalah

1. Banyak siswa gagal matematika di jenjang atas karena konsep dasarnya belum kuat, dan
   celah ini terbawa sampai SMA (doktek 1.1).
2. Skor matematika PISA 2022 Indonesia 366, turun dari 379 pada 2018 (doktek 1.1).
3. Aplikasi yang ada unggul di satu sisi saja. Duolingo Math kuat di gamifikasi, Quizizz di
   kuis, Marbel di visual anak kecil, tetapi tidak ada yang mendeteksi celah tiap anak lalu
   menyusun jalur belajarnya.

## 3. Pengguna

| Persona | Gambaran | Yang dibutuhkan dari Numi |
|---|---|---|
| Raka, 7 tahun, kelas 1 | Baru lancar membaca suku kata. Main HP ibunya sepulang sekolah. Cepat bosan kalau tulisan panjang. | Soal bergambar, suara yang membacakan, satu tombol besar yang jelas |
| Salsa, 10 tahun, kelas 4 | Lancar membaca, punya HP sendiri. Perkalian masih sering salah, malu bertanya di kelas. | Latihan tanpa dinilai teman, soal cerita yang dekat dengan kesehariannya, hadiah yang terasa adil |
| Bu Rina, ibu Raka | Bekerja, mendampingi belajar malam hari. Tidak paham istilah kurikulum. | Ringkasan singkat: topik mana yang sudah dan belum, tanpa harus membuka banyak menu |

Guru dan dashboard kelas di luar MVP (doktek 1.3).

## 4. Tujuan dan ukuran keberhasilan

| Tujuan | Ukuran | Target MVP | Kebutuhan |
|---|---|---|---|
| Anak bisa memakai Numi sendiri | Anak kelas 1 menyelesaikan satu lesson tanpa dibantu | 4 dari 5 anak saat uji pengguna | NFR-001 |
| Tes penempatan tidak melelahkan | Durasi diagnostic | median di bawah 6 menit | FR-001 |
| Anak kembali besok | Anak yang membuka lagi di hari ke-2 dan ke-7 (uji lapangan kecil) | 60% hari ke-2, 30% hari ke-7 | FR-006, FR-009 |
| Belajar benar-benar terjadi | Skor soal sejenis sebelum dan sesudah satu pulau dikuasai | naik minimal 20 poin persentase | FR-007 |
| Aplikasi responsif | Waktu dari Cek Jawaban sampai umpan balik | 2 detik atau kurang | NFR-002 |
| Aman untuk anak | Iklan pihak ketiga, data keluar perangkat tanpa izin wali | 0 | NFR-005, NFR-006 |

## 5. Ruang lingkup fitur

Prioritas memakai MoSCoW sesuai doktek 1.4.

| Fitur | Ringkas | Prioritas | Kebutuhan | Kriteria terima |
|---|---|---|---|---|
| Onboarding cerita | 3 layar cerita lalu nama dan umur | Must | DATA-001 | Selesai dalam 60 detik, tanpa keyboard selain nama |
| Diagnostic adaptif | 2 soal per topik, naik atau turun topik, tanpa umpan balik | Must | FR-001 | Paling banyak 12 soal, hasil menentukan kelompok belajar |
| Skill map 12 pulau | Status terkunci, belum, latihan, dikuasai | Must | FR-002 | Status terbaca dari warna dan ikon, bukan hanya teks |
| Jalur belajar | Numi melayang di atas pulau yang disarankan | Must | FR-003 | Selalu ada tepat satu saran |
| Lesson kelas kecil | Kenalan dan Latihan, soal visual | Must | FR-004a | Lihat `kurikulum-kelas-1-3.md` |
| Lesson kelas besar | Simbol dan soal cerita | Must | FR-004b | Lihat `kurikulum-kelas-4-6.md` |
| Umpan balik langsung | Banner benar atau salah dengan penjelasan | Must | FR-005 | Jawaban salah selalu disertai jawaban benar dan satu kalimat alasan |
| Mastery test | 5 soal, ambang 95 | Must | FR-007 | Lulus menyalakan mercusuar dan membuka pulau berikutnya |
| XP, streak, lencana, level | Tanpa leaderboard | Should | FR-006 | 8 lencana, aturan di `app_config.dart` |
| Progres dan ruang orang tua | Ringkasan untuk anak, rincian untuk orang tua di balik gerbang | Should | FR-008 | Orang tua melihat status 12 topik dalam satu layar |
| Pesan maskot | Sapaan, streak terancam, lama tidak aktif | Should | FR-009 | Paling banyak satu pesan per jenis per hari |
| Suara pembaca soal | Tombol speaker membacakan soal | Should (baru) | NFR-001 | Ada di semua soal kelas kecil |

Di luar lingkup MVP: leaderboard, dashboard guru, materi geometri dan statistika, pembelian
dalam aplikasi, iklan, login media sosial.

## 6. Alur utama

```
Buka aplikasi
  └─ pertama kali → Cerita (3 layar) → Nama & umur → Diagnostic → Hasil → Peta
  └─ berikutnya   → Peta (Numi menyapa) → tombol MAIN → Lesson/Mastery berikutnya → Hasil → Peta
```

Perubahan terbesar dari rancangan lama ada di sini: dari peta, anak cukup menekan satu
tombol MAIN. Sistem yang memilih lesson atau mastery test berikutnya dari learning path
(FR-003). Memilih pulau sendiri tetap bisa dengan mengetuk pulau, tetapi bukan jalan
utama. Alasannya ada di `redesign-ui.md` dan `kajian-ui-anak.md`.

## 7. Aturan desain yang mengikat

Ringkasan dari `kajian-ui-anak.md`. Semua layar baru di Figma harus lolos daftar ini.

1. Satu layar, satu tombol utama. Tombol kedua hanya boleh berupa ikon kecil (kembali, suara).
2. Target sentuh minimal 64 dp untuk kelas kecil, 48 dp untuk kelas besar.
3. Kalimat instruksi paling banyak 8 kata untuk kelas kecil, dan selalu bisa dibacakan.
4. Status tidak pernah hanya dibedakan warna; selalu ada bentuk atau ikon.
5. Salah tidak dihukum: tidak ada nyawa, tidak ada suara buzzer, Numi memakai ekspresi semangat.
6. Pengaturan, hapus data, dan rincian progres ada di ruang orang tua yang dibuka dengan
   gerbang sederhana (tekan tahan 3 detik atau jawab soal penjumlahan dua digit).
7. Tidak ada iklan, tidak ada tautan keluar, tidak ada pembelian.

## 8. Risiko

| Risiko | Dampak | Penanganan |
|---|---|---|
| Ambang mastery 95 (5 dari 5) terlalu berat untuk kelas 1 | Anak frustrasi dan berhenti | Dicatat di `docs/02-perancangan/kurikulum`, uji ke anak, ubah satu konstanta bila perlu |
| Anak kelas 1 belum bisa membaca soal | NFR-001 gagal | Suara pembaca soal, ikon di semua tombol |
| Diagnostic menaruh anak di kelompok yang salah | Soal terlalu mudah atau sulit | Kelompok dihitung ulang setiap mastery test lulus |
| Firebase belum terpasang sampai akhir semester | NFR-005 belum terpenuhi | Repository dipisah lewat `NumiRepository`, penyimpanan lokal tetap jalan |

## 9. Jadwal

Mengikuti Gantt chart di `docs/02-perancangan/Gantt Chart Numi.xlsx`.

| Minggu | Fase | Keluaran PRD terkait |
|---|---|---|
| 1 | Inisiasi | PRD bagian 1-4 |
| 2-3 | Perancangan | Kajian UI, kurikulum, redesign, mockup Figma |
| 4-9 | Implementasi | Fitur bagian 5 |
| 10-11 | Pengujian | Ukuran keberhasilan bagian 4, uji pengguna 5 anak per kelompok |
| 12-13 | Deployment | APK rilis |
