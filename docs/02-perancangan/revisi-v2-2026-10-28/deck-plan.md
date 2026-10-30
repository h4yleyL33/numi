# Presentasi progres Numi — 28 Oktober 2026

Audiens: dosen/asisten dan anggota tim. Durasi sekitar 8–10 menit. File native Figma Slides baru di KHALIT AFANA's team. Fokus: apa yang dikerjakan, arsitektur package, dan pekerjaan menuju validasi; tidak mengklaim hasil belajar atau implementasi cloud.

## Rencana slide

1. Sampul: judul Numi besar di kiri, lintasan pulau dan lingkaran kuning dominan di kanan, latar teal gelap.
2. Masalah: satu pernyataan besar di kiri, tiga bukti kemampuan berbeda di kanan, latar krem.
3. Solusi: enam simpul perjalanan berkelok dari profil ke progres memenuhi bidang, latar aqua.
4. Kurikulum: tiga tahap Fase A/B/C dengan penghubung kelas 3, bidang krem, pita teal di bawah.
5. Jenis soal: tiga contoh visual berdampingan yang menunjukkan fondasi, jembatan kelas 3, dan pecahan, latar putih.
6. Desain: empat contoh layar revisi mendominasi bidang tengah; judul ringkas dan label status rancangan, latar krem.
7. Progres: tiga bidang status dengan kontras kuat, bukti dokumentasi/desain/kode, latar teal gelap.
8. Package diagram: diagram UML editable memenuhi bidang bawah judul, latar putih; panah utama dan legenda jelas.
9. Penyimpanan: alur controller–kontrak–adapter lokal sebagai fokus kiri; Firebase sebagai rencana terpisah di kanan, latar aqua.
10. Selisih kode vs v2: empat baris perbandingan kondisi dan target, dua area dengan bobot berbeda, latar krem.
11. Langkah berikutnya: empat tonggak dari perbaikan kode menuju pilot, satu jalur dengan tanda gerbang, latar putih.
12. Penutup: satu keputusan berikutnya besar, daftar tim ringkas di bawah, lintasan pulau sebagai motif kanan, latar teal gelap.

## Sistem visual bersama

- Font judul Mali Bold; isi Nunito Regular/Bold; label kecil Nunito Bold.
- Palette: bgDark #174951, textPrimary #19373D, cream #FFF8E8, aqua #D9F0E9, accent #FFBD59, white #FFFFFF, textMuted #536970.
- Motif lintasan pulau: simpul lingkaran kuning dan garis melengkung/bersegmen teal, dipakai sebagai alur makna dan penanda bab.
- Hierarki: judul 64–88, isi 30–38, label 22–26; kanvas native 1920×1080.
- Package diagram menggunakan kotak bertab dan dependency putus-putus; elemen native editable.
- Layout berubah antara pernyataan besar, perjalanan, contoh soal, visual produk, diagram, dan roadmap. Tidak memakai template kotak seragam di semua slide.

## Preamble

Preamble JavaScript disimpan pada deck-preamble.js: palette C, pemuatan Mali/Nunito melalui Promise.all, append-first addFrame/addText/addRect, wrapper auto-layout untuk blok teks, pelacakan semua node ID, dan validasi batas/overlap.
