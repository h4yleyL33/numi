from pathlib import Path
import json

r=Path(__file__).parent
p=r/'package_content.json'
old=json.loads(p.read_text(encoding='utf-8'))
c=json.loads(json.dumps(old))
c['purpose']='Numi membantu siswa SD usia 6-12 tahun berlatih numerasi sesuai kemampuan mereka. Anak mengisi profil dan mengikuti diagnostic, lalu melihat peta keterampilan untuk memilih latihan berikutnya. Setelah lesson dan mastery, aplikasi menampilkan progres serta pesan dari maskot. Versi MVP memuat dua belas topik yang mencakup sebagian CP Matematika Fase A-C.'
c['scope']='Package diagram PKG-002 menunjukkan pembagian kode Flutter di app/lib dan hubungan antarpaketnya. Dua berkas awal, main.dart dan app.dart, dikelompokkan sebagai bootstrap. Nama ini dipakai untuk menjelaskan perannya, sehingga tidak ada folder bootstrap tersendiri. Paket lain mengikuti tanggung jawab kode yang sudah tersedia. Integrasi server masih berada pada tahap rencana.'
c['legend']='Setiap kotak bertab mewakili sebuah package. Kotak yang berada di dalamnya menunjukkan subpackage. Panah putus-putus dari A ke B berarti A memakai kode dari B. Nama subfolder yang tercantum menjelaskan isi paket. Agar gambar mudah dibaca, diagram hanya menampilkan hubungan utama; seluruh hubungan yang ditemukan pada import lokal tercatat dalam matriks. Panah tersebut dibaca sebagai dependency, bukan otomatis sebagai relasi package import dalam UML.'
descriptions=[
'Aplikasi dimulai dari dua berkas ini. main.dart memuat SharedPreferences dan data awal, lalu memasang LocalNumiRepository pada ProviderScope. Setelah itu, app.dart menjalankan MaterialApp dan menampilkan layar awal.',
'Paket ini berisi layar dan interaksi yang dilihat anak. PemutarSoal, misalnya, menampilkan pertanyaan dan menampung jawaban sementara sebelum meneruskannya melalui callback. Layar-layar tersebut memakai controller, model, dan konten belajar.',
'Provider Riverpod dan NumiController berada di paket ini. Controller menerima tindakan dari layar, mengatur perubahan profil maupun hasil belajar, lalu menyimpan data melalui NumiRepository. Perhitungan progres dan reward juga dikoordinasikan dari sini.',
'Aturan belajar ditempatkan pada layanan domain, seperti pemetaan kemampuan, rekomendasi latihan, perhitungan progres, dan pemilihan pesan maskot. Layanan ini memakai model serta konten dari data, berikut konfigurasi dan utilitas dari core.',
'Model menyimpan bentuk data yang dipakai bersama oleh layar dan layanan aplikasi. Paket ini juga menangani serialisasi. DataBelajar menggabungkan data belajar yang akan disimpan pada perangkat.',
'Daftar topik, lesson, lencana, kalimat maskot, dan generator soal disimpan di sini. Konten awal sudah tersedia, tetapi soal, prasyarat, serta metadata bukti kemampuan masih perlu disesuaikan dengan rencana kurikulum v2.',
'Paket ini menyediakan kontrak NumiRepository dengan fungsi muat(), simpan(DataBelajar), dan hapus(). Saat ini LocalNumiRepository menyimpan data dalam bentuk JSON melalui shared_preferences. Adapter untuk Firestore belum tersedia.',
'Konfigurasi AppConfig, tema, utilitas tanggal, dan widget bersama dikumpulkan di sini. Paket core masih bergantung pada model tertentu karena widget chip_status mengimpor model topik.'
]
for row,text in zip(c['packages'],descriptions):row[2]=text
c['scenarios']=[
 ['Profil dan pembukaan aplikasi','Saat aplikasi dibuka, bootstrap memuat data melalui repository dan menyiapkan ProviderScope. Layar onboarding menerima profil anak, kemudian memanggil state.daftar(). NumiController meneruskan data ke NumiRepository, dan LocalNumiRepository menyimpannya melalui SharedPreferences.'],
 ['Diagnostic dan peta','Layar diagnostic membuat SesiDiagnostic. Layanan domain memakai GeneratorSoal dan model untuk menyiapkan pertanyaan. Setelah satu blok jawaban dinilai, state.simpanDiagnostic() memanggil SkillMapService dan menyimpan hasilnya melalui repository. Layar skill_map kemudian menampilkan peta kemampuan.'],
 ['Lesson dan mastery','Layar lesson atau mastery memakai quiz/PemutarSoal untuk menjalankan soal. Jawaban ditampung sebagai model Jawaban. Ketika sesi selesai, callback meneruskan hasil ke NumiController untuk diproses oleh ProgressService, SkillMapService, dan CompanionService. Data kemudian disimpan, lalu hasil sesi dan progres ditampilkan.']
]
c['gaps']=[
 ['Diagnostic','Kode saat ini dapat menganggap topik di bawah titik uji sudah dikuasai. Hasilnya juga dipakai untuk menetapkan kelompok belajar secara keseluruhan.','Penilaian perlu memakai bukti per keterampilan. Materi yang belum diuji tetap diberi status belum diuji, sedangkan akses materi dicatat terpisah.'],
 ['Checkpoint','PemutarSoal masih menampung jawaban pada state widget. Controller menyimpan data ketika aktivitas atau sesi selesai.','Setiap jawaban dan posisi sesi perlu disimpan agar anak dapat melanjutkan setelah aplikasi tertutup. Perilaku ini harus diuji dengan menutup paksa lalu membuka kembali aplikasi.'],
 ['Mastery','Konfigurasi masih memakai ambang 95, sementara MasteryScreen menampilkan feedback bawaan setelah setiap soal.','Gunakan penulisan 5/5 = 100 dan tampilkan pembahasan setelah blok tes selesai. Simpan respons pertama serta versi kebijakannya, lalu periksa kembali kemampuan setelah jeda.'],
 ['Penyimpanan cloud','Dependensi yang aktif adalah Flutter, Riverpod, dan shared_preferences. Adapter Firestore belum ditemukan; firebase/firestore.rules masih berupa rancangan.','Integrasi Firebase perlu dikerjakan bertahap, termasuk penetapan kepemilikan data dan pengujian aturan akses. Sampai proses itu selesai, layanan cloud tetap dicatat sebagai rencana.'],
 ['Validasi materi','Kode sudah memuat dua belas topik dan generator soal. Kesesuaian materi untuk pembelajaran anak belum divalidasi.','Guru perlu memeriksa materi, terutama transisi kelas 3, rubrik, dan miskonsepsi. Pilot bersama anak dan pendamping dilakukan setelah perbaikan tersebut.']
]
c['submission']='Tugas ini meminta package diagram yang sesuai dengan proposal, disertai penjelasannya. Nama PDF memakai enam digit terakhir NPM setiap anggota. Project manager mengumpulkannya melalui Google Classroom paling lambat H-1 praktikum berikutnya pukul 23.59. Lampiran tugas belum menyebut tanggal kalender. Berkas ini masih perlu ditinjau tim sebelum dikumpulkan.'
c['test_status']='Pada 28 Oktober 2026, perintah flutter test --no-pub --reporter expanded menghasilkan 48 pengujian otomatis lulus. Sebelumnya, cache dependensi dipulihkan melalui flutter pub get. Pengujian mencakup domain, state, generator soal, dan satu alur widget pada kode yang tersedia. Aturan v2, pemulihan sesi per respons, integrasi Firebase, pengujian menyeluruh pada perangkat, serta efektivitas belajar masih perlu diperiksa. Log tersimpan pada flutter-test.log. Penyuntingan dokumen ini tidak mengubah kode aplikasi.'
changes=[]
for key in ['purpose','scope','legend','submission','test_status']:changes.append([old[key],c[key]])
for key,idx in [('packages',2),('scenarios',1)]:
    for a,b in zip(old[key],c[key]):changes.append([a[idx],b[idx]])
for a,b in zip(old['gaps'],c['gaps']):
    changes.extend([[a[1],b[1]],[a[2],b[2]]])
(r/'package-prose-before.json').write_text(json.dumps(old,ensure_ascii=False,indent=2),encoding='utf-8')
(r/'package-prose-changes.json').write_text(json.dumps(changes,ensure_ascii=False,indent=2),encoding='utf-8')
p.write_text(json.dumps(c,ensure_ascii=False,indent=2),encoding='utf-8')
print(len(changes),'prose replacements; identifiers, team, references, and diagram data preserved')
