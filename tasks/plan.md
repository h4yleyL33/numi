# Inisialisasi pengembangan Numi

Tanggal baseline: 30 Oktober 2026. Tahap: implementasi Waterfall, sebelum penulisan Bab IV pengujian.

## Acuan dan keputusan

1. `output/pdf/Numi_Dokumen_Teknis_Bab_I-III.pdf`: kebutuhan FR/NFR/DATA, arsitektur, dan batas implementasi.
2. `output/pdf/Numi_Proposal_PPL_Bab_I-III.pdf`: tujuan, kurikulum enam kelas, urutan Waterfall, dan cakupan proyek.
3. `prd/`: kebutuhan produk dan desain sebelumnya, berlaku sejauh konsisten dengan dua dokumen terbaru.
4. UML 29 Oktober adalah riwayat rancangan. Keputusan usia 6–12 dan dua kelompok digantikan profil kelas tunggal 1–6 dan kelompok fase A/B/C pada dokumen terbaru.

PDF dibaca dengan MinerU lokal, tier basic. Locator: `doc:9bbebcf/tier:basic` (doktek) dan `doc:20e1f4c/tier:basic` (PPL). Tidak ada unggahan dokumen untuk parsing.

## Strategi

Gunakan Flutter/Riverpod dan repository yang sudah ada. Jangan membuat aplikasi baru atau mengganti stack. Setiap irisan mencakup model, pengendali, layar, dan pemeriksaan yang relevan. Pengujian teknis berjalan selama implementasi; hasil Bab IV baru ditulis berdasarkan bukti pengujian yang benar-benar tersedia.

Urutan dependensi: baseline kebutuhan → integritas simpan dan profil kelas → akun wali dan pemisahan profil → paket kelas/butir berversi → bukti dan akses → checkpoint per respons → rekomendasi/lesson/mastery → progres wali → verifikasi Android dan pilot → rilis.

## Lingkup init ini

- Inventaris seluruh kebutuhan dan backlog dengan kriteria terima.
- Perbaiki penyimpanan agar state aplikasi baru berubah setelah repository berhasil.
- Ganti form usia menjadi enam pilihan kelas, validasi pada controller, turunkan kelompok fase dari kelas, dan pertahankan riwayat profil lama tanpa menebak kelas dari usia.
- Mulai diagnostic dari kelas yang dipilih, bukan usia; jangan mengganti kelas atau kelompok fase berdasarkan skor.
- Cegah pembahasan mastery selama blok, pertahankan pembahasan langsung untuk lesson.
- Jalankan unit/widget test, analyzer, serta build yang tersedia; catat batasnya.

## Batas dan risiko

Firebase tim, penyedia Google, application ID, serta sidik sertifikat harus disiapkan sebelum login nyata. Init lokal bukan autentikasi palsu dan tidak mengklaim pemisahan akun sudah aman. Penyimpanan shared_preferences belum memenuhi jaminan transaksi checkpoint; implementasi per respons harus memakai adapter dengan kontrak durabilitas yang diuji. Butir generator yang ada adalah konten pengembangan, belum konten tervalidasi guru.

Enam titik awal kelas pada init adalah konfigurasi sementara berdasarkan fokus materi PPL 2.6.2. Paket pengantar, variasi soal per kelas, bukti per skill, dan retensi tetap pekerjaan tersendiri. Target usability, performa, dan efektivitas belum dinyatakan tercapai.

## Verifikasi dan serah lanjut

Gunakan `flutter test`, `flutter analyze`, dan `flutter build web` dari `app/` untuk pemeriksaan lokal awal. Web hanya media pemeriksaan pengembangan; target rilis tetap Android. APK, proses dimatikan, login, aturan akses cloud, perangkat RAM 2/4 GB, dan uji anak memerlukan bukti tersendiri. Status pekerjaan dan penerimaan tiap irisan ada di `tasks/todo.md`; pemetaan kebutuhan ada di `docs/03-implementasi/README.md`.

## Irisan lanjutan I04/I05

Pengguna meminta melanjutkan pengembangan dan mengonfirmasi proyek Firebase tim belum dibuat. Implementasikan kontrak/adapter Google-Firebase, bootstrap yang menahan akses sebelum login, alur akun, dan penyimpanan beberapa profil lokal per UID. Pertahankan data tanpa UID; jangan impor otomatis atau membuat akun palsu dalam aplikasi. Gunakan fake SDK hanya untuk test. Konfigurasi tim, login nyata, APK, migrasi dengan konfirmasi, dan Firestore tetap kriteria terbuka. Hasil serta instruksi aktivasi ada di `docs/03-implementasi/AKUN-PROFIL.md` dan `firebase/README.md`.
