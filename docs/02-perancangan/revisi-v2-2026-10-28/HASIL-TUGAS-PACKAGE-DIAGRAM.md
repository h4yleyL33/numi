# Hasil tugas package diagram dan presentasi progres

Snapshot: 28 Oktober 2026. Pembaruan dilakukan pada salinan revisi, bukan dokumen sumber awal.

## Hasil utama

- [Folder PDF di Drive](https://drive.google.com/drive/folders/1pbd_59ou47G9eaLtS7T8AgJXcZNOF940)
- [PDF tugas 11 halaman, format doktek revisi 2.3](https://drive.google.com/file/d/1acxr1XblJ_JeAVzAi__dY56DG-wdlvMV/view)
- [Google Slides native: presentasi 12 slide](https://docs.google.com/presentation/d/1Yaa0mBw-K7EqquZRBN3dTJ-qVaP32Wj03QZuHxYFyc0/edit)
- [Figma Slides native: presentasi 12 slide](https://www.figma.com/slides/ja1YJdxF0DI06sh10a1QG2)
- [PDF presentasi](https://drive.google.com/file/d/1M2zfEKbQ30UaLWzhfKnKBn7-UYt2U6Qz/view)
- [Dokumen kerja package diagram](https://docs.google.com/document/d/1O_u8ewo2j8QKe-Ztc6iiShJWYDWHBqhvEWU3HYHpRIo/edit)
- [Doktek v2.1](https://docs.google.com/document/d/1UzoljGfYWE1TbWRikJ7JCbGoUR9Kj-E2YZyS20PCd3Q/edit)
- [Proposal v2.1](https://docs.google.com/document/d/1gYgMYdlTagCbejr2_isrqjIyPHRJDp9brfq4G1fPVCU/edit)

## Perubahan dokumen

Doktek memuat PKG-002 pada bagian 2.3.1, kondisi arsitektur aktual, repository lokal, status fitur, hasil test baseline, dan kendali revisi 2.1. Proposal memuat penjelasan/diagram package pada bagian perancangan fungsional, stack aktual, serta kendali revisi 2.1. Gambar dan penjelasan terbaru mengikuti laporan PKG-002 revisi 2.3. Visi, cakupan, profil penyajian, dan batas implementasi diselaraskan pada kurikulum, charter, Gantt, UCDC, desain Figma, serta kedua versi presentasi. Rincian terbaru terdapat dalam HASIL-PENYELARASAN-VISI-DAN-PKG-2.3.md.

Nama tugas memakai enam digit terakhir kelima NPM: `247001_240003_240007_240009_240045_Package Diagram.pdf`. Pengumpulan belum dilakukan. Instruksi lampiran menyebut PM, H-1 praktikum berikutnya pukul 23.59; tanggal kalender belum tersedia.

## Dasar teknis dan verifikasi

- 51 berkas Dart pada app/lib, 5 berkas test; jumlah test dinamis diverifikasi melalui eksekusi, bukan dihitung dari deklarasi.
- Setelah cache dependensi dipulihkan dengan `flutter pub get`, `flutter test --no-pub --reporter expanded` selesai dengan **48 test lulus**. Lihat flutter-test.log.
- Matriks 21 relasi lintas package berasal dari pembacaan import lokal; bukti tersedia pada package-evidence.json dan snapshot hash pada code-snapshot-sha256.json.
- Kode aplikasi tidak direvisi pada pekerjaan dokumentasi ini. Test mengikuti baseline kode dan belum membuktikan kepatuhan semua kebijakan v2, pemulihan per respons, layanan cloud, uji perangkat menyeluruh, maupun efektivitas belajar.
- Semua halaman PDF tugas dan presentasi diperiksa melalui render PNG. Bagian baru pada ekspor doktek/proposal dan dokumen kerja diperiksa secara visual.
- Diagram pada slide arsitektur dibuat dari teks, package, dan path native yang dapat diedit. Slide desain menggunakan screenshot rancangan sebagai referensi visual. Catatan pembicara tersedia pada dua belas slide.

## Sumber yang dapat direvisi

- package_content.json: isi laporan. build_package_report.py adalah generator format landscape lama; laporan final format doktek disunting pada Google Docs dan diekspor menjadi PDF.
- diagram-spec.json: geometri diagram yang juga dipakai pada Figma.
- ../uml/src/pkg-002-paket-v2.puml: sumber PlantUML dengan seluruh dependensi teramati.
- deck-plan.md dan deck-preamble.js: rencana serta sistem visual presentasi.
- build_presentation_pdf.py: menyusun PDF dari render slide final.

Status verifikasi ini memperbarui catatan lama pada HASIL-REVISI.md yang ditulis sebelum kode dan test diperiksa.

## Penyuntingan bahasa dan versi Google Slides

Penjelasan package diagram telah disunting memakai skill Humanizer. Revisi 2.3 memakai A4 tegak dan Times New Roman seperti doktek, dengan sampul, identitas tim, daftar isi, diagram, matriks dependensi, dan bagian bernomor. PDF final berisi sebelas halaman. Klaim siklus antarkelompok paket pada draf lama diperbaiki karena tidak didukung hasil pemindaian import. Nama paket, fungsi, NPM, referensi, dan hasil pengujian tetap sama. Google Docs diperbarui pada file yang sama; PDF Drive juga diganti pada ID yang sama.

Presentasi progres kini tersedia sebagai Google Slides native. Pemeriksaan hasil konversi menemukan dua belas slide, 190 kotak teks yang dapat diedit, satu gambar referensi layar, serta catatan pembicara. Diagram arsitektur pada slide delapan berisi 37 kotak teks native. Semua halaman ekspor PDF Google Slides telah diperiksa secara visual. Sumber perantara PPTX disimpan untuk pemeliharaan dan tidak menjadi keluaran utama.
