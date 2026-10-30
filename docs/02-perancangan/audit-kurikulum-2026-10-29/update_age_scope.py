from pathlib import Path
import json,re
R=Path(__file__).resolve().parent
p=R/'audit-data.json';d=json.loads(p.read_text(encoding='utf-8'))
d['verdict']='Alur dasar Numi tetap ditujukan bagi anak usia 6–12 tahun. Profil cukup meminta nama panggilan dan usia; pilihan kelas sekolah tidak diperlukan. Perbaikan bukti per keterampilan, penyimpanan respons, asesmen, dan batas cakupan materi tetap menjadi target pengembangan.'
d['findings'][0]=['Sesuai','Profil usia','05a/05b meminta umur 6–12 tahun, sesuai batas pengguna yang ditetapkan.','Pertahankan pilihan usia 6–12; hapus tambahan pilihan kelas sekolah.']
for row in d['findings']:row[:]=[c.replace('bantuan lintas kelas','bantuan sesuai kebutuhan').replace('kategori umur dapat membatasi bantuan','pengelompokan kaku dapat membatasi bantuan')for c in row]
for row in d['fr']:
 if row[0]=='FR-003':row[2]='Gunakan prasyarat dan bukti skill; usia membantu titik awal tanpa menjadi pengunci materi.';row[4]='Mengubah usia dalam rentang 6–12 tidak menghapus bukti atau menutup remedial.'
 if row[0]=='FR-004a/b':row[1]='Lesson sesuai kebutuhan';row[2]='Bahasa dan kepadatan menyesuaikan kebutuhan anak usia 6–12 tahun; gambar, simbol, dan cerita tersedia sesuai kesiapan.';row[4]='Anak usia 12 tahun tetap dapat memakai gambar dan fondasi.'
 if row[0]=='FR-010':row[:]=['FR-010','Batas usia pengguna','Profil menyimpan usia bilangan bulat 6–12 tahun. Tidak ada isian kelas sekolah atau opsi di luar rentang.','UC-008 · CLS-004','Pilihan 6–12 dapat disimpan; nilai di luar rentang ditolak tanpa menghapus jejak belajar.']
 if row[0]=='FR-011':row[2]='Tampilkan elemen, fase CP, prasyarat, serta status aktif atau direncanakan; tanpa filter wajib kelas sekolah.'
d['sources'][-1][0]='Figma salinan revisi target v3 untuk usia 6–12 tahun'
d['phaseCoverage']=[['A','Fondasi bilangan, tambah-kurang, pecahan awal, pola, bentuk, pengukuran dan data sederhana.','T01–T05 dan bagian aljabar dasar; cakupan elemen lain belum lengkap.'],['B','Pengembangan bilangan, kali-bagi, pecahan, pengukuran luas/volume, geometri, dan data.','T06–T09 dan bagian T12 sesuai prasyarat; pengukuran dan elemen lain direncanakan.'],['C','Operasi, uang, pecahan/desimal, proporsi, keliling/luas, sudut/durasi, ruang, serta data/peluang.','T10–T12 dan remedial fondasi; belum mencakup seluruh CP.']]
d.pop('grades',None)
p.write_text(json.dumps(d,ensure_ascii=False,indent=2),encoding='utf-8')
# Keep the supplied UML styles consistent for future baseline renders too.
q=R.parent/'uml'/'src'/'_gaya.iuml';s=q.read_text(encoding='utf-8');s='\n'.join(re.sub(r'#[0-9A-Fa-f]{6}','#FFFFFF' if 'backgroundcolor' in line.lower() else '#000000',line)for line in s.splitlines())+'\n';q.write_text(s,encoding='utf-8')
notes={R/'keputusan-v3.md': [('1. Tambahkan kelasSekolah 1–6 dan opsi Belum tahu. Usia dan kelas disimpan terpisah. Ubah kelas tidak mereset bukti belajar atau membatasi materi secara permanen.','1. Profil cukup menyimpan nama panggilan dan usia 6–12 tahun. Pilihan kelas sekolah dan opsi Belum tahu dibatalkan sesuai keputusan pengguna. Usia membantu titik awal; perubahan usia tidak mereset bukti belajar.'),('2. Profil penyajian kelas 1–3/4–6 hanya memilih bahasa dan kepadatan awal.','2. Bahasa dan kepadatan penyajian mengikuti kebutuhan anak usia 6–12 tahun.'),('bahwa kelas sekolah, checkpoint','bahwa validasi usia, checkpoint'),('hanya nama/usia; belum ada kelas sekolah.','nama/usia 6–12 tahun, sesuai batas pengguna.')],R.parent/'uml'/'target-v3-2026-10-29'/'README.md':[('profil kelas 1–6','profil usia 6–12 tahun'),('Model target kelas, CP','Model target usia, CP')],R.parent/'uml'/'README.md':[('kelas sekolah 1–6','usia 6–12 tahun')],R.parent/'kurikulum'/'README.md':[('Kelas sekolah 1–6, profil penyajian awal, dan bukti per subketerampilan merupakan tiga hal terpisah.','Pengguna dibatasi pada usia 6–12 tahun; profil tidak memerlukan pilihan kelas sekolah. Penyajian dan materi mengikuti bukti per subketerampilan.')],R/'HASIL-AUDIT.md':[('pemilihan kelas 1–6','pemilihan usia 6–12 tahun'),('usulan titik awal kelas 1–6','pemetaan fase sebagai acuan materi bagi usia 6–12 tahun'),('pilihan kelas 1–6 dan Belum tahu','pilihan usia 6–12 tahun'),('Pilihan kelas pada prototype','Pilihan usia pada prototype')]}
for file,pairs in notes.items():
 s=file.read_text(encoding='utf-8')
 for a,b in pairs:s=s.replace(a,b)
 s=s.replace('dan batas implementasi.','dan batas implementasi.')
 file.write_text(s,encoding='utf-8')
print('Batas usia dan data laporan diperbarui.')
