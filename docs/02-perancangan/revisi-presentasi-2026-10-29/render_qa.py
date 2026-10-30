from pathlib import Path
import sys,json
import pypdfium2 as pdfium
from PIL import Image,ImageDraw
src=Path(sys.argv[1]); out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=True)
d=pdfium.PdfDocument(str(src))
for i,p in enumerate(d):
    p.render(scale=1.35).to_pil().save(out/f'slide-{i+1:02}.png')
for start in range(0,len(d),6):
    sh=Image.new('RGB',(1440,3*425),'#d7d7d7');dr=ImageDraw.Draw(sh)
    for i in range(start,min(start+6,len(d))):
        im=Image.open(out/f'slide-{i+1:02}.png');im.thumbnail((714,396));x=(i-start)%2*720;y=(i-start)//2*425;sh.paste(im,(x,y));dr.text((x+8,y+400),str(i+1),fill='black')
    sh.save(out/f'contact-{start//6+1}.png')
print(json.dumps({'pages':len(d),'out':str(out)}))
