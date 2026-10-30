from pathlib import Path
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
import pypdfium2 as pdfium
from PIL import Image, ImageDraw

r=Path(__file__).parent
out=r.parents[2]/'output/pdf/Numi_Presentasi_Progres_2026-10-28.pdf'
c=canvas.Canvas(str(out),pagesize=(960,540))
c.setTitle('Numi - Presentasi Progres dan Package Diagram - 28 Oktober 2026')
c.setAuthor('Tim Numi')
for i in range(1,13):
    c.drawImage(ImageReader(r/f'slide-{i:02d}.png'),0,0,width=960,height=540)
    c.showPage()
c.save()
doc=pdfium.PdfDocument(out)
contact=Image.new('RGB',(1920,900),'#D9DFDD')
for i in range(len(doc)):
    im=doc[i].render(scale=.49).to_pil().convert('RGB')
    x=(i%4)*480+5;y=(i//4)*300+5
    contact.paste(im,(x,y));ImageDraw.Draw(contact).text((x,y+270),str(i+1),fill='black')
contact.save(r/'presentation-pdf-contact.png')
print(str(out),len(doc),'pages')
