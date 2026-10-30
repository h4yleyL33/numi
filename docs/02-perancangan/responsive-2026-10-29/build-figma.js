const sourceIds=['4016:34','4016:82','4016:130','4016:178','4016:226','4016:274'];
const sources=await Promise.all(sourceIds.map(id=>figma.getNodeByIdAsync(id)));
const fonts=new Map();
for(const f of sources)for(const n of f.findAllWithCriteria({types:['TEXT']}))for(const s of n.getStyledTextSegments(['fontName']))fonts.set(JSON.stringify(s.fontName),s.fontName);
await Promise.all([...fonts.values()].map(f=>figma.loadFontAsync(f)));
let page=figma.root.children.find(p=>p.name==='05 · Landscape dan berbagai perangkat');
if(page)return {alreadyExists:true,pageId:page.id};
page=figma.createPage();page.name='05 · Landscape dan berbagai perangkat';
await figma.setCurrentPageAsync(page);
const created=[page.id],frames=[];
function background(name,w,h,x,y){const n=figma.createRectangle();page.appendChild(n);n.name=name;n.resize(w,h);n.x=x;n.y=y;n.fills=sources[0].fills;created.push(n.id);return n;}
const wide=background('Aset latar Numi · landscape 1600×900',1600,900,80,80);
const portrait=background('Aset latar Numi · portrait',851,1847,1760,80);
const configs=[{name:'Ponsel landscape',w:844,h:390,y:2100},{name:'Tablet landscape',w:1024,h:768,y:2800},{name:'Desktop landscape',w:1440,h:900,y:3900}];
for(const c of configs){
 const destinations={};
 const clones=sources.map((s,i)=>{const f=s.clone();page.appendChild(f);f.name=c.name+' · '+s.name;f.resize(c.w,c.h);f.x=80+i*(c.w+100);f.y=c.y;created.push(f.id);destinations[s.id]=f.id;return f;});
 for(const f of clones){
  const parts=[...f.children],pad=c.w<900?24:40,total=Math.min(c.w-pad*2,1160),leftW=c.w<900?250:320,gap=24,rightW=total-leftW-gap;
  const row=figma.createAutoLayout();f.appendChild(row);created.push(row.id);row.name='Tata letak dua kolom';row.layoutMode='HORIZONTAL';row.primaryAxisSizingMode='FIXED';row.counterAxisSizingMode='FIXED';row.resize(total,c.h-pad*2);row.itemSpacing=gap;row.counterAxisAlignItems='CENTER';row.fills=[];row.x=(c.w-total)/2;row.y=pad;
  const header=parts.shift();row.appendChild(header);header.layoutSizingHorizontal='FIXED';header.resize(leftW,header.height);
  for(const t of header.children||[])if(t.type==='TEXT'){t.textAutoResize='HEIGHT';t.resize(leftW-34,t.height);}
  const scroll=figma.createAutoLayout();row.appendChild(scroll);created.push(scroll.id);scroll.name='Isi dapat digulir pada layar pendek';scroll.layoutMode='VERTICAL';scroll.primaryAxisSizingMode='FIXED';scroll.counterAxisSizingMode='FIXED';scroll.resize(rightW,c.h-pad*2);scroll.fills=[];scroll.clipsContent=true;scroll.overflowDirection='VERTICAL';
  const body=figma.createAutoLayout();scroll.appendChild(body);created.push(body.id);body.name='Konten dan aksi';body.layoutMode='VERTICAL';body.primaryAxisSizingMode='AUTO';body.counterAxisSizingMode='FIXED';body.resize(rightW,10);body.itemSpacing=16;body.fills=[];
  for(const n of parts){body.appendChild(n);n.layoutSizingHorizontal='FIXED';n.resize(rightW,n.height);if('layoutMode' in n&&n.layoutMode==='VERTICAL'){n.primaryAxisSizingMode='AUTO';for(const ch of n.children){if(ch.type==='TEXT'){ch.textAutoResize='HEIGHT';ch.resize(rightW-34,ch.height);}else if(ch.type==='FRAME'&&ch.layoutMode==='HORIZONTAL')ch.resize(rightW-34,ch.height);}}}
  function remap(o){if(!o||typeof o!=='object')return o;if(Array.isArray(o))return o.map(remap);const z={};for(const[k,v]of Object.entries(o))z[k]=k==='destinationId'&&destinations[v]?destinations[v]:remap(v);return z;}
  const all=f.findAll(()=>true);for(const n of all)if('reactions' in n&&n.reactions.length)await n.setReactionsAsync(remap(n.reactions));
  const counts={};for(const n of all)counts[n.type]=(counts[n.type]||0)+1;
  frames.push({id:f.id,name:f.name,width:f.width,height:f.height,counts});
 }
}
figma.viewport.scrollAndZoomIntoView(page.children.filter(n=>n.type==='FRAME'&&n.y===2100));
return {pageId:page.id,backgroundId:wide.id,portraitBackgroundId:portrait.id,createdNodeIds:created,frames,fonts:[...fonts.values()]};
