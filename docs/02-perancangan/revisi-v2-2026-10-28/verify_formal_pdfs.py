from pathlib import Path
from io import BytesIO
import json
import pypdfium2 as pdfium
from PIL import Image, ImageDraw
from reportlab.pdfgen.canvas import Canvas
from pypdf import PdfReader, PdfWriter

ROOT=Path(__file__).resolve().parent
OUT=ROOT.parents[2]/'output'/'pdf'
# Actual workspace root is three levels above this revision directory.
OUT=Path('output/pdf').resolve()
reader=PdfReader(ROOT/'package-formal-native.pdf')
writer=PdfWriter()
for n,page in enumerate(reader.pages,1):
    w,h=float(page.mediabox.width),float(page.mediabox.height)
    if n>1:
        buf=BytesIO();cv=Canvas(buf,pagesize=(w,h));cv.setFont('Times-Roman',9)
        cv.drawString(64,30,'Numi | PKG-002 | Revisi 2.3')
        cv.drawRightString(w-64,30,str(n));cv.save();buf.seek(0)
        page.merge_page(PdfReader(buf).pages[0])
    writer.add_page(page)
writer.add_metadata({'/Title':'Package Diagram Aplikasi Numi','/Author':'Tim Imun','/Subject':'PKG-002 revisi 2.3 berdasarkan kode 28 Oktober 2026'})
dest=OUT/'247001_240003_240007_240009_240045_Package Diagram.pdf'
with dest.open('wb')as f:writer.write(f)
files=[dest,OUT/'Numi_Dokumentasi_Teknis_v2.1.pdf',OUT/'Numi_Proposal_PPL_v2.1.pdf',OUT/'Numi_Rencana_Kurikulum_v2.pdf',OUT/'Numi_Presentasi_Progres_2026-10-28.pdf',OUT/'Numi_Project_Charter_v2.pdf']
manifest=[]
for file in files:
    doc=pdfium.PdfDocument(str(file));tag=['package','doktek','proposal','kurikulum','progress','charter'][len(manifest)]
    manifest.append({'key':tag,'file':str(file),'pages':len(doc),'size':file.stat().st_size})
    for batch in range(0,len(doc),12):
        portrait=tag!='progress' and tag!='charter'
        cellw,cellh=(300,435)if portrait else(480,290)
        cols=4 if portrait else 2
        rows=(min(12,len(doc)-batch)+cols-1)//cols
        sheet=Image.new('RGB',(cols*cellw,rows*cellh),'#e8e8e8');dr=ImageDraw.Draw(sheet)
        for i in range(batch,min(batch+12,len(doc))):
            pg=doc[i];w,h=pg.get_size();im=pg.render(scale=min((cellw-8)/w,(cellh-24)/h)).to_pil()
            x=((i-batch)%cols)*cellw;y=((i-batch)//cols)*cellh
            sheet.paste(im,(x,y));dr.text((x+5,y+cellh-20),f'{tag} {i+1}',fill='black')
            if tag=='package':pg.render(scale=1.5).to_pil().save(ROOT/f'formal-page-{i+1:02}.png')
        sheet.save(ROOT/f'qa-{tag}-{batch//12+1}.png')
(ROOT/'aligned-pdf-manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print(json.dumps(manifest,indent=2))
