import json, math
from pathlib import Path
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.colors import HexColor, black, white
import pypdfium2 as pdfium

ROOT = Path(__file__).resolve().parent
c = json.loads((ROOT/'package_content.json').read_text(encoding='utf-8'))
e = json.loads((ROOT/'package-evidence.json').read_text(encoding='utf-8'))
vision = 'Membantu siswa SD menguatkan numerasi dasar melalui langkah belajar yang mengikuti kebutuhan tiap keterampilan.'
scope = 'Numi ditujukan bagi siswa SD usia 6–12 tahun. MVP mencakup dua belas topik yang dipetakan ke sebagian CP Matematika Fase A–C. Kelas 1–3 dan 4–6 menjadi profil penyajian awal; pilihan materi mengikuti bukti per keterampilan. Kelas 3 menjadi jembatan menuju perkalian dan pembagian ketika prasyaratnya memadai.'
status = 'Kode yang tersedia memakai Flutter, Riverpod, dan penyimpanan lokal melalui shared_preferences. Pemeriksaan 28 Oktober 2026 mencatat 51 berkas Dart dan 48 pengujian otomatis lulus. Aturan kurikulum v2, checkpoint setiap jawaban, dan integrasi Firebase masih memerlukan implementasi serta pengujian. Validasi guru dan pilot bersama anak belum dilakukan.'
(ROOT/'visi-bersama.json').write_text(json.dumps({'vision':vision,'scope':scope,'status':status},ensure_ascii=False,indent=2),encoding='utf-8')

# A portrait figure gives every package a readable label at A4 print size.
W,H=500,440
cv=Canvas(str(ROOT/'package-diagram-formal.pdf'),pagesize=(W,H))
cv.setTitle('PKG-002 Pembagian paket kode Numi')
def pkg(x,y,w,h,title,body):
    cv.setFillColor(white);cv.setStrokeColor(black);cv.setLineWidth(.9)
    cv.rect(x,y,w,h,fill=1,stroke=1);cv.rect(x,y+h,min(w-8,max(55,len(title)*5.6)),14,fill=1,stroke=1)
    cv.setFillColor(black);cv.setFont('Helvetica-Bold',10);cv.drawString(x+7,y+h-15,title)
    cv.setFont('Helvetica',8.4)
    for i,line in enumerate(body):cv.drawString(x+7,y+h-30-i*11,line)
def dep(points):
    cv.setStrokeColor(black);cv.setLineWidth(.8);cv.setDash(4,3)
    p=cv.beginPath();p.moveTo(*points[0])
    for pt in points[1:]:p.lineTo(*pt)
    cv.drawPath(p);cv.setDash()
    x,y=points[-1];a,b=points[-2];ang=math.atan2(y-b,x-a)
    for delta in [-.43,.43]:cv.line(x,y,x-7*math.cos(ang+delta),y-7*math.sin(ang+delta))
pkg(140,365,220,48,'bootstrap',['main.dart dan app.dart'])
pkg(140,275,220,58,'features',['onboarding, diagnostic, home, skill_map,', 'lesson, quiz, feedback, mastery, progress, mascot'])
pkg(140,195,220,48,'state',['NumiController dan provider Riverpod'])
pkg(20,105,220,57,'domain',['diagnostic_engine, skill_map_service,', 'learning_path_service, progress_service,', 'companion_service'])
pkg(280,105,200,57,'data.repositories',['NumiRepository', 'LocalNumiRepository'])
pkg(20,12,140,54,'data.content',['Topik, lesson, lencana,', 'generator soal, pesan maskot'])
pkg(190,12,140,54,'data.models',['Siswa, Topik, Soal,', 'Jawaban, DataBelajar'])
pkg(360,12,120,54,'core',['config, theme,', 'utils, widgets'])
dep([(250,365),(250,347)]);dep([(250,275),(250,257)])
dep([(195,195),(195,182),(130,182),(130,176)])
dep([(305,195),(305,182),(380,182),(380,176)])
dep([(65,105),(65,80)]);dep([(195,105),(195,90),(260,90),(260,80)])
dep([(380,105),(380,90),(300,90),(300,80)])
dep([(160,39),(176,39)])
dep([(360,305),(494,305),(494,84),(420,84),(420,80)])
cv.save()
pdf=pdfium.PdfDocument(str(ROOT/'package-diagram-formal.pdf'))
pdf[0].render(scale=4).to_pil().save(ROOT/'package-diagram-formal.png')

