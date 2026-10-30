from pathlib import Path
import json
import pypdfium2 as p
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parent
items=[('doktek','Numi_Dokumentasi_Teknis_v2.2.pdf',12),('proposal','Numi_Proposal_PPL_v2.2.pdf',7),('kurikulum','Numi_Rencana_Kurikulum_v2.1.pdf',8)]
out=[]
for tag,file,tail in items:
 doc=p.PdfDocument('output/pdf/'+file);out.append({'key':tag,'file':file,'pages':len(doc)})
 for batch in range(max(0,len(doc)-tail),len(doc),9):
  count=min(9,len(doc)-batch);sheet=Image.new('RGB',(1050,470*((count+2)//3)),'#dddddd');dr=ImageDraw.Draw(sheet)
  for i in range(batch,min(batch+9,len(doc))):
   page=doc[i];w,h=page.get_size();im=page.render(scale=min(340/w,444/h)).to_pil();x=((i-batch)%3)*350;y=((i-batch)//3)*470;sheet.paste(im,(x,y));dr.text((x+5,y+449),f'{tag} {i+1}',fill='black')
  sheet.save(R/f'qa-native-{tag}-{batch+1}.png')
(R/'updated-document-pdfs.json').write_text(json.dumps(out,indent=2),encoding='utf-8')
print(json.dumps(out));print([f.name for f in R.glob('qa-native*.png')])
