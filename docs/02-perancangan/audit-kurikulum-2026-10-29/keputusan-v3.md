# Keputusan audit kurikulum UI UX dan UML Numi

Tanggal pemeriksaan: 29 Oktober 2026. Dokumen ini menetapkan rancangan target v3; kode aplikasi belum diubah.

## Hasil pemeriksaan

UI, user flow, dan UML belum sepenuhnya selaras dengan kurikulum v2. Alur dasar profil, diagnostic, peta, lesson, mastery, dan progres sudah tersedia pada desain. Masalah utamanya berada pada pemaknaan hasil, cakupan materi, serta model data dan penyimpanan.

Pilihan yang ditemukan pada profil adalah usia 6–12 tahun, bukan kelas sekolah 1–6. Model Siswa hanya menyimpan usia dan kelompokBelajar. Hasil diagnostic masih memberi label Kelas Kecil untuk keseluruhan kemampuan. Prototype Hi-Fi mengarahkan jawaban mastery ke layar feedback benar atau salah pada setiap butir; layar salah membuka jawaban benar sebelum blok tes selesai. Laporan wali mencampur status akses Terkunci dengan status kemampuan. Bukti diperiksa pada Figma sumber y0iET9hEQwy0xMFtV95Pek melalui konektor native, bukan browser.

## Batas kurikulum

Acuan: CP BSKAP 046/H/KR/2025, halaman PDF 111–116; dibaca lokal dengan MinerU, doc:45809d2/tier:flash/page:111 sampai page:116. Keputusan perubahan 020/2026 hanya menyentuh Pendidikan Agama dan Budi Pekerti; Matematika tetap mengacu pada ketentuan sebelumnya.

Lima elemen Matematika SD adalah Bilangan, Aljabar, Pengukuran, Geometri, serta Analisis Data dan Peluang. Dua belas topik Numi mencakup bagian bilangan dan beberapa kalimat matematika; cakupan ini belum mencakup seluruh Matematika SD.

Luas dan volume diperkenalkan pada Fase B melalui pengukuran dan estimasi dengan satuan. Pada Fase C, pengukuran memuat keliling dan luas bangun datar beserta gabungannya, durasi, dan sudut; geometri memuat konstruksi serta penguraian kubus/balok, pandangan ruang, dan peta berpetak. Karena CP ditetapkan pada akhir fase, rincian urutan kelas 5 atau 6 harus dicocokkan dengan ATP sekolah. Rumus volume semua bangun ruang dan luas permukaan tidak boleh otomatis diklaim sebagai kewajiban Fase C 2025.

## Keputusan rancangan

1. Profil cukup menyimpan nama panggilan dan usia 6–12 tahun. Pilihan kelas sekolah dan opsi Belum tahu dibatalkan sesuai keputusan pengguna. Usia membantu titik awal; perubahan usia tidak mereset bukti belajar.
2. Bahasa dan kepadatan penyajian mengikuti kebutuhan anak usia 6–12 tahun. Gambar, simbol, cerita, dan bantuan tersedia lintas kelas. Hapus label kemampuan global Kelas Kecil/Kelas Besar dari hasil diagnostic.
3. Pertahankan MVP 12 topik sebagai penguatan numerasi. Katalog menampilkan lima elemen dan status ketersediaan. Materi pengukuran, geometri, data/peluang, serta perluasan bilangan ditulis sebagai rencana sampai konten, asesmen, dan validasi tersedia. Ini belum persetujuan perluasan implementasi seluruh Matematika SD.
4. Pisahkan BuktiSkill dari AksesMateri. Bukti yang belum ada diberi Belum diuji, tidak otomatis Belum dikuasai atau Dikuasai. Diagnostic singkat tidak menyatakan penguasaan seluruh fase.
5. Lesson dapat memberi feedback langsung. Diagnostic dan mastery tidak membuka jawaban selama blok tes. Mastery 5/5 adalah bukti awal pada skill dan versi butir tertentu, dengan kebijakan pilot yang belum tervalidasi.
6. Simpan respons pertama dan checkpoint secara atomik, termasuk urutan butir, versi, posisi, bantuan, dan waktu. Tampilkan gagal simpan serta coba lagi; jangan mengaku tersimpan sebelum repository berhasil. Resume tetap memakai butir yang sama.
7. Siswa dan wali adalah aktor aplikasi. Guru merupakan validator materi di luar aplikasi selama belum ada portal guru. Admin konten, Firebase, maskot, dan scheduler internal bukan aktor pengguna pada batas sistem MVP ini. Integrasi eksternal baru dimodelkan setelah fiturnya ditetapkan.
8. Kode dan UML as-is dipisahkan dari target. Diagram target v3 tidak menjadi bukti bahwa validasi usia, checkpoint, katalog baru, atau aturan asesmen sudah diimplementasikan.

## Bukti layar

1. 05 Profil — nama/usia 6–12 tahun, sesuai batas pengguna.
2. 08 Hasil diagnostic — label global Kelas Kecil, status belum diuji belum terlihat.
3. 09 Peta — pulau numerasi dan progres 12 pulau; cakupan elemen lain belum terlihat.
4. 12–15 Lesson — latihan dan feedback mendukung belajar; perlu dukungan lintas kelas dan pemisahan penyelesaian lesson dari penguasaan.
5. 16–18 Mastery — hasil 5/5 dan 4/5 ada; prototype Hi-Fi masih membuka jawaban benar setelah tiap butir.
6. Keluar dan kembali — prototype mengarah kembali ke peta; model checkpoint per respons belum ditemukan pada kode.
7. 19–20 Progres wali — statistik aktivitas tersedia; belum memisahkan bukti bertanggal, jumlah butir, retensi, dan akses materi.

Pemeriksaan ini memakai screenshot dan konfigurasi reaksi prototype. Tidak dilakukan uji interaksi bersama anak, pembaca layar, suara, atau persistensi nyata pada perangkat. Target kecil, keterbacaan teks di atas latar bertekstur, fokus, dan gesture memerlukan pengujian lanjutan.