pages=[]
def page(title,paras):pages.append({'title':title,'paras':paras})
page('LEMBAR SAMPUL DOKUMEN',[
 'UNIVERSITAS PADJADJARAN','FAKULTAS MATEMATIKA DAN ILMU PENGETAHUAN ALAM','PROGRAM STUDI TEKNIK INFORMATIKA',
 'Jl. Raya Bandung–Sumedang Km. 21 Jatinangor 45363', 'DOKUMENTASI PROYEK PERANGKAT LUNAK','PACKAGE DIAGRAM APLIKASI NUMI','LEMBAR SAMPUL DOKUMEN','[[METADATA]]','Data Pengusul','[[TIM]]','Status dokumen: revisi untuk ditinjau tim sebelum pengumpulan.'])
page('RIWAYAT REVISI DAN DAFTAR ISI',[
 'RIWAYAT REVISI DAN DAFTAR ISI','Riwayat revisi',
 'Versi 2.3 · 28 Oktober 2026. Format laporan disesuaikan dengan dokumentasi teknis. Penjelasan paket, dependensi, dan status pengembangan diperjelas. Visi serta cakupan diselaraskan dengan proposal dan rencana kurikulum.',
 'Daftar isi',*['1  Tujuan dan ruang lingkup','2  Package diagram PKG-002','3  Tanggung jawab package','4  Dependensi dan keputusan arsitektur','5  Contoh alur antar package','6  Selisih kode dan target v2','7  Keterlacakan dan verifikasi','8  Referensi dan keterkaitan dokumen'],
 'Laporan ini menjelaskan struktur kode yang tersedia pada 28 Oktober 2026. Target pengembangan v2 ditulis terpisah agar pembaca dapat membedakan rancangan dari perilaku aplikasi yang sudah berjalan.'])
page('1 TUJUAN DAN RUANG LINGKUP',[
 '1 TUJUAN DAN RUANG LINGKUP','1.1 Visi dan cakupan produk',vision,scope,
 'Anak mengisi profil, mengikuti pemetaan awal, lalu menggunakan peta keterampilan untuk memilih latihan. Lesson, pemeriksaan mandiri, dan umpan balik dirancang untuk membantu anak memahami langkah belajarnya. Gambar, simbol, garis bilangan, dan soal cerita dapat dipakai pada kedua profil kelas sesuai kebutuhan.',
 '1.2 Ruang lingkup diagram',c['scope'],
 'Package diagram membantu tim melihat letak tanggung jawab kode dan dampak perubahan. Misalnya, perubahan aturan kelulusan perlu ditelusuri dari konfigurasi, layanan domain, controller, sampai tampilan hasil. Diagram ini mengelompokkan kode yang ada; diagram tidak menunjukkan bahwa seluruh target kurikulum v2 sudah diterapkan.',
 '1.3 Kondisi pengembangan',status,
 'Aturan 5/5 = 100 untuk mastery dan pemeriksaan ulang setelah jeda merupakan kebijakan pilot yang masih perlu divalidasi. Materi yang belum diuji akan dicatat sebagai belum diuji. Status bukti kemampuan dipisahkan dari status akses materi.'])
page('2 PACKAGE DIAGRAM PKG 002',[
 '2 PACKAGE DIAGRAM PKG 002','[[DIAGRAM]]','Gambar 2.1 Package diagram PKG-002 berdasarkan kode app/lib',c['legend'],
 'Nama data.content, data.models, dan data.repositories menunjukkan tiga subpackage di bawah folder data. Gambar hanya memuat sembilan dependensi utama untuk menjaga keterbacaan. Matriks pada bagian 4 mencatat seluruh 21 hubungan antarkelompok yang ditemukan pada import lokal.'])
for start,end in [(0,4),(4,8)]:
    title='3 TANGGUNG JAWAB PACKAGE' if start==0 else '3 TANGGUNG JAWAB PACKAGE LANJUTAN'
    p=[title]
    for i in range(start,end):
        name,files,desc=c['packages'][i]
        p.extend([f'3.{i+1} {name}',f'Isi paket: {files}.',desc])
    page(title,p)
names=['bootstrap','features','state','domain','data.content','data.models','data.repositories','core']
matrix=[['Pemakai → pemasok','B','F','S','D','C','M','R','K']]
codes=['B','F','S','D','C','M','R','K']
edges={(x['from'],x['to']) for x in e['edges']}
for a,code in zip(names,codes):matrix.append([code+'  '+a]+['—' if a==b else ('●' if (a,b) in edges else '') for b in names])
page('4 DEPENDENSI DAN KEPUTUSAN ARSITEKTUR',[
 '4 DEPENDENSI DAN KEPUTUSAN ARSITEKTUR','4.1 Matriks dependensi','[[MATRIX]]',
 'Tabel 4.1 Import lokal antarkelompok paket. Baris memakai kolom. Titik menandai adanya import; garis menandai sel paket yang sama. Import di dalam kelompok yang sama tidak dihitung sebagai hubungan antarkelompok.',
 'B = bootstrap; F = features; S = state; D = domain; C = data.content; M = data.models; R = data.repositories; K = core.',
 '4.2 Implikasi struktur kode',
 'Controller pada state mengoordinasikan tindakan dari layar, memakai layanan domain, lalu menyimpan perubahan melalui repository. Pemisahan ini memberi titik yang jelas untuk menelusuri aturan belajar dan penyimpanan.',
 'Beberapa hubungan masih melintasi batas tanggung jawab yang diharapkan. core memakai data.models, sedangkan data.content dan domain memakai core. Hasil pemindaian tidak menemukan siklus antarkelompok paket. Ketergantungan pada model tetap perlu diperhatikan ketika komponen bersama di core diubah; pemisahan lapisan belum sepenuhnya mengikuti Clean Architecture.',
 'Penyimpanan berjalan secara lokal melalui LocalNumiRepository. Kontrak NumiRepository menyediakan muat(), simpan(DataBelajar), dan hapus(). Integrasi Firestore masih direncanakan.'])
