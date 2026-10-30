import json
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from PIL import Image, ImageOps, ImageDraw

root = Path(__file__).parent
shots = json.loads((root / 'screenshots.json').read_text(encoding='utf-8'))
def download(s):
    path = root / ('slide-%02d.png' % s['i'])
    if not path.exists() or path.stat().st_size == 0:
        urllib.request.urlretrieve(s['image_url'], path)
    return path
with ThreadPoolExecutor(max_workers=6) as pool:
    paths = list(pool.map(download, shots))
for start in range(0,len(paths),4):
    group=paths[start:start+4]
    sheet=Image.new('RGB',(2048,1204),'#ddd9cf')
    d=ImageDraw.Draw(sheet)
    for j,path in enumerate(group):
        x=(j%2)*1024;y=(j//2)*602
        d.text((x+12,y+5),'Slide %02d'%(start+j+1),fill='black')
        im=Image.open(path).convert('RGB')
        sheet.paste(im,(x,y+26))
    sheet.save(root/('contact-%02d.png'%(start//4+1)))
print('Downloaded and rendered',len(paths),'slides')
