from pathlib import Path
from xml.sax.saxutils import escape
import json
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,PageBreak,Image,KeepTogether
from reportlab.lib.styles import getSampleStyleSheet,ParagraphStyle
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4,A3,landscape
from reportlab.lib import colors
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas
from PIL import Image as PILImage
import pypdfium2 as pdfium

R=Path(__file__).resolve().parent
O=Path('output/pdf').resolve();O.mkdir(exist_ok=True)
D=json.loads((R/'audit-data.json').read_text(encoding='utf-8'))
M=json.loads((R/'uml-v3-manifest.json').read_text(encoding='utf-8'))
for name,file in [('TNR','times.ttf'),('TNR-B','timesbd.ttf'),('TNR-I','timesi.ttf')]:pdfmetrics.registerFont(TTFont(name,str(Path('C:/Windows/Fonts')/file)))
pdfmetrics.registerFontFamily('TNR',normal='TNR',bold='TNR-B',italic='TNR-I',boldItalic='TNR-B')
S={'body':ParagraphStyle('body',fontName='TNR',fontSize=11,leading=15,spaceAfter=7),
 'h1':ParagraphStyle('h1',fontName='TNR-B',fontSize=16,leading=20,spaceAfter=14),
 'h2':ParagraphStyle('h2',fontName='TNR-B',fontSize=12,leading=16,spaceAfter=7,spaceBefore=8),
 'small':ParagraphStyle('small',fontName='TNR',fontSize=9,leading=12,spaceAfter=5),
 'cell':ParagraphStyle('cell',fontName='TNR',fontSize=9.5,leading=12.5),
 'cap':ParagraphStyle('cap',fontName='TNR-I',fontSize=9,leading=12,spaceAfter=8)}
def p(t,style='body'):return Paragraph(escape(t).replace('\n','<br/>'),S[style])
def tab(rows,widths):
 t=Table([[p(c,'cell') for c in row]for row in rows],colWidths=widths,repeatRows=1,hAlign='LEFT')
 t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),.5,colors.black),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#E8EFED')),('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),5),('BOTTOMPADDING',(0,0),(-1,-1),5),('LEFTPADDING',(0,0),(-1,-1),5),('RIGHTPADDING',(0,0),(-1,-1),5)]));return t
def im(file,maxw=218,maxh=485):
 w,h=PILImage.open(file).size;s=min(maxw/w,maxh/h);return Image(str(file),width=w*s,height=h*s)
def foot(c,doc):
 c.setFont('TNR',9);c.drawString(54,28,'Numi | Audit kurikulum dan UML target v3 | 29 Oktober 2026');c.drawRightString(A4[0]-54,28,str(doc.page))
story=[]
def head(t):story.append(p(t,'h1'))
head('Audit Kurikulum UI UX dan UML Numi')
story.extend([p('29 Oktober 2026 · Rancangan target v3','small'),p(D['verdict']),p('Temuan yang perlu ditindaklanjuti','h2')])
story.append(tab([['Prioritas','Area','Temuan','Perubahan']]+D['findings'],[42,74,175,196]))
story.extend([Spacer(1,10),p('Aktor aplikasi','h2'),p('Siswa adalah aktor utama untuk belajar. Orang tua/wali membantu profil dan membaca laporan pada perangkat yang sama. Guru menjadi validator di luar aplikasi. Portal guru, akun admin, dan notifikasi sistem memerlukan keputusan ruang lingkup tersendiri.')])
story.append(PageBreak());head('Usia pengguna dan cakupan Matematika')
story.extend([p('Pengguna dibatasi pada usia 6–12 tahun. Profil cukup meminta nama panggilan dan usia, tanpa pilihan kelas sekolah. Fase A–C dipakai sebagai acuan kompetensi materi; urutan belajar mengikuti bukti dan prasyarat keterampilan.'),tab([['Fase CP','Cakupan kompetensi','Posisi pada Numi']]+D['phaseCoverage'],[55,235,197]),Spacer(1,10),p('Luas dan volume','h2'),p('CP 046/2025 telah mengenalkan pengukuran/estimasi luas dan volume pada Fase B. Fase C memuat keliling/luas bangun datar beserta gabungannya, durasi, sudut, serta konstruksi dan visualisasi kubus/balok. Luas dan volume tidak menjadi alasan untuk menambahkan pilihan kelas pada profil.'),p('Keputusan cakupan','h2'),p('MVP tetap dua belas topik penguatan numerasi. Katalog membedakan lima elemen serta status aktif dan direncanakan. Usia membantu titik awal; kebutuhan belajar dan bantuan ditentukan dari bukti tiap keterampilan.')])
for title,rows in [('Kebutuhan fungsional yang diperbaiki',D['fr'][:9]),('Kebutuhan tambahan dan kriteria penerimaan',D['fr'][9:])]:
 story.append(PageBreak());head(title)
 story.append(tab([['ID dan fungsi','Aturan target','Keterlacakan','Kriteria penerimaan']]+[[a+'\n'+b,c,d,e]for a,b,c,d,e in rows],[90,167,90,140]))
 story.extend([Spacer(1,10),p('Status: kebutuhan ini menetapkan rancangan berikutnya. Keberadaan tabel, desain, atau diagram belum membuktikan perilaku tersebut tersedia pada aplikasi. Pengujian baseline sebelumnya tidak memverifikasi kebutuhan baru.','small')])
