from pathlib import Path
import pypdfium2 as pdfium
from PIL import Image, ImageOps, ImageDraw

root = Path(__file__).parent
for key in ('doktek', 'proposal', 'kurikulum', 'charter'):
    doc = pdfium.PdfDocument(root / f'{key}-v2.pdf')
    tiles=[]
    for i in range(len(doc)):
        page=doc[i]
        im=page.render(scale=0.45).to_pil().convert('RGB')
        im.thumbnail((290,400))
        tile=Image.new('RGB',(310,430),'#dedede')
        tile.paste(im,((310-im.width)//2,20))
        ImageDraw.Draw(tile).text((12,410),f'{key} — {i+1}', fill='black')
        tiles.append(tile)
        if key=='charter':
            page.render(scale=1.4).to_pil().save(root/f'{key}-page-{i+1}.png')
    for start in range(0,len(tiles),24):
        group=tiles[start:start+24]
        sheet=Image.new('RGB',(310*4,430*((len(group)+3)//4)),'white')
        for j,tile in enumerate(group): sheet.paste(tile,((j%4)*310,(j//4)*430))
        sheet.save(root/f'{key}-contact-{start//24+1}.png')
    print(key,len(doc),'pages')
