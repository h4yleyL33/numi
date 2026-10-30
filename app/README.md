# Aplikasi Numi

Kode Flutter untuk Numi. Struktur folder, pemetaan ke kebutuhan, dan cara menjalankan dijelaskan
di README utama proyek (`../README.md`). Rancangan kelas dan alurnya ada di
`../docs/02-perancangan/uml`.

Aturan belajar yang sering diubah tim (ambang mastery, jumlah soal, besaran XP) dikumpulkan
di `lib/core/config/app_config.dart`.

Baseline pengembangan terbaru, selisih kode terhadap seluruh PRD/PPL/doktek, dan backlog ada
di [`docs/03-implementasi`](../docs/03-implementasi/README.md) dan [`tasks`](../tasks/plan.md).
Init memakai kelas tunggal 1–6 dan konfirmasi kelas untuk data usia lama. Paket pengantar kini
memiliki dua butir awal berversi per kelas, masih draft dan belum enam paket konten lengkap.
Diagnostic hanya menghasilkan indikasi jangkar; BuktiSkill terpisah dari AksesMateri dan XP.
Riwayat lama tetap ada dan dapat memerlukan pemetaan ulang. Adapter Google/Firebase serta
alur beberapa profil lokal per UID tersedia; konfigurasi proyek tim, login nyata, cloud, dan
verifikasi Android masih terbuka. Diagnostic, lesson dan mastery sudah memakai snapshot soal,
checkpoint per respons, resume, dan finalisasi aktivitas/reward sekali per sesi dalam database
lokal. Lesson juga memulihkan pembahasan sebelum Lanjut. Cakupan dan batasnya ada di
[`CHECKPOINT-ALUR.md`](../docs/03-implementasi/CHECKPOINT-ALUR.md).

Tanpa proyek Firebase, jalankan demo pengembangan dengan `flutter run -d chrome
--dart-define=NUMI_LOCAL_DEMO=true` (satu baris). Flag demo hanya berlaku pada build non-release.
Bootstrap bawaan menahan akses jika Firebase belum dikonfigurasi. Panduan setup lengkap ada
di [`firebase/README.md`](../firebase/README.md).
