from pathlib import Path
from io import BytesIO
import json
from pypdf import PdfReader, PdfWriter
from reportlab.pdfgen import canvas
import pypdfium2 as pdfium
from PIL import Image, ImageDraw

work=Path(__file__).resolve().parent
out=work.parents[2]/'output/pdf/247001_240003_240007_240009_240045_Package Diagram.pdf'
reader=PdfReader(work/'native.pdf');writer=PdfWriter()
for i,p in enumerate(reader.pages,1):
    if i>1:
        w,h=float(p.mediabox.width),float(p.mediabox.height)
        b=BytesIO();c=canvas.Canvas(b,pagesize=(w,h));c.setFont('Times-Roman',9)
        c.drawString(64,29,'Package Diagram Aplikasi Numi');c.drawRightString(w-64,29,str(i));c.save();b.seek(0)
        p.merge_page(PdfReader(b).pages[0])
    writer.add_page(p)
writer.add_metadata({'/Title':'Package Diagram Aplikasi Numi','/Author':'Kelompok Imun','/Subject':'Kajian pembagian paket dan dependensi aplikasi Numi'})
with out.open('wb') as f:writer.write(f)
d=pdfium.PdfDocument(str(out))
for i,p in enumerate(d):p.render(scale=1.35).to_pil().save(work/f'page-{i+1:02}.png')
for start in range(0,len(d),8):
    sh=Image.new('RGB',(1400,2*500),'#dddddd');dr=ImageDraw.Draw(sh)
    for i in range(start,min(start+8,len(d))):
        im=Image.open(work/f'page-{i+1:02}.png');im.thumbnail((344,474));x=(i-start)%4*350;y=(i-start)//4*500;sh.paste(im,(x,y));dr.text((x+6,y+480),str(i+1),fill='black')
    sh.save(work/f'contact-{start//8+1}.png')
manifest={'file':str(out),'pages':len(d),'bytes':out.stat().st_size}
(work/'pdf-manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print(json.dumps(manifest))
