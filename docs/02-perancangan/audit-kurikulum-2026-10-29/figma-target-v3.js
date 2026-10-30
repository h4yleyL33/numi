// ARSIP generator sebelum keputusan usia. Jangan gunakan sebagai spesifikasi aktif.
// Lihat keputusan-usia-dan-gaya-uml.md dan prototype native terbaru.
const sourcePage=await figma.getNodeByIdAsync('4007:30');
await figma.setCurrentPageAsync(sourcePage);
const base=await figma.getNodeByIdAsync('4007:31');
const cardSource=await figma.getNodeByIdAsync('4007:55');
const textSource=await figma.getNodeByIdAsync('4007:32');
const button=await figma.getNodeByIdAsync('126:999');
const option=await figma.getNodeByIdAsync('126:1376');
const fonts=new Map();
for(const root of [base,button,option])for(const t of root.findAllWithCriteria({types:['TEXT']}))for(const s of t.getStyledTextSegments(['fontName']))fonts.set(JSON.stringify(s.fontName),s.fontName);
for(const f of fonts.values())await figma.loadFontAsync(f);
await figma.loadFontAsync({family:'Mali',style:'Regular'});
await figma.loadFontAsync({family:'Mali',style:'Bold'});
let page=figma.root.children.find(p=>p.name==='04 · Audit kurikulum v3 — Kelas dan alur');
if(page&&page.children.length)throw new Error('Halaman target sudah berisi konten; baca canvas sebelum mengulang.');
if(!page)page=figma.createPage();
page.name='04 · Audit kurikulum v3 — Kelas dan alur';
const created=[page.id],removed=[],mutated=[];
const collection=figma.variables.createVariableCollection('Numi v3 · Simulasi kelas sekolah');
const grade=figma.variables.createVariable('Kelas sekolah',collection,'STRING');grade.scopes=['TEXT_CONTENT'];grade.setValueForMode(collection.modes[0].modeId,'Kelas 3');
const answer=figma.variables.createVariable('Pilihan contoh mastery',collection,'STRING');answer.scopes=['TEXT_CONTENT'];answer.setValueForMode(collection.modes[0].modeId,'Pilih jawabanmu.');
const ink=textSource.fills;
function txt(parent,t,size=16,bold=false,w=280){const n=figma.createText();created.push(n.id);parent.appendChild(n);n.fontName={family:'Mali',style:bold?'Bold':'Regular'};n.fontSize=size;n.lineHeight={unit:'PERCENT',value:135};n.fills=ink;n.characters=t;n.textAutoResize='HEIGHT';n.resize(w,n.height);return n;}
function stack(parent,w=312){const n=figma.createAutoLayout('VERTICAL');created.push(n.id);parent.appendChild(n);n.resize(w,100);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';n.itemSpacing=12;n.paddingTop=n.paddingBottom=n.paddingLeft=n.paddingRight=16;n.fills=cardSource.fills;n.strokes=cardSource.strokes;n.cornerRadius=20;return n;}
async function instance(parent,c,label,w=280,h=52){const n=c.createInstance();created.push(n.id,...n.findAll(()=>true).map(x=>x.id));parent.appendChild(n);n.resize(w,h);const ts=n.findAllWithCriteria({types:['TEXT']});for(const t of ts){for(const s of t.getStyledTextSegments(['fontName']))await figma.loadFontAsync(s.fontName);t.characters=label;mutated.push(t.id);}return n;}
const screens=[];
for(let i=0;i<6;i++){const n=base.clone();page.appendChild(n);created.push(n.id,...n.findAll(()=>true).map(x=>x.id));for(const c of [...n.children]){removed.push(c.id);c.remove();}n.x=80+i*420;n.y=200;n.name=['V3-01 · Profil dan kelas sekolah','V3-02 · Katalog dan batas cakupan','V3-03 · Bukti per keterampilan','V3-04 · Mastery tanpa kunci jawaban','V3-05 · Melanjutkan sesi','V3-06 · Laporan pendamping'][i];n.resize(360,780);screens.push(n);const h=stack(n);h.x=24;h.y=30;txt(h,['Halo, Adi!','Materi belajarmu','Langkah belajarmu','Coba mandiri','Selamat datang kembali','Untuk pendamping'][i],22,true);if(i===1){const g=txt(h,'Kelas 3',14);g.setBoundVariable('characters',grade);}else txt(h,['Pilih kelas sekolahmu.','', 'Setiap keterampilan punya bukti sendiri.','Soal 2 dari 5 · Penjumlahan','Lanjutkan dari tempat berhenti.','Ringkasan per keterampilan'][i],14);}
let s=stack(screens[0]);s.x=24;s.y=175;txt(s,'Nama panggilan: Adi',16,true);txt(s,'Kelas sekolah',16,true);for(let row=0;row<2;row++){const r=figma.createAutoLayout('HORIZONTAL');created.push(r.id);s.appendChild(r);r.fills=[];r.itemSpacing=10;r.resize(280,52);r.primaryAxisSizingMode='FIXED';r.counterAxisSizingMode='FIXED';for(let col=0;col<3;col++){const n=row*3+col+1;const b=await instance(r,option,String(n),86,52);await b.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'SET_VARIABLE',variableId:grade.id,variableValue:{type:'STRING',resolvedType:'STRING',value:'Kelas '+n}},{type:'NODE',destinationId:screens[1].id,navigation:'NAVIGATE',transition:null}]}]);}}
const unknown=await instance(s,button,'Belum tahu');await unknown.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'SET_VARIABLE',variableId:grade.id,variableValue:{type:'STRING',resolvedType:'STRING',value:'Kelas belum ditentukan'}},{type:'NODE',destinationId:screens[1].id,navigation:'NAVIGATE',transition:null}]}]);txt(s,'Kelas membantu memilih awal belajar. Kamu tetap boleh memakai gambar dan belajar materi fondasi.',14);
s=stack(screens[1]);s.x=24;s.y=190;txt(s,'Tersedia sekarang',16,true);txt(s,'Bilangan dan operasi\n12 topik penguatan numerasi.',16);txt(s,'Sedang direncanakan',16,true);txt(s,'Pola dan aljabar lebih lanjut\nPengukuran: luas dan volume\nGeometri\nData dan peluang',14);txt(s,'Materi ini belum bisa dibuka. Numi belum mencakup seluruh Matematika SD.',14);
s=stack(screens[2]);s.x=24;s.y=175;txt(s,'Penjumlahan',17,true);txt(s,'Ada petunjuk siap lanjut\n2 soal awal · 29 Oktober 2026',14);txt(s,'Nilai tempat',17,true);txt(s,'Ayo latihan lagi\nBukti awal masih terbatas',14);txt(s,'Pecahan',17,true);txt(s,'Belum diuji\nBelum ada kesimpulan kemampuan',14);txt(s,'Akses materi: terbuka\nGambar, simbol, dan cerita tersedia.',14);
s=stack(screens[3]);s.x=24;s.y=180;txt(s,'8 + □ = 13',28,true);const row=figma.createAutoLayout('HORIZONTAL');created.push(row.id);s.appendChild(row);row.fills=[];row.itemSpacing=8;row.resize(280,52);for(const val of ['4','5','6','7']){const o=await instance(row,option,val,62,52);await o.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'SET_VARIABLE',variableId:answer.id,variableValue:{type:'STRING',resolvedType:'STRING',value:'Jawaban dipilih: '+val}}]}]);}const at=txt(s,'Pilih jawabanmu.',14);at.setBoundVariable('characters',answer);txt(s,'Pembahasan akan muncul setelah lima soal selesai. Kamu bisa mengubah pilihan sebelum mengirim.',14);
s=stack(screens[4]);s.x=24;s.y=175;txt(s,'Sesi latihan tersimpan',18,true);txt(s,'Penjumlahan · Soal berikutnya 3/5\nRespons sebelumnya sudah tercatat.\nButir dan urutan tetap sama.',15);txt(s,'Jika penyimpanan gagal, muncul Coba lagi. Aplikasi tidak menjanjikan sesi tersimpan sebelum proses berhasil.',14);
s=stack(screens[5]);s.x=24;s.y=175;txt(s,'Penjumlahan sampai 20',18,true);txt(s,'Bukti awal tercapai\n5/5 respons pertama · tanpa petunjuk\n29 Oktober 2026',14);txt(s,'Pemeriksaan ulang',17,true);txt(s,'Direncanakan 3–7 hari setelah tes. Keputusan mengikuti kebijakan pilot yang masih perlu validasi.',14);txt(s,'Luas dan volume',17,true);txt(s,'Belum tersedia pada MVP ini. Tidak dimasukkan dalam persentase penguasaan.',14);
const labels=['','Mulai dari saran belajar','Coba mandiri','Kirim jawaban','Lihat ringkasan contoh','Kembali ke materi'];
for(let i=1;i<6;i++){const f=figma.createAutoLayout('VERTICAL');created.push(f.id);screens[i].appendChild(f);f.fills=[];f.x=24;f.y=690;f.resize(312,60);f.primaryAxisSizingMode='FIXED';f.counterAxisSizingMode='FIXED';const b=await instance(f,button,labels[i],312,60);await b.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'NODE',destinationId:screens[i===5?1:i+1].id,navigation:'NAVIGATE',transition:null}]}]);}
const heading=txt(page,'Numi v3 · Kelas sekolah, cakupan, bukti belajar, dan sesi tersimpan',28,true,2500);heading.x=80;heading.y=60;
const note=txt(page,'Rancangan target untuk ditinjau tim. Pilihan kelas 1–6 dapat dicoba pada prototype. Perilaku simpan dan asesmen di layar ini adalah simulasi; kode aplikasi belum diperbarui.',16,false,2500);note.x=80;note.y=112;
for(let i=0;i<6;i++){const n=txt(page,screens[i].name,16,true,360);n.x=screens[i].x;n.y=1010;}
return {pageId:page.id,screenIds:screens.map(n=>n.id),createdNodeIds:created,mutatedNodeIds:mutated,removedNodeIds:removed,variableIds:[grade.id,answer.id],count:screens.length};
