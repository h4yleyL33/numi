# Checkpoint lokal mastery — I08 parsial

Tanggal: 30 Oktober 2026. Irisan implementasi sebelum pengujian akhir Bab IV.

Pembaruan berikutnya pada tanggal yang sama sudah menghubungkan checkpoint diagnostic dan lesson. [CHECKPOINT-ALUR.md](CHECKPOINT-ALUR.md) menggantikan keterangan dua alur yang belum terhubung di bagian batas historis dokumen ini; cloud dan verifikasi Android tetap terbuka.

## Perilaku yang tersedia

Mastery dimulai dengan menyimpan snapshot lima soal sebelum soal pertama ditampilkan. Snapshot mencakup ID, versi, jenis soal, teks, gambar numerik, pasangan, urutan pilihan, kunci, dan pembahasan. Resume memakai snapshot tersimpan; generator tidak menentukan ulang butir sesi tersebut.

Setiap kiriman memiliki command ID tetap `<sesi>/respons/<indeks>`. Respons pertama dan posisi berikutnya disimpan dalam satu snapshot profil. Cursor diturunkan dari jumlah respons, sehingga tidak ada cursor terpisah yang dapat maju tanpa respons. Kiriman ulang dengan isi/bantuan sama menjadi operasi tanpa perubahan; jawaban berbeda, konteks/versi palsu, atau urutan yang melompati checkpoint ditolak. Nilai benar diperiksa terhadap kunci snapshot.

Pemutar soal menunggu simpan sebelum maju. Selama menunggu atau gagal, pilihan pertama ditahan. Kegagalan menampilkan Coba simpan lagi dan mengirim objek respons yang sama, termasuk waktu jawab. Tidak ada pembahasan atau indikator benar/salah selama blok mastery. Jika galat menetap atau ada konflik sesi, UI mengarahkan wali membuka ulang profil untuk memuat snapshot terbaru.

Sesi belum selesai diprioritaskan pada rekomendasi. Kartu topik menyediakan Lanjutkan test beserta jumlah jawaban tersimpan. Lima respons yang sudah lengkap tetapi belum difinalisasi dapat difinalisasi setelah membuka kembali sesi. Hasil tersimpan dapat dibuka kembali; memulai test baru adalah tindakan terpisah.

Finalisasi mengambil respons dari checkpoint, bukan daftar jawaban dari widget. Bukti, hasil mastery, riwayat, XP, streak, lencana, pesan, dan tanda sesi selesai beserta ringkasan hasil disimpan dalam satu pembaruan profil. Dua finalisasi bersamaan diantrekan. Finalisasi sesi yang sudah selesai mengembalikan ringkasan tersimpan tanpa menambah XP/riwayat lagi, termasuk sesudah restart. ID sesi yang telah diganti test baru ditolak. Identitas sumber BuktiSkill memakai ID sesi tersebut.

## Penyimpanan dan migrasi

Bootstrap memakai Sembast untuk file lokal pada platform native dan Sembast Web/IndexedDB pada browser. Database wali dibuka secara malas sesudah UID aktif meminta data, dengan nama berbeda per UID. Record tetap memvalidasi UID dan profil. Demo pengembangan memakai database/record terpisah dari akun wali. Adapter tanpa database tetap tersedia untuk kompatibilitas test SharedPreferences; bootstrap aplikasi selalu memasang database.

Operasi perubahan profil berjalan di transaksi database. Snapshot lama dari sesi lain ditolak sebelum menimpa data terbaru. Seluruh mutasi controller yang menyimpan data diantrekan agar pesan maskot, profil, dan checkpoint tidak saling menghapus. Tidak ada sinkronisasi server atau klaim synced. Status sesi saat ini hanya lokal; label aplikasi menyatakan tersimpan di perangkat ini.

DataBelajar menjadi JSON versi 4. Cache SharedPreferences ber-UID dibaca sebagai sumber migrasi bila record database belum ada, kemudian disalin bersama pembaruan pertama yang berhasil. Salinan lama dipertahankan. Cache rusak menolak operasi; data tanpa UID tidak otomatis dimasukkan ke akun. Reset demo menulis record kosong agar data lama tidak muncul kembali melalui fallback. Reset progres profil mempertahankan identitas dan profil saudara.

Sembast dipilih karena model JSON yang sudah ada dapat disimpan dengan API transaksi yang sama pada file dan IndexedDB. Acuan: [API transaksi Sembast](https://pub.dev/documentation/sembast/latest/sembast/Database/transaction.html) dan [Sembast Web](https://pub.dev/packages/sembast_web). Transaksi web dapat dijalankan ulang oleh pustaka; callback perubahan tidak menerbitkan state UI atau melakukan panggilan eksternal. Data lokal belum dienkripsi; pemisahan aplikasi tidak dimaksudkan sebagai perlindungan dari perangkat yang sudah dikuasai pihak lain.

## Verifikasi dan batas

Tes memeriksa serialisasi seluruh jenis soal, ID/versi/konteks, respons duplikat/berbeda/di luar urutan, simpan tertunda/gagal/retry, restart, finalisasi ganda, bantuan, dan XP hanya setelah simpan. Tes file memeriksa migrasi ber-UID, buka ulang database, konflik snapshot, profil saudara, reset demo, dan cache rusak. Widget 390 dp memeriksa gagal simpan menahan soal dan resume dari soal ketiga sampai hasil.

Probe `app/tool/verifikasi_checkpoint_proses.dart`, dijalankan dari `app/` dengan `dart run tool/verifikasi_checkpoint_proses.dart`, menghentikan proses penulis file tanpa memanggil close setelah commit. Pada host Windows, satu respons pertama yang salah, cursor, lima soal, urutan pilihan, versi, dan command ID berhasil dimuat oleh proses baru. Probe ini bukan uji Android atau uji mati listrik di tengah commit.

Browser nyata memakai fixture lokal terpisah di `.cache/checkpoint_browser.dart`, bukan entrypoint release. Di origin pengujian 127.0.0.1:8766, sesi dimulai dengan dua respons tersimpan, dilanjutkan ke soal ketiga, direload setelah kiriman ketiga, lalu kembali ke soal keempat. Setelah hasil 5/5 disimpan, reload menampilkan ringkasan hasil yang sama. Log warning/error browser kosong. Fixture hanya menggunakan data sintetis; server dan tab ditutup sesudah pemeriksaan. Build akhir dikembalikan ke entrypoint `lib/main.dart`.

I08 belum selesai seluruhnya. Checkpoint diagnostic adaptif dan lesson belum dihubungkan; keduanya masih menyimpan hasil pada akhir blok/aktivitas. Kegagalan simpan akhir pada dua alur itu masih memerlukan penyelesaian. Riwayat sesi mastery di map menyimpan satu sesi terbaru per topik, sementara hasil aktivitas lama tetap ada. Riwayat sesi lengkap, kebaruan soal lintas sesi, pembahasan akhir, dan pemeriksaan ulang terjadwal belum selesai.

Sinkronisasi cloud, status pending/synced/konflik antarperangkat, aturan Firestore/emulator, login nyata, proses Android dihentikan, serta pengukuran NFR perangkat 2/4 GB masih terbuka. Snapshot seluruh data per UID dimuat ke memori oleh Sembast; pertumbuhan riwayat/profil perlu diukur sebelum pilot besar. Jika simpan sempat commit tetapi konfirmasi terputus, membuka ulang profil memulihkan checkpoint/ringkasan; tidak ada janji bahwa setiap galat filesystem dapat diatasi dengan retry tanpa memuat ulang.
