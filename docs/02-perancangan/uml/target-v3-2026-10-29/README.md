# UML target Numi v3

Rancangan 29 Oktober 2026. Sepuluh diagram pada `src/` telah dirender ke PNG dan SVG. Diagram ini adalah spesifikasi pengembangan berikutnya, bukan deskripsi bahwa kode sudah memenuhi rancangan.

- UCD-002: siswa dan wali sebagai aktor; guru validator di luar aplikasi.
- ACT-006: profil usia 6–12 tahun sampai latihan, asesmen, dan laporan.
- SEQ-007: penyaringan berbasis bukti skill dan batas cakupan.
- SEQ-008: mastery dengan pembahasan setelah blok.
- SEQ-009: transaksi respons/checkpoint, gagal simpan, dan resume idempoten.
- STM-005: bukti kemampuan dan akses materi yang terpisah.
- STM-006: status sesi dan pemulihan penyimpanan.
- CLS-004: model target profil usia 6–12, CP, skill, konten, bukti, dan checkpoint.
- ERD-002: rancangan data; belum merupakan migrasi skema aktif.
- CMP-002: batas aplikasi dan validasi konten di luar aplikasi.

Matriks FR dan keputusan kurikulum tersedia pada `../../audit-kurikulum-2026-10-29/audit-data.json` dan `../../audit-kurikulum-2026-10-29/keputusan-v3.md`.

Materi aktif masih MVP dua belas topik. Katalog elemen Matematika SD menjelaskan cakupan pengembangan; tidak menyatakan luas, volume, geometri, serta data/peluang sudah diimplementasikan.

Keputusan terbaru: profil cukup nama panggilan dan usia 6–12 tahun; tidak ada pilihan kelas sekolah. Diagram memakai teks dan garis hitam, latar putih, serta bentuk sederhana. Lihat ../../audit-kurikulum-2026-10-29/keputusan-usia-dan-gaya-uml.md.
