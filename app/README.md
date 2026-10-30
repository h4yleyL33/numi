# Aplikasi Numi

Kode Flutter untuk Numi. Struktur folder, pemetaan ke kebutuhan, dan cara menjalankan dijelaskan
di README utama proyek (`../README.md`). Rancangan kelas dan alurnya ada di
`../docs/02-perancangan/uml`.

Aturan belajar yang sering diubah tim (ambang mastery, jumlah soal, besaran XP) dikumpulkan
di `lib/core/config/app_config.dart`.

Baseline pengembangan terbaru, selisih kode terhadap seluruh PRD/PPL/doktek, dan backlog ada
di [`docs/03-implementasi`](../docs/03-implementasi/README.md) dan [`tasks`](../tasks/plan.md).
Init memakai kelas tunggal 1–6 dan konfirmasi kelas untuk data usia lama. Enam titik awal
diagnostic belum berarti enam paket konten tervalidasi tersedia. Data masih lokal satu profil;
autentikasi wali, beberapa profil, cloud, dan checkpoint per respons menunggu integrasi.
