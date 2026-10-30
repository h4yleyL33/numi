# Baseline pengembangan Numi

Tanggal: 30 Oktober 2026. Status: init pengembangan lokal; belum memenuhi syarat pengujian akhir Bab IV pada doktek 3.3.4.

Pembaruan lanjutan: [akun wali dan beberapa profil](AKUN-PROFIL.md) sudah memiliki adapter, UI, dan isolasi penyimpanan lokal. Proyek Firebase tim belum dibuat, sehingga login nyata/cloud belum dinyatakan selesai. Bagian bertanda “init” di bawah merekam baseline sebelum irisan akun; status terkini ada pada backlog dan catatan verifikasi.

## Acuan yang berlaku

- [Doktek Bab I–III](../../output/pdf/Numi_Dokumen_Teknis_Bab_I-III.pdf): kebutuhan, arsitektur, model data, kontrak, dan syarat penerimaan implementasi.
- [PPL Bab I–III](../../output/pdf/Numi_Proposal_PPL_Bab_I-III.pdf): tujuan, fokus tiap kelas, metodologi, jadwal acuan, dan cakupan 12 topik.
- [PRD dan turunannya](../../prd/README.md): kebutuhan produk, kajian UI anak, kurikulum kelas kecil/besar, dan redesign. Keputusan lama dibatasi oleh tabel penyelarasan di bawah.
- [Rencana implementasi](../../tasks/plan.md), [backlog dan kriteria terima](../../tasks/todo.md), serta [catatan verifikasi](VERIFIKASI.md).

Pembacaan dokumen memakai MinerU 4.0.7 lokal, tier basic: doktek `doc:9bbebcf/tier:basic/page:1` sampai halaman 30 dan PPL `doc:20e1f4c/tier:basic/page:1` sampai halaman 33. Diagram dirujuk melalui uraian dokumen; gambar UML tidak dipakai sebagai bukti implementasi runtime. Tidak ada parsing remote.

## Produk dan batas versi awal

Numi membantu penguatan numerasi siswa SD kelas 1–6 melalui cerita Samudra Angka, diagnostik, peta, lesson, tes penguasaan, serta ringkasan wali. Dua belas topik mencakup bilangan, operasi, pecahan, uang, KPK, dan FPB. Luas, volume, geometri, data/peluang, portal guru, leaderboard, dan iklan berada di luar versi awal.

Wali menjadi pemilik akun Google/Firebase dan dapat memiliki beberapa profil anak pada rancangan target. Profil meminta nama panggilan serta satu kelas 1–6. Fase A/B/C diturunkan dari kelas; bukti kemampuan tidak mengganti kelas. Anak kelas atas tetap dapat berlatih fondasi dan memakai gambar atau bantuan.

Kode saat init awal masih satu profil lokal. Irisan lanjutan menambahkan beberapa profil lokal per UID dan adapter login Google/Firebase. Konfigurasi tim, login nyata, isolasi cloud, dan sinkronisasi belum diterima. Versi ini untuk pengembangan; keberadaan pilihan kelas belum menyatakan enam paket materi selesai atau tervalidasi.

## Penyelarasan seluruh PRD

| Sumber lama | Keputusan yang tetap dipakai | Penyesuaian menurut PPL/doktek terbaru |
| --- | --- | --- |
| `prd/README.md` | Cerita, 12 pulau, 12 topik, lesson, mastery, XP/streak/lencana, wali, tanpa iklan/leaderboard. | Tambahkan FR-010–017; akun wali sebelum belajar; enam kelas dan tiga fase; bukti terpisah dari akses; checkpoint per respons. |
| `prd/kajian-ui-anak.md` | Petunjuk pendek, kontras, target besar, alternatif ketuk, status lewat ikon/teks, satu tindakan utama, gerbang wali. | Dukungan gambar/suara menurut kebutuhan pada seluruh kelas; target minimal terbaru 48 dp; ukuran lebih besar tetap boleh. Uji bersama anak belum dilakukan. |
| `prd/kurikulum-kelas-1-3.md` | Tujuan T01–T06, benda/gambar/simbol, contoh numerasi dan batas angka. | Label kelas kecil bukan kelompok kemampuan global. Muatan kelas 1, 2, dan 3 dibedakan; validasi guru per paket; belum diuji tidak dianggap lemah. |
| `prd/kurikulum-kelas-4-6.md` | T07–T12, penalaran dan konteks cerita. | Paket kelas 4, 5, dan 6 berbeda; gambar/bantuan tetap boleh; prasyarat per skill; lima soal hanya bukti awal, retensi 3–7 hari direncanakan. |
| `prd/redesign-ui.md` dan mockup | MAIN, satu tindakan utama, Cek sesudah memilih, rincian di ruang wali. | Saat tes pakai Kirim dan tunda pembahasan sampai blok selesai. Form umur dan dua kelompok diganti kelas; mockup terbaru pada PPL 3.5/doktek 3.1 menjadi acuan. |
| Audit/UML 29 Oktober | Pemisahan bukti/akses, kontrak checkpoint, guru sebagai validator eksternal. | Keputusan usia dibatalkan oleh dokumen Bab I–III 30 Oktober; diagram terbaru akun/kelas ada pada doktek Bab II. |

