# Backlog implementasi Numi

Status: `[x]` terimplementasi dan diperiksa pada init; `[ ]` belum memenuhi seluruh kriteria. Rincian hasil pemeriksaan ada di `docs/03-implementasi/VERIFIKASI.md`.

## I00 — Baseline seluruh PRD dan dokumen

- [x] Bekukan acuan terbaru, inventaris FR-001–017, NFR-001–006, DATA-001–009, dan catat konflik PRD lama.
- Penerimaan: tiap kebutuhan memiliki lokasi kode awal, selisih, dan irisan tujuan; kode lama tidak dinyatakan sudah sesuai target.
- Verifikasi: pemeriksaan tautan dan matriks pada `docs/03-implementasi/README.md`.
- Dependensi: tidak ada. Lingkup: dokumentasi.

## I01 — Simpan terkonfirmasi

- [x] State baru diterbitkan setelah simpan berhasil; hasil gagal tidak berubah menjadi keberhasilan.
- Penerimaan: kegagalan dan operasi tertunda diuji; retry tidak merusak data sebelumnya; adapter menolak hasil tulis `false`.
- Verifikasi: test controller dan repository lokal; analyzer.
- Dependensi: I00. Berkas: controller, local repository, test.

## I02 — Profil kelas 1–6

- [x] Form menerima satu kelas, kelompok fase A/B/C diturunkan dari kelas, diagnostic memakai titik awal kelas.
- [x] Data usia lama meminta konfirmasi kelas tanpa menghapus ID, hasil, lesson, atau XP.
- Penerimaan: kelas di luar rentang/nama kosong ditolak; mengubah kelas mempertahankan riwayat; skor tidak mengubah kelas.
- Verifikasi: test model/migrasi, controller, diagnostic, onboarding, responsif.
- Dependensi: I01. Berkas: siswa, paket kelas, controller, onboarding/splash, diagnostic, test.

## I03 — Asesmen tanpa bocoran kunci

- [x] Diagnostic dan mastery menunda umpan balik; lesson tetap langsung; tombol kirim muncul sesudah pilihan.
- [ ] Pembahasan seluruh blok ditampilkan setelah blok tersimpan, dengan hasil yang sesuai butir pertama.
- Penerimaan: tes widget memastikan kunci/banner/XP tidak muncul saat blok tes; klik ganda tidak menambah respons.
- Verifikasi: test widget pemutar soal dan integrasi layar hasil.
- Dependensi: I01; penyelesaian pembahasan bergantung I07.

## I04 — Akun Google wali

- [ ] Pasang konfigurasi Firebase tim dan adapter autentikasi; tampilkan login, batal, gagal/retry, dan logout.
- Penerimaan: data pribadi baru dimuat setelah UID sah; tidak ada token pada data siswa; logout mengosongkan state pribadi.
- Verifikasi: unit adapter, integrasi login Android, batal/offline/logout; build APK debug.
- Dependensi: I00, konfigurasi Firebase. Berkas: bootstrap, auth repository/controller, layar akun.

## I05 — Beberapa profil dan isolasi akun

- [ ] Daftar/pilih/tambah/ubah profil dalam UID wali; migrasi lokal dimiliki akun setelah konfirmasi wali.
- Penerimaan: pergantian profil menghentikan sesi sebelumnya; data profil dan cache tidak bocor antarwali; kelas berubah tanpa reset.
- Verifikasi: pengujian dua wali dan dua profil; emulator aturan Firestore menolak tanpa login dan UID lain.
- Dependensi: I02, I04. Berkas: account/profile state, repository, profile screens, Firestore rules/test.

## I06 — Paket kelas dan konten berversi

- [ ] Enam paket pengantar dengan tujuan, skill, bentuk bantuan, prasyarat, versi, dan butir yang berbeda.
- Penerimaan: kelas 1/2, 3/4, 5/6 memiliki perbedaan nyata; butir terbit memiliki catatan persetujuan validator; katalog menandai materi belum tersedia.
- Verifikasi: validasi katalog/generator dan pemeriksaan guru; tidak menyimpulkan dukungan seluruh matematika SD.
- Dependensi: I02. Berkas: content, models, katalog, alat validasi konten.

