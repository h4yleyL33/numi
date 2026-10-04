# Doktek Bab 2 (versi 1.2)

Bab 2 doktek yang disusun ulang dari isi folder ini: arsitektur dari kode `app/lib`, UI/UX dari
`design/` dan `kurikulum/`, 23 diagram dari `uml/`, ERD dan kamus data dari ERD-001, serta
traceability yang sudah menunjuk ke folder kode.

| Berkas | Isi |
|---|---|
| `bab2.md` | Sumber teks Bab 2. Ubah di sini kalau ada revisi. |
| `Bab-2-Perancangan-Numi.docx` | Hasil ekspor dengan 23 gambar diagram dan 16 tabel, siap ditempel ke Google Docs |
| `buat_docx.mjs` | Pengubah `bab2.md` ke `.docx` |

Membuat ulang `.docx` setelah `bab2.md` atau diagram diubah:

```bash
cd docs/02-perancangan/doktek-bab2
npm install
npm run build
```

## Mengganti Bab 2 di Google Docs

1. Unggah `Bab-2-Perancangan-Numi.docx` ke Google Drive, buka dengan Google Docs.
2. Tekan Ctrl+A, Ctrl+C.
3. Di doktek, blok dari judul "2. DESIGN / PERANCANGAN" sampai tepat sebelum
   "3. IMPLEMENTATION / IMPLEMENTASI", lalu tekan Ctrl+V.
4. Perbarui daftar isi (klik daftar isi, lalu ikon segarkan).
5. Tambahkan baris di Catatan Sejarah Perbaikan: versi 1.2, tanggal hari ini, "Bab 2 disusun
   ulang sesuai UML, ERD, dan kode di repositori".

Gaya judul di `.docx` memakai Heading 1-3 bawaan, jadi setelah ditempel akan mengikuti gaya
judul doktek dan masuk ke daftar isi.
