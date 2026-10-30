import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
import {Presentation,PresentationFile} from 'file:///C:/Users/Khalee/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';

const root=path.dirname(fileURLToPath(import.meta.url));
process.env.RUNTIME_NODE_MODULES='C:/Users/Khalee/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules';
const workspace=path.resolve(root,'../../..');
const build=path.join(root,'.google-slides-build');
const output=path.join(root,'google-slides-output');
await fs.mkdir(build,{recursive:true});await fs.mkdir(output,{recursive:true});
const scene=JSON.parse(await fs.readFile(path.join(root,'figma-deck-scene.json'),'utf8'));
const pres=Presentation.create({slideSize:{width:1280,height:720}});
const S=2/3;
const color=f=>f?.color?'#'+['r','g','b'].map(k=>Math.round(f.color[k]*255).toString(16).padStart(2,'0')).join(''):'none';
const solid=fs=>color((fs||[]).find(f=>f.type==='SOLID'));
const titles=[null,'Pemetaan kemampuan per keterampilan','Alur belajar Numi','Kurikulum dan profil penyajian','Contoh soal untuk tiap tahap','Rancangan layar Numi','Progres dokumentasi dan implementasi','Package diagram aplikasi','Penyimpanan lokal dan rencana cloud','Penyesuaian kode terhadap aturan v2','Rencana kerja berikutnya',null];
const copy=new Map([
 ['Dari rancangan yang jelas\nke pengalaman belajar\nyang teruji.','Prioritas pengembangan:\npenyelarasan kode\ndan validasi materi.'],
 ['Kontrak membantu pergantian adapter.\nSinkronisasi dan konflik data tetap\nmemerlukan desain serta pengujian.','Kontrak ini menjadi dasar penggantian adapter.\nSinkronisasi dan penanganan konflik data\nmasih perlu dirancang serta diuji.']
]);
const imageBytes=await fs.readFile(path.join(root,'figma-v2-preview.png'));
const stats=[];
for(let index=0;index<scene.length;index++){
  const source=scene[index],slide=pres.slides.add();slide.background.fill=solid(source.bg);
  let textCount=0,pathCount=0,imageCount=0;
  for(const n of source.nodes){
    const position={left:n.x*S,top:n.y*S,width:Math.max(.1,n.w*S),height:Math.max(.1,n.h*S)};
    if(n.type==='TEXT'){
      let text=copy.get(n.text)||n.text;
      if(n.y>=125&&n.y<160&&n.fontSize>=60&&titles[index])text=titles[index];
      const shape=slide.shapes.add({geometry:'textbox',name:'text '+n.id,position,fill:'none',line:{fill:'none',width:0,style:'solid'}});
      shape.text=text;
      shape.text.style={typeface:n.font?.family||'Nunito',fontSize:n.fontSize*S,bold:/Bold/i.test(n.font?.style||''),color:solid(n.fills),verticalAlignment:'top',alignment:'left',autoFit:'none',wrap:'square',insets:0,lineSpacing:1.25};
      textCount++;
    }else if(n.type==='VECTOR'){
      const points=[];const commands=[];
      for(const pp of n.paths||[]){
        const matches=[...pp.data.matchAll(/([ML])\s*(-?[\d.e+]+)[ ,]+(-?[\d.e+]+)/gi)];
        for(const m of matches){const x=Number(m[2]),y=Number(m[3]);points.push([x,y]);commands.push({kind:m[1].toUpperCase(),x,y});}
      }
      if(!points.length)continue;
      const minx=Math.min(...points.map(p=>p[0])),miny=Math.min(...points.map(p=>p[1]));
      const pw=Math.max(1,Math.max(...points.map(p=>p[0]))-minx),ph=Math.max(1,Math.max(...points.map(p=>p[1]))-miny);
      slide.shapes.add({geometry:'custom',name:'path '+n.id,position,fill:'none',line:{style:n.dash?.length?'dashed':'solid',fill:solid(n.strokes),width:(n.strokeWeight||3)*S},customPaths:[{width:pw,height:ph,commands:commands.map(c=>({[c.kind==='M'?'moveTo':'lineTo']:{x:c.x-minx,y:c.y-miny}}))}]});
      pathCount++;
    }else{
      const image=(n.fills||[]).find(f=>f.type==='IMAGE');
      if(image){slide.images.add({blob:imageBytes,contentType:'image/png',alt:'Empat contoh layar rancangan Numi v2 dari Figma',fit:'contain',position});imageCount++;continue;}
      const fill=solid(n.fills),stroke=solid(n.strokes);
      if(fill==='none'&&stroke==='none')continue;
      slide.shapes.add({geometry:n.type==='ELLIPSE'?'ellipse':'rect',name:'shape '+n.id,position,fill,line:{style:'solid',fill:stroke,width:stroke==='none'?0:(n.strokeWeight||1)*S},...(n.radius?{borderRadius:n.radius*S}:{})});
    }
  }
  slide.speakerNotes.text=(source.notes||'')+'\n\nSumber materi: https://www.figma.com/slides/ja1YJdxF0DI06sh10a1QG2\nDokumentasi proyek: https://docs.google.com/document/d/1UzoljGfYWE1TbWRikJ7JCbGoUR9Kj-E2YZyS20PCd3Q/edit\nKurikulum: https://docs.google.com/document/d/1h-Edcm0FCujOX1yMsT5pR9TwwBP4oKhZrb004fxJJjY/edit';
  stats.push({slide:index+1,textCount,pathCount,imageCount});
}
await fs.writeFile(path.join(build,'editable-counts.json'),JSON.stringify(stats,null,2));
const candidate=path.join(build,'candidate.pptx');
await(await PresentationFile.exportPptx(pres)).save(candidate);
const SKILL='C:/Users/Khalee/.codex/plugins/cache/openai-primary-runtime/presentations/26.1025.11240/skills/presentations';
const{finalizePresentation}=await import(pathToFileURL(path.join(SKILL,'container_tools/artifact_tool_utils.mjs')).href);
const final=path.join(output,'Numi_Presentasi_Progres_Google_Slides.pptx');
const result=await finalizePresentation({workspaceDir:workspace,candidatePath:candidate,finalPath:final,pythonExecutable:'C:/Users/Khalee/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe',integrityValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_package_integrity.py'),layoutValidatorPath:path.join(SKILL,'container_tools/inspect_presentation_layout_geometry.py'),layoutArgs:['--expected-slide-size-emu','12192000,6858000','--validate-bullet-geometry','--validate-heading-fit'],explicitTotalSlideCount:12,fontPolicy:{basis:'design',families:['Mali','Nunito']},verifyArtifactToolImport:true,receiptPath:path.join(build,'validation.json')});
console.log(JSON.stringify({final,result,slides:stats}));
for(let i=0;i<pres.slides.items.length;i++){
  const blob=await pres.export({slide:pres.slides.items[i],format:'png',scale:1});
  await fs.writeFile(path.join(build,`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await blob.arrayBuffer()));
}
console.log('All 12 slides rendered for local QA');
