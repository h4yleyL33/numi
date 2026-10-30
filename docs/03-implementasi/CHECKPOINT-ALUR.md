# Checkpoint diagnostic dan lesson — lanjutan I08

Tanggal: 30 Oktober 2026. Melanjutkan checkpoint mastery tanpa mengubah urutan implementasi sebelum Bab IV.

## Diagnostic adaptif

Sesi menyimpan kelas pada waktu mulai, identitas sesi, versi kebijakan, seluruh blok soal beserta respons pertama, dan tanda finalisasi. Setiap blok memiliki ID tetap dan dua snapshot soal. Setelah respons terakhir satu blok benar-benar disimpan, blok berikutnya sudah berada dalam pembaruan profil yang sama. Kegagalan tulis tidak memajukan rute atau menampilkan butir baru.

Saat pemulihan, mesin mengulang keputusan naik/turun dari respons pada blok tersimpan. Replay tidak membangkitkan ulang soal aktif. Blok dengan urutan topik salah, blok tambahan setelah titik berhenti, butir duplikat, atau blok berikutnya yang hilang ditolak. Kelas profil yang kemudian diubah tidak mengubah kelas awal sesi yang sedang berlangsung. Aturan tetap pilot linear: maksimal enam topik/dua belas soal, dua respons per topik; belum graf subketerampilan lengkap.

Layar awal menawarkan Lanjutkan pemetaan untuk sesi tertunda. Respons dan posisi dipulihkan, termasuk di tengah blok. Kunci/pembahasan tetap disembunyikan selama diagnostic. Finalisasi mengambil hasil dari checkpoint lengkap dan menyimpan indikasi, akses, riwayat, streak, serta tanda ditutup bersama-sama. ID sumber BuktiSkill menunjuk sesi persisten. Pemanggilan ulang tidak menambah riwayat/aktivitas. Diagnostic tidak memberikan XP atau bukti penguasaan penuh.

## Lesson dan pembahasan

Lesson memakai model SesiSoal yang juga menjadi dasar checkpoint mastery; nama SesiMastery tetap tersedia untuk kompatibilitas. Snapshot menyimpan lima soal, ID lesson, waktu mulai, respons, tanda menunggu Lanjut, dan ringkasan hasil sesudah finalisasi. Akses dan urutan lesson diperiksa ketika memulai sesi baru. Sesi tertunda dapat dibuka kembali melalui rekomendasi atau kartu topik.

Respons disimpan sebelum pembahasan muncul. Sesudahnya, lesson menunggu tindakan Lanjut yang juga disimpan sebelum berpindah soal. Jika aplikasi tertutup di antara dua tindakan itu, pembahasan respons terakhir muncul kembali, termasuk setelah soal kelima. Kegagalan simpan Lanjut tetap menahan pembahasan dan menyediakan retry; jawaban pertama tidak berubah. Perintah respons dan Lanjut mempunyai identitas tetap dan pengiriman ulang tidak menambah respons.

Hasil baru ditampilkan setelah penyimpanan akhir berhasil. Progres lesson, jumlah percobaan, XP, streak, lencana, pesan, riwayat, ringkasan hasil, dan tanda selesai disimpan bersama. Finalisasi ulang mengembalikan hasil tersimpan. Simpan yang sudah commit tetapi kehilangan konfirmasi dipulihkan melalui pembukaan ulang profil; XP tidak diterbitkan dua kali. Membuka kembali lesson selesai menampilkan hasilnya; Latihan lagi/Coba lagi memulai sesi baru secara eksplisit.

Lesson/XP tidak mengubah BuktiSkill. Durasi untuk lencana Cepat dihitung konservatif dari waktu mulai tersimpan sampai respons terakhir, termasuk jeda selama aplikasi tertutup; durasi negatif akibat perubahan jam tidak memenuhi syarat lencana Cepat. Ini bukan pengukuran waktu aktif atau pencapaian target performa NFR. Posisi halaman pengantar sebelum soal belum disimpan.

## Data dan kompatibilitas

DataBelajar menjadi JSON versi 5 dengan sesiLesson dan sesiDiagnostic. Checkpoint mastery versi 4 tanpa field konteks tetap dibaca sebagai mastery. Profil, UID, riwayat, bukti, akses, dan XP lama dipertahankan. Aturan simpan terkonfirmasi, transaksi file/IndexedDB, penolakan snapshot lama, dan isolasi akun/profil dari irisan sebelumnya tetap berlaku. Tidak ada migrasi otomatis data tanpa UID ke akun wali.

Penyelesaian diagnostic dan lesson lewat API lama tanpa checkpoint sudah dihapus. Semua layar mengambil hasil dari sesi persisten, bukan daftar respons bebas dari widget. Model menolak respons yang konteks, versi, skill, urutan, atau nilai benarnya tidak sesuai snapshot. Status penyimpanan masih lokal; tidak ada klaim konfirmasi cloud.

## Bukti pemeriksaan dan batas

Pengujian domain mencakup keenam kelas pada jalur benar/salah, roundtrip tiap respons, batas blok, duplikasi command, urutan palsu, posisi pembahasan, dan kompatibilitas versi 4. Pengujian controller mencakup gagal/retry/restart, kelas diubah saat sesi berjalan, finalisasi ganda, dan konfirmasi terputus setelah commit. Widget 390 dp memeriksa retry hasil diagnostic, pemulihan pembahasan lesson, gagal Lanjut, dan retry hasil lesson. File repository memulihkan diagnostic/lesson pada profil yang tepat tanpa mengisi profil saudara.

Probe `dart run tool/verifikasi_checkpoint_proses.dart` pada host Windows kini menghentikan tiga proses penulis tanpa close sesudah commit. Snapshot diagnostic beserta blok adaptif berikutnya, pembahasan lesson, dan respons pertama mastery berhasil dipulihkan identik. Probe tidak mematikan proses Android dan tidak mensimulasikan mati listrik di tengah commit.

Browser nyata memakai fixture sintetis `.cache/checkpoint_alur_browser.dart` pada origin 127.0.0.1:8767, terpisah dari entrypoint release. Lesson dimulai dari pembahasan respons pertama, dijawab sampai respons kedua, lalu reload sebelum Lanjut memulihkan pembahasan kedua. Setelah lesson selesai 4/5, reload mempertahankan 60 XP dan lima respons akhir. Diagnostic kemudian pulih dari respons kedua, menyimpan hasil 0/2, dan reload mempertahankan total tujuh respons serta 60 XP. Membuka hasil lesson lagi menampilkan ringkasan tersimpan. Log warning/error browser kosong. Server dan tab ditutup sesudah pemeriksaan.

I08 masih parsial: sinkronisasi Firestore, pending/synced/konflik antarperangkat, emulator aturan, login nyata, pengujian proses Android dihentikan, serta pengukuran RAM/latensi perangkat masih terbuka. Riwayat sesi lesson/mastery menyimpan satu sesi terbaru per target; arsip aktivitas lama tetap ada. Validasi konten guru, pembahasan akhir blok diagnostic/mastery, soal baru lintas sesi, dan retensi 3–7 hari tetap tugas berikutnya. Hasil teknis ini belum laporan pengujian akhir Bab IV.