pairs=[
 ('Langkah 1 Profil usia 6–12 tahun','09-profil-sumber.png','10-profil-target.png','Profil awal nama dan usia 6–12 tahun dipertahankan sesuai keputusan pengguna. Tambahan pilihan kelas sekolah dibatalkan. Usia membantu bahasa awal; bukti keterampilan menentukan materi dan bantuan.'),
 ('Langkah 2 dan 3 Diagnostic serta peta','02-diagnostic.png','03-peta.png','Hasil diagnostic masih memberi label Kelas Kecil dan mencampur kemampuan dengan akses Terkunci. Peta masih mencakup 12 pulau numerasi. Target memisahkan bukti skill, akses, dan ketersediaan materi.'),
 ('Langkah 4 dan 5 Lesson serta mastery','06-masterymemberijawaban.png','12-mastery-target.png','Feedback langsung tetap digunakan saat lesson. Pada Hi-Fi sumber, feedback yang sama juga membocorkan jawaban mastery setelah setiap butir. Target menyimpan respons pertama dan menunda pembahasan sampai lima soal selesai.'),
 ('Langkah 6 dan 7 Resume serta laporan wali','04-progres.png','07-laporan-wali.png','Kode belum menyediakan checkpoint setiap respons; resume nyata belum dapat dibuktikan lewat prototype. Laporan wali perlu memisahkan aktivitas, akses, bukti skill bertanggal, jumlah butir, bantuan, dan pemeriksaan ulang.')]
for title,a,b,note in pairs:
 story.append(PageBreak());head(title);story.append(p(note));story.append(Table([[im(R/a),im(R/b)]],colWidths=[243,244],style=TableStyle([('VALIGN',(0,0),(-1,-1),'TOP')])));story.append(p('Gambar berasal dari screenshot audit saat ini. Layar target merupakan simulasi rancangan, bukan hasil belajar pengguna.','cap'))
story.append(PageBreak());head('Perubahan dokumen dan urutan pelaksanaan')
for title,t in [
 ('Sudah diperbarui','Sepuluh UML target memakai gaya hitam-putih dan sederhana. Doktek, proposal, kurikulum, model target, dan prototype mengikuti batas usia 6–12 tahun tanpa pilihan kelas sekolah. Perbaikan bukti kemampuan, checkpoint, serta aturan asesmen tetap dipertahankan.'),
 ('Pekerjaan berikutnya','Pertahankan batas usia 6–12 tahun. Implementasikan model bukti/akses serta checkpoint, lalu sesuaikan diagnostic dan mastery. Uji pemulihan sesi, pembahasan tes, dan laporan wali pada perangkat. Materi pengukuran, geometri, serta data/peluang masuk tahap terpisah setelah tujuan dan instrumennya siap.'),
 ('Batas pemeriksaan','Audit memakai screenshot, konfigurasi reaksi prototype, dokumen, sumber UML, serta pembacaan kode. Tidak dilakukan pilot anak, uji suara/pembaca layar, atau pembuktian persistensi pada perangkat. Ukuran target, keterbacaan latar bertekstur, fokus, dan kegagalan gesture perlu diperiksa langsung.')]:story.extend([p(title,'h2'),p(t)])
story.append(p('Rujukan','h2'))
for title,url in D['sources']:story.extend([p(title,'small'),Paragraph('<link href="'+escape(url)+'">'+escape(url)+'</link>',S['small'])])
story.append(p('Sumber CP dibaca lokal dengan MinerU: doc:45809d2/tier:flash/page:111 sampai page:116.','small'))
SimpleDocTemplate(str(O/'Numi_Audit_Kurikulum_UI_UX_UML_v3_2026-10-29.pdf'),pagesize=A4,leftMargin=54,rightMargin=54,topMargin=48,bottomMargin=48).build(story,onFirstPage=foot,onLaterPages=foot)

# Each UML occupies its own page with its native aspect ratio.
cv=Canvas(str(O/'Numi_UML_Target_v3_2026-10-29.pdf'));cv.setTitle('Numi UML target v3')
for i,m in enumerate(M,1):
 file=Path(m['png']);w,h=PILImage.open(file).size
 size=A3 if h>1200 else landscape(A4)if w>h else A4
 cv.setPageSize(size);pw,ph=size
 cv.setFont('TNR-B',14);cv.drawString(36,ph-30,m['id']+' | Rancangan target v3')
 cv.setFont('TNR',10);cv.drawString(36,ph-48,'Spesifikasi pengembangan; kode aplikasi belum diperbarui.')
 scale=min((pw-72)/w,(ph-104)/h)
 cv.drawImage(str(file),(pw-w*scale)/2,56+(ph-104-h*scale)/2,w*scale,h*scale)
 cv.setFont('TNR',9);cv.drawString(36,25,'Numi | 29 Oktober 2026');cv.drawRightString(pw-36,25,str(i));cv.showPage()
cv.save()
for tag,file in [('audit',O/'Numi_Audit_Kurikulum_UI_UX_UML_v3_2026-10-29.pdf'),('uml',O/'Numi_UML_Target_v3_2026-10-29.pdf')]:
 doc=pdfium.PdfDocument(str(file))
 for batch in range(0,len(doc),9):
  sheet=PILImage.new('RGB',(1050,480*((min(9,len(doc)-batch)+2)//3)),'#dddddd')
  for i in range(batch,min(batch+9,len(doc))):
   pg=doc[i];w,h=pg.get_size();pic=pg.render(scale=min(342/w,460/h)).to_pil();sheet.paste(pic,(((i-batch)%3)*350,((i-batch)//3)*480))
  sheet.save(R/f'qa-{tag}-{batch//9+1}.png')
 print(tag,len(doc),file)
