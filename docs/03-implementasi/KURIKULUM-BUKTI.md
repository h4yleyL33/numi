# Paket pengantar dan bukti jangkar

Tanggal: 30 Oktober 2026. Irisan I06/I07, mengacu pada fokus kelas PPL 2.6.2 dan doktek 1.9/2.2.3. Ini implementasi pengembangan; paket belum disetujui validator dan belum merupakan materi lengkap enam kelas.

## Paket yang sudah tersedia

Setiap kelas memiliki ID, versi, fokus/tujuan, prasyarat topik, ID jangkar, dan dua butir awal berbeda. Status konten adalah `draft-belum-divalidasi`; tidak ada nama atau persetujuan guru yang dibuat-buat.

| Kelas | Topik awal | Isi dua butir pengantar |
| --- | --- | --- |
| 1 | T01 | Menghitung 7 dan 12 kerang dengan gambar. |
| 2 | T02 | Nilai angka puluhan pada 47 dan banyak puluhan pada 63. |
| 3 | T06 | Penjumlahan 245 + 132 dan pengurangan 420 − 150. |
| 4 | T07 | Perkalian dalam konteks piring/kue dan 8 × 9. |
| 5 | T10 | Sisa uang belanja dan harga dua pensil. |
| 6 | T11 | Penjumlahan/pengurangan pecahan berbeda penyebut. |

Butir awal memakai versi `kelas-N-pengantar-v1`. Setelah jangkar awal, diagnostic masih memakai generator topik `generator-v1` dan heuristik naik/turun yang dibatasi paling banyak enam topik/12 soal. Pemilihan seluruh jangkar menurut hasil lama dan graf subketerampilan lengkap belum diterapkan. Dua belas butir awal ini bukan bank asesmen baru untuk mastery dan bukan enam paket lesson lengkap.

## Bukti terpisah dari akses

`BuktiSkill` mencatat topik/ID jangkar atau sampel, indikasi latihan/siap/bukti awal, benar/total, jumlah bantuan, sumber blok, waktu respons, versi kebijakan, serta versi butir. `AksesMateri` mencatat tersedia/terbuka dan alasannya. Status terkunci tidak otomatis menjadi bukti belum mampu; akses terbuka tidak menjadi bukti kemampuan.

Diagnostic hanya memberi indikasi pada topik yang ditanyakan. Dua jawaban benar tidak menyalakan mercusuar, tidak menyatakan mastery, dan tidak menguasai topik di bawah titik uji. Topik yang belum ditanyakan tetap Belum dicoba. Kelas/fase profil tidak berubah oleh skor.

Akses latihan dibuka ketika prasyarat jangkar mendukung. Topik yang sudah dicoba juga dapat dilatih jika belum ada prasyarat yang terbukti perlu latihan; alasannya secara eksplisit menyebutkan bahwa prasyarat lain masih perlu diperiksa. Ini kebijakan pilot akses latihan, bukan kesimpulan kemampuan pada prasyarat yang belum diuji.

Rekomendasi mendahulukan kebutuhan latihan yang dapat diakses, lalu jangkar belum dicoba/siap lanjut. Alasannya tampil pada peta. Lesson dan XP tetap catatan aktivitas, tidak menghasilkan bukti penguasaan. Lima respons pertama yang berbeda, berkonteks mastery, benar semua, tidak berbantuan, dan memiliki versi diketahui menghasilkan bukti awal pada sampel. Blok tidak lengkap, respons duplikat, atau konteks yang salah ditolak. Penyimpanan gagal tidak menerbitkan bukti atau XP baru.

## Data lama

JSON data belajar menjadi versi 3. `skillMap`, hasil diagnostic/mastery, lesson, XP, dan riwayat lama tetap dibaca sebagai arsip. Status gabungan lama tidak otomatis dikonversi ke BuktiSkill. Akses lokal yang dulu terbuka dapat dipertahankan sebagai akses, dengan label bukti Belum dicoba. Profil yang hanya memiliki hasil diagnostic lama tanpa BuktiSkill diarahkan ke pemetaan kembali; riwayat dan XP tidak dihapus.

`Jawaban` baru merekam versi/ID jangkar dan jumlah bantuan. Respons lama memakai penanda `legacy-tanpa-versi`; penanda tersebut tidak dapat memberikan bukti mastery baru. Field bantuan saat ini bernilai nol dari pemutar standar; UI bantuan fleksibel dan pencatatan rinci pemakaiannya tetap I09. Loader menolak klaim bukti awal lima soal yang tidak cocok dengan jumlah/nilai/bantuan yang tersimpan.

## Batas implementasi

- Ringkasan saat ini masih satu sampel terakhir per topik. Pemecahan seluruh topik menjadi banyak subketerampilan dan riwayat bukti/retensi lengkap belum selesai.
- Paket pengantar belum divalidasi guru, belum menjadi konten terbit, dan tidak boleh dipakai untuk menyimpulkan efektivitas pembelajaran atau dukungan seluruh Matematika SD.
- Katalog lengkap aktif/belum tersedia dan graf prasyarat per subketerampilan tetap I06/I07. Model akses sudah menyediakan status belum tersedia.
- Pembaruan I08: mastery sudah memakai sesi persisten, snapshot soal, checkpoint respons, serta finalisasi/reward idempoten. Diagnostic/lesson dan sinkronisasi belum. Rinciannya ada di [CHECKPOINT-MASTERY.md](CHECKPOINT-MASTERY.md).
- Pembahasan akhir blok dan pemeriksaan ulang 3–7 hari belum selesai. Riwayat hasil lama tetap tersedia tetapi tidak dipromosikan menjadi bukti baru.
- Firebase tim dan Android SDK belum tersedia; tidak ada login nyata, deployment cloud, atau pilot anak baru yang dijalankan dalam irisan ini.

## Pemeriksaan

Suite akhir berisi **103 tes lulus** dan analyzer bersih. Tes mencakup inferensi diagnostic yang dihapus, enam paket dan 12 ID/versi butir, roundtrip bukti/akses, status lama, penolakan klaim dua soal sebagai mastery, rekomendasi, XP terpisah, bantuan, respons tidak sah, kegagalan simpan, serta label hasil/kartu pulau pada 390×844. Uji kartu pulau juga menemukan teks terkunci melampaui lebar layar; teks diperbaiki agar membungkus. Lihat [catatan verifikasi](VERIFIKASI.md) untuk status build.