## Keterlacakan kebutuhan fungsional

“Awal” berarti komponen sudah ada sebelum init, belum memenuhi seluruh target. “Parsial” menunjukkan perubahan init atau sebagian perilaku tersedia; bukan penerimaan keseluruhan FR.

| ID | Target doktek | Lokasi kode relatif terhadap `app/lib/` | Kondisi dan pekerjaan berikutnya |
| --- | --- | --- | --- |
| FR-001 | Diagnostic maks. 12 soal, paket kelas dan bukti sebelumnya. | `domain/diagnostic_engine.dart`, `data/content/paket_kelas.dart`, `features/diagnostic/` | Parsial: enam titik awal dari kelas; adaptasi lama masih berbasis topik. Paket jangkar/hasil sebelumnya: I06–I08. |
| FR-002 | Bukti kemampuan terpisah dari akses. | `domain/skill_map_service.dart`, `features/skill_map/` | Awal masih satu StatusTopik; I07. |
| FR-003 | Rekomendasi dari bukti/prasyarat. | `domain/learning_path_service.dart` | Awal memilih status topik; I07/I09. |
| FR-004a | Lesson fondasi dengan bantuan fleksibel. | `features/lesson/`, `data/content/daftar_lesson.dart` | Awal tersedia, paket/dukungan semua kelas belum lengkap; I06/I09. |
| FR-004b | Penalaran/cerita pada semua kelompok sesuai kebutuhan. | `data/content/generator_soal.dart`, `features/quiz/tampilan_soal.dart` | Awal, diferensiasi enam kelas dan validasi masih I06/I09. |
| FR-005 | Lesson langsung; tes menunda pembahasan. | `features/quiz/pemutar_soal.dart`, `features/feedback/` | Init mencegah banner/kunci per butir pada kedua tes. Pembahasan akhir blok masih I03/I07. |
| FR-006 | XP/streak/level/lencana tanpa pengurangan saat salah. | `domain/progress_service.dart`, `state/numi_controller.dart` | Awal; finalisasi idempoten dan reward event belum ada; I08/I10. |
| FR-007 | Lima soal baru, respons pertama, 5/5 bukti awal, periksa ulang. | `features/mastery/`, `core/config/app_config.dart` | Awal ambang 95 dari lima soal setara 5/5. Kebaruan/versi, pembahasan akhir dan retensi belum selesai; I06/I10. |
| FR-008 | Aktivitas terpisah dari bukti. | `features/progress/` | Awal aktivitas tersedia; pemisahan laporan I11. |
| FR-009 | Maskot singkat dan tidak menghalangi. | `domain/companion_service.dart`, `features/mascot/` | Awal, perlu uji perangkat/anak; I11. |
| FR-010 | Satu kelas 1–6, tiga fase, paket berbeda, perubahan tanpa reset. | `data/models/siswa.dart`, `data/content/paket_kelas.dart`, `features/onboarding/`, `state/numi_controller.dart` | Init form/validasi/fase/migrasi lokal tersedia. Paket penuh dan pengaturan ubah kelas oleh wali masih I05/I06. |
| FR-011 | Katalog fase/prasyarat/aktif/belum tersedia. | `data/content/daftar_topik.dart`, `features/skill_map/` | Awal hanya 12 topik; katalog target I06/I07. |
| FR-012 | Bukti sumber/waktu/bantuan/versi/jumlah. | `data/models/catatan_belajar.dart` | Belum ada model BuktiSkill lengkap; I07/I08. |
| FR-013 | Respons+checkpoint atomik, resume butir sama, deduplikasi. | `data/repositories/`, `features/quiz/`, `state/numi_controller.dart` | Init memastikan state menunggu repository dan menahan callback selesai ganda di widget. Belum checkpoint durabel atau finalisasi idempoten; I08. |
| FR-014 | Bantuan fleksibel, pengulangan, alternatif ketuk. | `features/quiz/tampilan_soal.dart` | Awal, audit seluruh bentuk dan pencatatan bantuan belum dilakukan; I09. |
| FR-015 | Ringkasan wali per skill, waktu, jumlah butir. | `features/progress/` | Belum sesuai target; I11. |
| FR-016 | Butir berversi, tujuan, kunci/rubrik, persetujuan validator. | `data/content/`, `data/models/soal.dart` | Generator pengembangan tersedia; metadata/validasi belum lengkap; I06. |
| FR-017 | Google wali, banyak profil, batal/gagal/logout, isolasi. | `features/account/`, `data/repositories/firebase_akun_repository.dart`, `local_profil_repository.dart`, bootstrap `main.dart`. | Adapter/UI dan isolasi cache per UID/profil tersedia. Konfigurasi tim/login nyata/isolasi cloud masih I04/I05; rules belum dipasang. |