## I07 — Bukti skill terpisah dari akses

- [ ] Catat belum diuji, indikasi perlu latihan, indikasi siap lanjut, dan bukti penguasaan awal beserta sumber/waktu/jumlah/bantuan/kebijakan.
- Penerimaan: topik tak diuji tidak dianggap dikuasai; akses terkunci bukan bukti lemah; diagnostic dua soal bukan mastery.
- Verifikasi: test domain, migrasi data lama, skill map dan hasil diagnostic.
- Dependensi: I06. Berkas: evidence/access models, diagnostic/skill map/rekomendasi, layar hasil/peta.

## I08 — Checkpoint per respons

- [ ] Simpan respons pertama dan posisi atomik sebelum lanjut; gagal menahan soal dan menawarkan retry; resume memakai butir/versi/urutan sama.
- Penerimaan: command ID tetap dan deduplikasi; jawaban berbeda tidak menimpa pertama; finalisasi ulang tidak menggandakan XP; status lokal/pending/synced/konflik dibedakan.
- Verifikasi: repository failure/retry/restart, proses Android dihentikan, konflik dua perangkat, emulator cloud.
- Dependensi: I05–I07. Berkas: session/response models, adapter durabel lokal, cloud repository, quiz/controller/bootstrap.

## I09 — Jalur belajar dan lesson

- [ ] Satu MAIN menentukan lesson/mastery; dukungan visual/suara tersedia sesuai kebutuhan pada seluruh kelas; seret memiliki alternatif ketuk.
- Penerimaan: rekomendasi menjelaskan bukti/prasyarat; lesson memberi pembahasan; satu tindakan utama dan hasil Lanjut; hapus data di ruang wali.
- Verifikasi: domain learning path, widget alur, aksesibilitas dan observasi perangkat.
- Dependensi: I06–I08. Berkas: home/peta/topik/lesson/quiz, bantuan, learning path.

## I10 — Mastery, reward, dan pemeriksaan ulang

- [ ] Lima butir baru, nilai respons pertama, pilot 5/5; pembahasan sesudah blok; paket ulang sepadan dan jadwal 3–7 hari.
- Penerimaan: reward hanya sekali setelah commit; XP terpisah dari bukti; hasil menjelaskan keterampilan/versi/keterbatasan, bukan penguasaan seluruh fase.
- Verifikasi: unit batas skor/retensi, integrasi finalisasi ganda dan gagal simpan.
- Dependensi: I07–I09. Berkas: mastery, progress service, session finalization, hasil sesi.

## I11 — Progres anak dan wali

- [ ] Pisahkan aktivitas dari kemampuan; tampilkan waktu ukur, jumlah butir, bantuan, retensi, dan materi belum diuji.
- Penerimaan: wali membuka pengaturan/rincian melalui gerbang; pesan maskot tidak menutupi tugas; status memakai teks/ikon.
- Verifikasi: widget akses wali, domain streak/lencana/pesan, pemeriksaan aksesibilitas.
- Dependensi: I05, I07–I10.

## I12 — Pemeriksaan akhir implementasi sebelum Bab IV

- [ ] Analyzer/test/build lulus; login/profile/checkpoint/cloud diverifikasi; konten disetujui validator.
- [ ] Uji Android API 26+, RAM 2/4 GB, 360–412 dp, landscape, teks besar, kegagalan jaringan/simpan dan proses mati.
- [ ] Susun rencana pilot enam kelas, ukur target NFR dengan peserta/perangkat/materi/bantuan yang dicatat, baru tulis hasil Bab IV.
- Dependensi: I03–I11. Target pilot dan tanggal Gantt bukan klaim pekerjaan telah selesai.
