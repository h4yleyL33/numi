from pathlib import Path
import pypdfium2 as pdfium
from PIL import Image,ImageDraw
r=Path(__file__).parent
files=[r/'Package_Diagram_Docs_QA.pdf',r.parents[2]/'output/pdf/Numi_Dokumentasi_Teknis_v2.1.pdf',r.parents[2]/'output/pdf/Numi_Proposal_PPL_v2.1.pdf']
for p in files:
    d=pdfium.PdfDocument(p)
    for start in range(0,len(d),24):
        pages=list(range(start,min(start+24,len(d))))
        sheet=Image.new('RGB',(1280,270*((len(pages)+3)//4)),'#DEE3E0')
        for i,pi in enumerate(pages):
            im=d[pi].render(scale=.37).to_pil().convert('RGB');im.thumbnail((300,245))
            x=(i%4)*320+10;y=(i//4)*270+5
            sheet.paste(im,(x,y));ImageDraw.Draw(sheet).text((x,y+248),f'{pi+1}',fill='black')
        sheet.save(r/f'{p.stem}-qa-{start//24+1}.png')
    print(p.name,len(d),'pages')
