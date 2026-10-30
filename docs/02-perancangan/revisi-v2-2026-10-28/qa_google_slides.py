from pathlib import Path
import pypdfium2 as pdfium
from PIL import Image,ImageDraw
import json
r=Path(__file__).parent
b=r/'.google-slides-build'
d=pdfium.PdfDocument(b/'google-native-deck.pdf')
meta=json.loads((r/'google-slides-design-system.json').read_text(encoding='utf-8'))
assert len(d)==12, f'Unexpected page count: {len(d)}'
sheet=Image.new('RGB',(1920,900),'#DCE2DF')
for i in range(len(d)):
    full=d[i].render(scale=4/3).to_pil().convert('RGB')
    full.save(b/f'google-slide-{i+1:02d}.png')
    im=full.copy();im.thumbnail((470,265))
    x=(i%4)*480+5;y=(i//4)*300+5
    sheet.paste(im,(x,y));ImageDraw.Draw(sheet).text((x,y+270),str(i+1),fill='black')
sheet.save(b/'google-slides-contact.png')
print('12 native Google Slides pages rendered')
