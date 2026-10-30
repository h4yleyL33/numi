from pathlib import Path
import json, math, html
from reportlab.pdfgen import canvas
from reportlab.lib.colors import HexColor, Color, white
from reportlab.lib.pagesizes import A4, landscape
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, Table, TableStyle
from reportlab.lib.styles import ParagraphStyle
import pypdfium2 as pdfium

R=Path(__file__).parent
C=json.loads((R/'package_content.json').read_text(encoding='utf-8'))
E=json.loads((R/'package-evidence.json').read_text(encoding='utf-8'))
OUT=R.parents[2]/'output/pdf'; OUT.mkdir(parents=True,exist_ok=True)
for n,f in [('Arial','arial.ttf'),('Arial-Bold','arialbd.ttf')]:pdfmetrics.registerFont(TTFont(n,Path('C:/Windows/Fonts')/f))
TEAL='#174951'; INK='#19373D'; MUTED='#536970'; CREAM='#FFF8E8'; AQUA='#D9F0E9'; GOLD='#FFBD59'; BORDER='#94B4AD'
W,H=landscape(A4)
style=ParagraphStyle('body',fontName='Arial',fontSize=10,leading=14,textColor=HexColor(INK),spaceAfter=6)
small=ParagraphStyle('small',parent=style,fontSize=9,leading=12)
def p(t,st=style):return Paragraph(html.escape(t).replace('\n','<br/>'),st)
def table(c,rows,widths,y,headers=True,fs=9):
    data=[[p(str(x),ParagraphStyle('cell',parent=small,fontSize=fs,leading=fs+3,textColor=white if headers and i==0 else HexColor(INK))) for x in row] for i,row in enumerate(rows)]
    t=Table(data,colWidths=widths,hAlign='LEFT',repeatRows=1)
    commands=[('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),7),('RIGHTPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),5),('BOTTOMPADDING',(0,0),(-1,-1),5),('LINEBELOW',(0,0),(-1,0),0.7,HexColor(TEAL)),('ROWBACKGROUNDS',(0,1),(-1,-1),[white,HexColor('#F2F8F6')]),('GRID',(0,0),(-1,-1),0.3,HexColor('#D6E2DD'))]
    if headers:commands.append(('BACKGROUND',(0,0),(-1,0),HexColor(TEAL)))
    t.setStyle(TableStyle(commands));tw,th=t.wrap(sum(widths),H);t.drawOn(c,38,y-th)
    if y-th<40:raise ValueError(f'Table overflows page: bottom={y-th}')
    return y-th
def para(c,t,x,y,w,st=style):
    a=p(t,st);_,h=a.wrap(w,H);a.drawOn(c,x,y-h);return y-h-7
def page(c,n,title,sub=''):
    c.setFillColor(HexColor('#F9FCFA'));c.rect(0,0,W,H,fill=1,stroke=0)
    c.setFillColor(HexColor(TEAL));c.rect(0,H-12,W,12,fill=1,stroke=0)
    c.setFont('Arial-Bold',22);c.drawString(38,H-53,title)
    if sub:c.setFont('Arial',9);c.setFillColor(HexColor(MUTED));c.drawString(38,H-73,sub)
    c.setStrokeColor(HexColor(BORDER));c.line(38,34,W-38,34)
    c.setFont('Arial',8);c.setFillColor(HexColor(MUTED));c.drawString(38,21,'Numi | Package Diagram PKG-002 | 28 Oktober 2026');c.drawRightString(W-38,21,f'{n} / 7')

