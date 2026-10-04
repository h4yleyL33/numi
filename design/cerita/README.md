# Alur Cerita Numi

## Dunia

Samudra Angka adalah lautan malam dengan dua belas pulau. Setiap pulau mewakili satu
topik numerasi dari Kurikulum Merdeka (lihat `docs/02-perancangan/kurikulum`). Dulu setiap
pulau punya mercusuar yang menyala, sampai Kabut Lupa datang dan memadamkan semuanya.

Numi adalah kunang-kunang kecil penjaga cahaya. Cahayanya cukup untuk menyalakan
mercusuar lagi, tetapi ia butuh teman yang pandai berhitung. Teman itu adalah siswa.

## Cerita pembuka

Tiga layar sebelum form profil (layar 02 sampai 04 di Figma):

1. Di tengah Samudra Angka ada dua belas pulau. Dulu setiap pulau punya mercusuar yang menyala terang.
2. Suatu malam Kabut Lupa datang dan memadamkan semua mercusuar. Pulau-pulau jadi gelap.
3. Aku Numi, kunang-kunang penjaga cahaya. Aku bisa menyalakan mercusuar lagi, tetapi aku butuh teman yang pandai berhitung. Maukah kamu membantuku?

## Cerita sebagai mekanik belajar

Setiap unsur cerita punya padanan di aplikasi, supaya cerita tidak sekadar hiasan.

| Di cerita | Di aplikasi | Kebutuhan |
|---|---|---|
| Membaca peta sebelum berlayar | Diagnostic test | FR-001 |
| Pulau gelap, redup, terang | Status topik di skill map | FR-002 |
| Numi melayang di atas satu pulau | Rekomendasi learning path | FR-003 |
| Mengumpulkan cahaya di pulau | Lesson dan XP | FR-004a, FR-004b, FR-006 |
| Menyalakan mercusuar | Mastery test lulus | FR-007 |
| Nyala api Numi | Streak harian | FR-006 |
| Numi mengantuk saat apinya redup | Pengingat streak | FR-009 |
| Lencana penjelajah | Badge | FR-006 |

## Kenapa kunang-kunang

Tabel stakeholder di doktek bagian 1.2 menyebut siswa SD butuh tampilan visual, umpan balik
langsung, dan motivasi lewat gamifikasi. Kunang-kunang dipilih karena gagasan "cahaya yang tumbuh" mudah
dipahami anak: semakin banyak belajar, semakin terang. Kegagalan tidak digambarkan sebagai
hukuman, cukup sebagai cahaya yang belum menyala, sehingga nadanya tetap menyemangati
(NFR-001).

Pemilihan malam dan pulau juga praktis: latar gelap membuat cahaya status topik mudah
dibedakan sekilas, dan peta pulau memberi alasan alami untuk urutan belajar yang bercabang.