## Kebutuhan nonfungsional

| ID | Kriteria penerimaan | Bukti init dan tindak lanjut |
| --- | --- | --- |
| NFR-001 | 80% peserta pilot menyelesaikan lesson tanpa bantuan navigasi. | Widget bukan uji anak; pilot dan validasi bantuan pada I12. |
| NFR-002 | Respons lokal ≤2 detik pada perangkat uji. | Belum ada pengukuran perangkat; ukur terpisah dari login/sync pada I12. |
| NFR-003 | Pulih respons/posisi; gagal simpan terlihat; retry tanpa hasil/reward ganda. | Controller menunggu simpan, profil menampilkan gagal/retry. Checkpoint, durabilitas, dan idempotensi belum selesai; I08. |
| NFR-004 | Android API 26+, RAM 2/4 GB, 360–412 dp, landscape/teks besar. | Widget memakai beberapa ukuran termasuk 320/390 dp dan landscape; build/perangkat Android tetap perlu I12. |
| NFR-005 | Data pribadi hanya untuk akun/pemilik yang sah. | Bootstrap menahan akses, adapter auth dan guard UID/profil diuji dengan fake. Login nyata/isolasi cloud belum diuji; I04/I05 belum diterima penuh. |
| NFR-006 | Tanpa iklan, leaderboard, tautan keluar saat belajar. | Tidak ditambahkan SDK iklan/tautan baru; pemeriksaan alur rilis pada I12. |

## Kebutuhan data

| ID | Model target | Kondisi awal/init dan irisan |
| --- | --- | --- |
| DATA-001 | Profil: ID tetap, UID wali, nama, kelas, preferensi, pembaruan. | Siswa mendapat kelas/fase dan waliUid; preferensi/cloud masih I05. |
| DATA-002 | Materi/butir: skill/fase/tujuan/prasyarat/versi/kunci/rubrik/validasi. | Topik/Soal/Lesson awal; lengkapi I06. |
| DATA-003 | Diagnostic: profil/sesi, respons/bantuan/jumlah/waktu/kebijakan. | DiagnosticResult masih per topik; I07/I08. |
| DATA-004 | Aktivitas per profil. | LessonProgress/XP/streak/lencana tersedia satu profil; I05/I10. |
| DATA-005 | Respons pertama dengan identitas dan versi tetap. | Jawaban tersedia tanpa seluruh metadata; I08. |
| DATA-006 | Akun, hubungan profil dan status autentikasi. | AkunWali dan stream Firebase tersedia; token dikelola SDK. Konfigurasi/login nyata masih I04. |
| DATA-007 | Sesi/checkpoint: urutan/versi/cursor/status/kebijakan. | Belum ada; I08. |
| DATA-008 | BuktiSkill dan AksesMateri terpisah. | Masih StatusTopik tunggal; I07. |
| DATA-009 | Konten, versi, validator, tanggal, keputusan/catatan. | Belum ada catatan persetujuan konten; I06. |

## Urutan kerja menurut PPL dan doktek

Ikuti analisis → perancangan → implementasi → pengujian → penyelesaian/rilis. Revisi kebutuhan dicatat sebelum dipakai. Unit/widget test selama implementasi memastikan perubahan kode; hasil tersebut tidak menggantikan pengujian akhir Bab IV, validasi guru, atau pilot anak.

PPL 3.2.4 merencanakan implementasi tahap 1 pada minggu 4–6 (lingkungan, onboarding, diagnostic, peta), tahap 2 pada minggu 7–9 (lesson, mastery, gamifikasi, maskot, akun/kelas), pengujian minggu 10–11, serta APK/dokumen pada minggu 12–13. Jadwal ini adalah rencana acuan, bukan bukti selesai. Backlog I00–I12 memerinci dependensi penyesuaian terbaru tanpa mengubah pembagian peran tim secara sepihak.

Irisan selanjutnya: I04 akun wali dan I05 isolasi profil, kemudian I06–I08 konten/bukti/checkpoint sebelum alur belajar dinyatakan memenuhi rancangan. Setup Firebase tim memerlukan proyek, aplikasi Android, penyedia Google, SHA sertifikat, dan konfigurasi SDK; kunci privat tidak dimasukkan ke repo.