nodes=[
 {'id':'bootstrap','x':640,'y':35,'w':320,'h':110,'title':'bootstrap','lines':['main.dart + app.dart']},
 {'id':'features','x':40,'y':240,'w':410,'h':210,'title':'features','lines':['onboarding / diagnostic / home','skill_map / lesson / quiz / feedback','mastery / progress / mascot']},
 {'id':'state','x':640,'y':260,'w':320,'h':140,'title':'state','lines':['NumiController','Riverpod providers']},
 {'id':'domain','x':1150,'y':240,'w':410,'h':210,'title':'domain','lines':['Diagnostic / SkillMap','LearningPath / Progress','Companion services']},
 {'id':'core','x':40,'y':640,'w':410,'h':150,'title':'core','lines':['config / theme / utils / widgets']},
 {'id':'data','x':640,'y':580,'w':920,'h':230,'title':'data','lines':[]},
 {'id':'models','x':670,'y':660,'w':250,'h':110,'title':'models','lines':['entitas + serialisasi'],'nested':True},
 {'id':'content','x':960,'y':660,'w':250,'h':110,'title':'content','lines':['generator + konten'],'nested':True},
 {'id':'repositories','x':1250,'y':660,'w':280,'h':110,'title':'repositories','lines':['kontrak + adapter lokal'],'nested':True}
]
edges=[
 {'id':'D01','pts':[[800,145],[800,190],[245,190],[245,240]],'label':[330,168]},
 {'id':'D02','pts':[[800,145],[800,260]],'label':[817,215]},
 {'id':'D03','pts':[[450,330],[640,330]],'label':[510,307]},
 {'id':'D04','pts':[[960,330],[1150,330]],'label':[1020,307]},
 {'id':'D05','pts':[[800,400],[800,500],[1390,500],[1390,660]],'label':[1405,560]},
 {'id':'D06','pts':[[1200,450],[1200,540],[795,540],[795,660]],'label':[820,548]},
 {'id':'D07','pts':[[1350,450],[1350,570],[1085,570],[1085,660]],'label':[1095,606]},
 {'id':'D08','pts':[[245,450],[245,640]],'label':[263,554]},
 {'id':'D09','pts':[[960,715],[920,715]],'label':[923,635]},
 {'id':'D10','pts':[[1390,770],[1390,840],[795,840],[795,770]],'label':[1060,845]}
]
(R/'diagram-spec.json').write_text(json.dumps({'width':1600,'height':900,'nodes':nodes,'edges':edges},indent=2),encoding='utf-8')
def diagram(c,x,y,w,h):
    sx=w/1600;sy=h/900
    c.saveState();c.translate(x,y+h);c.scale(sx,-sy)
    def txt(t,x,y,fs=24,b=False,color=INK):
        c.saveState();c.translate(x,y);c.scale(1,-1);c.setFillColor(HexColor(color));c.setFont('Arial-Bold' if b else 'Arial',fs);c.drawString(0,0,t);c.restoreState()
    for n in nodes:
        x0,y0,ww,hh=[n[k] for k in ['x','y','w','h']]
        c.setFillColor(HexColor('#EDF6F2' if n['id']=='data' else '#FFFFFF'));c.setStrokeColor(HexColor(TEAL));c.setLineWidth(2)
        c.rect(x0,y0+22,ww,hh-22,fill=1,stroke=1);c.rect(x0,y0,min(ww-10,180),28,fill=1,stroke=1)
        txt(n['title'],x0+17,y0+59,29,True)
        for i,t in enumerate(n['lines']):txt(t,x0+17,y0+94+i*33,23)
    for e in edges:
        pts=e['pts'];c.setStrokeColor(HexColor(TEAL));c.setDash(9,7);c.setLineWidth(2.4)
        path=c.beginPath();path.moveTo(*pts[0]);[path.lineTo(*pt) for pt in pts[1:]];c.drawPath(path);c.setDash()
        a,b=pts[-2:];angle=math.atan2(b[1]-a[1],b[0]-a[0]);L=16
        for d in [-0.5,0.5]:c.line(*b,b[0]-L*math.cos(angle+d),b[1]-L*math.sin(angle+d))
        txt(e['id'],*e['label'],21,True)
    txt('D01-D10 menunjukkan hubungan utama. Hubungan lengkap ada pada matriks halaman 4.',45,888,23)
    c.restoreState()

