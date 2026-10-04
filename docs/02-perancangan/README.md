# Minggu 2-3: Perancangan Sistem

14 sampai 27 September 2026.

| WBS | Dokumen | PIC | Letak |
|---|---|---|---|
| 2.1 | Jadwal dan Gantt chart | Yarfi | `imun Gantt Chart.xlsx` |
| 2.2 | Doktek Bab 2 (UML, ERD) | Andri | `uml/` (23 diagram termasuk ERD-001), naskah lengkap di `doktek-bab2/` |
| 2.3 | Proposal PPL Bab 2 | Khalit | Google Docs |
| 2.4 | Wireframe dan mockup UI/UX | Alfrandiano | Figma dan `../../design/` |

Pendukung perancangan:

- `kurikulum/`: pemetaan Capaian Pembelajaran BSKAP 046/H/KR/2025 ke 12 topik, dasar
  pembagian kelas kecil dan kelas besar, serta bentuk soal.
- Figma https://www.figma.com/design/yNC8dWGVTz3wedUvSwIAMW/numi berisi halaman `asset`
  (warna, tipografi, maskot, pulau, komponen, lencana), `ui` (20 layar), dan `user flow`
  (use case diagram dan alur pengguna).

## Gantt chart

Memakai template Vertex42 dari asisten. Fase 3 sampai 6 dipecah sampai level 3
(misalnya 3.2.3), dan tiap subtugas mencantumkan kode kebutuhan dari SRS (FR, NFR, DATA)
supaya bisa dilacak ke RTM di Bab 5.

Yang diisi tangan hanya kolom Days dan % Done di sel hijau. Start subtugas mengikuti akhir
subtugas sebelumnya (`=E..+1`), End dihitung dari `=D+F-1`, dan baris induk mengambil
`MIN`/`MAX` anak-anaknya. % Done baris induk adalah rata-rata anak yang dibobot jumlah hari.
Kalau satu subtugas mundur, semua subtugas sesudahnya ikut bergeser.

Tampilan timeline hanya 8 minggu. Ganti angka Display Week di H4 (1, 5, atau 9) untuk
melihat minggu berikutnya.

Versi di Google Drive sudah diganti dengan berkas ini lewat Kelola versi, jadi tautannya tetap.