page('5 CONTOH ALUR ANTAR PACKAGE',[
 '5 CONTOH ALUR ANTAR PACKAGE',*[item for i,(title,desc) in enumerate(c['scenarios'],1) for item in [f'5.{i} {title}',desc]],
 '5.4 Batas yang perlu dipahami',
 'Pada kode saat ini, jawaban di PemutarSoal masih ditampung sementara pada state widget. Data disimpan oleh controller ketika aktivitas atau sesi selesai. Penyimpanan setiap respons dan pemulihan posisi sesi merupakan pekerjaan lanjutan, sehingga alur di atas belum menjamin jawaban tetap tersimpan jika aplikasi tertutup di tengah sesi.'])
page('6 SELISIH KODE DAN TARGET V2',[
 '6 SELISIH KODE DAN TARGET V2',*[item for i,(title,now,target) in enumerate(c['gaps'],1) for item in [f'6.{i} {title}','Kondisi saat ini: '+now,'Rencana perbaikan: '+target]],
 'Urutan tindak lanjut adalah menyepakati aturan bersama guru, menyesuaikan model bukti dan penyimpanan respons, memperbaiki aturan diagnostic serta mastery, lalu menguji alur pada perangkat sebelum pilot.'])
page('7 KETERLACAKAN DAN VERIFIKASI',[
 '7 KETERLACAKAN DAN VERIFIKASI','7.1 Hubungan kebutuhan dengan paket',
 *[item for req,pkg,goal in c['traceability'] for item in [req,pkg+'. '+goal]],
 '7.2 Hasil pemeriksaan kode',c['test_status'],
 'Hasil pengujian otomatis memberi bukti terhadap kode yang diperiksa. Hasil tersebut belum menjadi bukti bahwa materi sesuai untuk semua anak atau bahwa Numi meningkatkan hasil belajar.'])
page('8 REFERENSI DAN KETERKAITAN DOKUMEN',[
 '8 REFERENSI DAN KETERKAITAN DOKUMEN',
 '8.1 Dokumen acuan',*[item for title,url in c['references'] for item in [title,url]],
 'Presentasi progres proyek','https://docs.google.com/presentation/d/1Yaa0mBw-K7EqquZRBN3dTJ-qVaP32Wj03QZuHxYFyc0/edit',
 '8.2 Penggunaan laporan',
 'PKG-002 ditempatkan pada bagian arsitektur dalam dokumentasi teknis dan bagian rancangan sistem dalam proposal. Rencana kurikulum menjadi acuan kebutuhan belajar; project charter menetapkan tujuan dan cakupan; Gantt memuat tindak lanjut; presentasi merangkum progres dengan status yang sama.',
 'Visi, sasaran pengguna, cakupan dua belas topik, profil kelas, dan batas implementasi mengikuti rumusan pada bagian 1. Diagram lama yang masih tersimpan di dokumen sumber diperlakukan sebagai arsip rancangan.',
 '8.3 Pengumpulan tugas',c['submission']])
data={'pages':pages,'tables':{'[[METADATA]]':[
 ['Judul dokumen','Package Diagram Aplikasi Numi'],['Jenis dokumen','Dokumentasi Proyek Perangkat Lunak'],['Nomor dokumen','RPL-Imun 2026 / PKG-002'],['Nomor revisi','2.3'],['Tanggal penerbitan','28 Oktober 2026'],['Unit penerbit','Program Studi Teknik Informatika'],['Cakupan pemeriksaan','Kode app/lib pada 28 Oktober 2026']],
 '[[TIM]]':[['Nama pengusul','NPM']]+c['team'],'[[MATRIX]]':matrix},'vision':vision,'scope':scope,'status':status}
(ROOT/'formal-package-plan.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'pages':len(pages),'characters':sum(sum(map(len,p['paras'])) for p in pages),'edges':len(edges)}))