diagram_file=R/'package-diagram.pdf';dc=canvas.Canvas(str(diagram_file),pagesize=(1600,900));diagram(dc,0,0,1600,900);dc.save()
d=pdfium.PdfDocument(diagram_file);d[0].render(scale=1.25).to_pil().save(R/'package-diagram.png')
c=canvas.Canvas(str(OUT/C['filename']),pagesize=(W,H));c.setTitle(C['title']);c.setAuthor('Tim Numi')
page(c,1,C['title'],'Tugas kelompok PPL | Teknik Informatika Universitas Padjadjaran | PKG-002 v2.2')
y=H-99;y=para(c,C['purpose'],38,y,W-76)
rows=[['Anggota tim','NPM']]+C['team'];y=table(c,rows,[530,W-76-530],y-7)
y=para(c,'Ruang lingkup dan status',38,y-20,W-76,ParagraphStyle('h',parent=style,fontName='Arial-Bold',fontSize=13,leading=17))
y=para(c,C['scope'],38,y,W-76)
para(c,C['submission'],38,y-8,W-76,small);c.showPage()
page(c,2,'Package diagram Numi','Diagram mengikuti kode yang tersedia. Integrasi Firebase masih direncanakan.')
diagram(c,38,105,W-76,400);para(c,C['legend'],38,94,W-76,small);c.showPage()
page(c,3,'Tugas masing-masing package','Pembagian paket mengikuti peran kode di dalam aplikasi.')
table(c,[['Package','Isi / contoh berkas','Tanggung jawab']]+C['packages'],[112,242,W-76-354],H-97,fs=9)
c.showPage()
page(c,4,'Hubungan antarpackage','Matriks memuat hubungan yang ditemukan pada import Dart lokal. Arah panah: pemakai -> paket yang dipakai.')
matrix=collections_placeholder=None
group={}
for e in E['edges']:group.setdefault(e['from'],[]).append(e['to'])
rows=[['Package pemakai','Package yang dipakai']]+[[k,', '.join(v)] for k,v in group.items()]
y=table(c,rows,[150,W-226],H-97,fs=10)
y=para(c,'Aplikasi memakai flutter, flutter_riverpod, dan shared_preferences. Pada saat pemeriksaan, pubspec.yaml belum memuat dependensi Firebase yang aktif.',38,y-20,W-76)
y=para(c,'Beberapa hubungan masih melewati lapisan secara langsung. features mengimpor domain, model, dan konten, sedangkan domain memakai model serta konten di data. core.widgets memakai model topik, dan data.content memakai core.config. Pemindaian tidak menemukan siklus antarkelompok paket. Pemisahan lapisan masih perlu diperbaiki sebelum struktur ini dapat dinyatakan mengikuti Clean Architecture.',38,y-5,W-76)
para(c,'NumiRepository menyediakan fungsi muat(), simpan(DataBelajar), dan hapus(). Saat ini aplikasi memakai LocalNumiRepository. Adapter Firestore akan ditambahkan setelah rancangan integrasinya siap.',38,y-5,W-76);c.showPage()
page(c,5,'Contoh alur kerja antarpackage','Berikut cara paket-paket tersebut bekerja ketika anak menggunakan aplikasi.')
y=table(c,[['Skenario','Alur kerja']]+C['scenarios'],[165,W-241],H-97,fs=10)
c.showPage()
page(c,6,'Bagian yang masih perlu disesuaikan','Perbandingan kode saat ini dengan rencana kurikulum dan asesmen v2.')
y=table(c,[['Area','Kondisi saat ini','Pekerjaan berikutnya']]+C['gaps'],[90,310,W-476],H-97,fs=9)
c.showPage()
page(c,7,'Kebutuhan yang dilayani dan hasil pemeriksaan','Pemetaan paket membantu tim menelusuri bagian kode yang perlu diubah atau diuji.')
y=table(c,[['Kebutuhan / use case','Package terkait','Tanggung jawab penerimaan']]+C['traceability'],[138,340,W-554],H-97,fs=8.5)
y=para(c,C['test_status'],38,y-15,W-76,small)
y=para(c,'Sumber kode: app/lib/main.dart; state/numi_controller.dart; domain/diagnostic_engine.dart; data/repositories/*.dart; core/config/app_config.dart; features/mastery/mastery_screen.dart; app/pubspec.yaml; firebase/firestore.rules. Snapshot: 28 Oktober 2026. Paket ini tidak mengubah kode aplikasi.',38,y-3,W-76,small)
for label,url in C['references']:
    y=para(c,label+' - '+url,38,y-2,W-76,ParagraphStyle('ref',parent=small,fontSize=7.7,leading=10))
c.save()
pdf=pdfium.PdfDocument(OUT/C['filename'])
for i in range(len(pdf)):pdf[i].render(scale=1.3).to_pil().save(R/f'package-report-{i+1}.png')
print(json.dumps({'pdf':str(OUT/C['filename']),'pages':len(pdf),'diagram':str(R/'package-diagram.png')},ensure_ascii=False))
