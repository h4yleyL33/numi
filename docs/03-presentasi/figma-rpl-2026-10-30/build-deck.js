// Native, editable presentation frames in the existing Numi Design file.
const pageName = '04 Presentasi RPL Numi';
const existing = figma.root.children.find(p => p.name === pageName);
if (existing) return { alreadyExists: true, pageId: existing.id, frames: existing.children.filter(n=>n.type==='FRAME').map(n=>({id:n.id,name:n.name})) };
const sourceIds=['115:322','116:301','117:987','117:1001','118:869','116:509'];
const sources=await Promise.all(sourceIds.map(id=>figma.getNodeByIdAsync(id)));
const sourceFonts=new Map();
for(const f of sources)for(const t of f.findAllWithCriteria({types:['TEXT']}))for(const s of t.getStyledTextSegments(['fontName']))sourceFonts.set(JSON.stringify(s.fontName),s.fontName);
for(const f of [{family:'Cabin Sketch',style:'Bold'},{family:'Mali',style:'Medium'},{family:'Mali',style:'SemiBold'},{family:'Mali',style:'Bold'},{family:'Nunito',style:'Regular'},{family:'Nunito',style:'Bold'}])sourceFonts.set(JSON.stringify(f),f);
await Promise.all([...sourceFonts.values()].map(f=>figma.loadFontAsync(f)));
const variableNames={ink:'123:989',muted:'123:991',sea:'123:981',orange:'123:983',butter:'123:985',white:'123:1003',line:'123:1005',green:'123:993',coral:'123:997',lavender:'123:1001'};
const vars={};for(const [k,id]of Object.entries(variableNames))vars[k]=await figma.variables.getVariableByIdAsync('VariableID:'+id);
const comps={};for(const [k,id]of Object.entries({happy:'126:975',think:'126:977',cheer:'126:979',sleepy:'126:981',stone:'126:983',palm:'126:985',rainbow:'126:987',fog:'126:989',light:'126:991',darkLight:'126:993',apple:'126:995',cloud:'126:997'}))comps[k]=await figma.getNodeByIdAsync(id);
const page=figma.createPage();page.name=pageName;await figma.setCurrentPageAsync(page);
const made=[page.id],slides=[],cards={},usedAssets=new Set(),checks=[];
const W=1920,H=1080,ink={r:.14117648,g:.3019608,b:.31764707},white={r:1,g:.99215686,b:.9607843};
function reg(n){made.push(n.id);return n;}
function paint(k,opacity=1){if(k==='black')return {type:'SOLID',color:{r:0,g:0,b:0},opacity};const p={type:'SOLID',color:k==='white'?white:ink,opacity};return vars[k]?figma.variables.setBoundVariableForPaint(p,'color',vars[k]):p;}
function rect(parent,x,y,w,h,key='white',radius=0){const n=reg(figma.createRectangle());parent.appendChild(n);n.resize(w,h);n.x=x;n.y=y;n.fills=[paint(key)];n.cornerRadius=radius;return n;}
function tx(parent,str,w,size=30,key='ink',font='body'){const t=reg(figma.createText());t.fontName=font==='title'?{family:'Cabin Sketch',style:'Bold'}:font==='bold'?{family:'Mali',style:'Bold'}:font==='uml'?{family:'Nunito',style:'Regular'}:font==='umlbold'?{family:'Nunito',style:'Bold'}:{family:'Mali',style:'Medium'};t.fontSize=size;t.characters=str;t.lineHeight={unit:'PERCENT',value:135};t.resize(w,10);t.fills=[paint(key)];parent.appendChild(t);t.textAutoResize='HEIGHT';return t;}
function txt(parent,str,x,y,w,size=30,key='ink',font='body'){const n=tx(parent,str,w,size,key,font);n.x=x;n.y=y;return n;}
function stack(parent,x,y,w,gap=18){const f=reg(figma.createAutoLayout('VERTICAL'));parent.appendChild(f);f.fills=[];f.resize(w,10);f.primaryAxisSizingMode='AUTO';f.counterAxisSizingMode='FIXED';f.itemSpacing=gap;f.x=x;f.y=y;return f;}
function art(parent,k,x,y,size){const n=reg(comps[k].createInstance());parent.appendChild(n);n.resize(size,size);n.x=x;n.y=y;usedAssets.add(comps[k].id);return n;}
function bg(parent,opacity=.09){const n=reg(figma.createRectangle());parent.appendChild(n);n.name='Latar Samudra Angka asli';n.resize(W,H);n.fills=[{type:'IMAGE',imageHash:'ce0722de8954485e3e2d77c24737f32687a411c2',scaleMode:'CROP',imageTransform:[[1,0,0],[0,851/(W/H)/1847,.56]],opacity}];return n;}
function slide(num,title,sub,kind='light'){
 const f=reg(figma.createFrame());page.appendChild(f);f.name=String(num).padStart(2,'0')+' '+title;f.resize(W,H);f.x=240+((num-1)%3)*(W+160);f.y=240+Math.floor((num-1)/3)*(H+160);f.fills=[paint(kind==='dark'?'ink':'white')];f.clipsContent=true;bg(f,kind==='dark'?.13:.075);
 if(num!==1){const hd=stack(f,88,64,1744,10);tx(hd,title,1744,64,kind==='dark'?'white':'ink','title');if(sub)tx(hd,sub,1744,28,kind==='dark'?'white':'muted');}
 const ft=txt(f,'NUMI  /  REKAYASA PERANGKAT LUNAK',88,1023,1400,20,kind==='dark'?'white':'muted');ft.name='Identitas presentasi';txt(f,String(num).padStart(2,'0')+' / 21',1704,1021,130,23,kind==='dark'?'white':'muted','bold');slides.push(f);return f;
}
function note(f,str,y=939,key='ink'){const p=stack(f,88,y,1744,0);p.paddingLeft=24;p.paddingRight=24;p.paddingTop=13;p.paddingBottom=13;p.fills=[paint(key==='white'?'ink':'butter',.94)];p.cornerRadius=12;tx(p,str,1696,25,key);return p;}
function block(f,title,body,x,y,w=790,size=32,color='ink'){const a=stack(f,x,y,w,18);tx(a,title,w,43,color,'title');tx(a,body,w,size,color);return a;}
function makeCard(name,w,h,titleSize,bodySize){const c=reg(figma.createComponent());page.appendChild(c);c.name='Presentasi / '+name;c.resize(w,h);c.layoutMode='VERTICAL';c.primaryAxisSizingMode='FIXED';c.counterAxisSizingMode='FIXED';c.paddingTop=24;c.paddingBottom=24;c.paddingLeft=28;c.paddingRight=28;c.itemSpacing=14;c.fills=[paint('white')];c.strokes=[paint('line')];c.strokeWeight=1.5;c.cornerRadius=16;c.x=240+Object.keys(cards).length*650;c.y=9300;c.description='Panel isi presentasi Numi. Judul dan isi dapat diubah melalui properti teks.';const t=tx(c,'Judul',w-56,titleSize,'ink','bold');const b=tx(c,'Isi',w-56,bodySize);t.layoutSizingHorizontal='FILL';b.layoutSizingHorizontal='FILL';const tp=c.addComponentProperty('Judul','TEXT','Judul');const bp=c.addComponentProperty('Isi','TEXT','Isi');t.componentPropertyReferences={characters:tp};b.componentPropertyReferences={characters:bp};cards[name]={c,tp,bp};return cards[name];}
makeCard('UCDC lengkap',568,234,27,20);
makeCard('UCDC detail',836,300,34,28);
makeCard('UCDC ringkas',544,330,32,25);
function card(f,key,title,body,x,y,color='white'){const q=cards[key];const n=reg(q.c.createInstance());f.appendChild(n);n.x=x;n.y=y;n.setProperties({[q.tp]:title,[q.bp]:body});n.fills=[paint(color)];return n;}
function path(f,pts,dashed=false,arrow=false,color='black',weight=2){const v=reg(figma.createVector());f.appendChild(v);const minX=Math.min(...pts.map(p=>p[0])),minY=Math.min(...pts.map(p=>p[1]));v.vectorPaths=[{windingRule:'NONE',data:pts.map((p,i)=>(i?'L ':'M ')+(p[0]-minX)+' '+(p[1]-minY)).join(' ')}];v.x=minX;v.y=minY;v.fills=[];v.strokes=[paint(color)];v.strokeWeight=weight;if(dashed)v.dashPattern=[9,7];if(arrow){const a=pts[pts.length-2],b=pts[pts.length-1],dx=b[0]-a[0],dy=b[1]-a[1],l=Math.hypot(dx,dy),ux=dx/l,uy=dy/l;path(f,[[b[0]-ux*14-uy*7,b[1]-uy*14+ux*7],b,[b[0]-ux*14+uy*7,b[1]-uy*14-ux*7]],false,false,color,weight);}return v;}
function ellipse(f,x,y,w,h,filled=false){const n=reg(figma.createEllipse());f.appendChild(n);n.resize(w,h);n.x=x;n.y=y;n.fills=[paint(filled?'black':'white')];n.strokes=[paint('black')];n.strokeWeight=2;return n;}
function umlBox(f,label,x,y,w,h=84,round=0){const n=rect(f,x,y,w,h,'white',round);n.strokes=[paint('black')];n.strokeWeight=2;const t=txt(f,label,x+14,y+12,w-28,27,'black','uml');t.textAlignHorizontal='CENTER';return n;}
function actor(f,label,cx,y){ellipse(f,cx-18,y,36,36);path(f,[[cx,y+36],[cx,y+100]]);path(f,[[cx-38,y+58],[cx+38,y+58]]);path(f,[[cx-30,y+142],[cx,y+100],[cx+30,y+142]]);const t=txt(f,label,cx-100,y+156,200,29,'black','umlbold');t.textAlignHorizontal='CENTER';}
function nativeScreen(f,source,x,y,h){const n=reg(source.clone());f.appendChild(n);n.name='Layar asli Numi / '+source.name;n.rescale(h/source.height);n.x=x;n.y=y;usedAssets.add(source.id);for(const t of n.findAllWithCriteria({types:['TEXT']})){if(t.characters==='🛡️ Data tersimpan aman di perangkat ini')t.characters='Data belajar disimpan di perangkat ini';}return n;}
const ucdc=[
 ['1. Produk','Aplikasi penguatan numerasi untuk anak usia 6 sampai 12 tahun. Materi mengikuti kebutuhan tiap keterampilan. Versi awal berisi 12 topik dari sebagian capaian fase A sampai C. Materi dan soal perlu validasi guru.'],
 ['2. Pengguna','Anak usia 6 sampai 12 tahun yang membutuhkan latihan numerasi. Profil cukup berisi nama panggilan dan usia. Wali membantu anak belajar. Guru atau ahli materi memeriksa kesesuaian isi.'],
 ['3. Masalah','Kemampuan anak bisa berbeda antar materi. Umur saja belum cukup untuk memilih latihan. Salah konsep perlu dibedakan dari salah membaca atau memakai aplikasi. Kebutuhan ini masih perlu diperiksa bersama pengguna.'],
 ['4. Alasan anak belajar','Anak ingin memahami soal dan tahu harus belajar apa setelahnya. Anak perlu ruang untuk mencoba tanpa takut salah. Hadiah dan cerita diharapkan membantu anak tertarik belajar. Pengaruhnya perlu diuji.'],
 ['5. Kekhawatiran','Anak takut dianggap tertinggal, bingung membaca petunjuk atau memakai gerakan seret, dan mudah frustrasi saat soal terlalu sulit atau berulang. Anak dan wali juga khawatir hasil belajar hilang.'],
 ['6. Solusi','Pemetaan kemampuan tiap keterampilan, latihan sesuai kebutuhan, lalu pemeriksaan mandiri. Gambar, angka, dan cerita dapat dipakai sesuai kebutuhan anak. Simpan tiap jawaban masih rancangan. Kode awal menyimpan data lokal.'],
 ['7. Pilihan yang sudah ada','Belajar bersama guru atau wali, les privat, buku latihan, dan aplikasi matematika. Bahan kajian mencakup White Rose, Khan Academy, dan NRICH. Beberapa aplikasi lain juga menyesuaikan latihan.'],
 ['8. Fokus pembeda','Catatan kemampuan per keterampilan dan latihan penguatan sesuai prasyarat. Usia membantu memilih bahasa awal. Bantuan belajar mengikuti kebutuhan anak. Keunggulan Numi dibanding aplikasi lain masih perlu diuji.'],
 ['9. Manfaat untuk pengguna','Anak mendapat arahan belajar berdasarkan hasil pengerjaannya, dengan bantuan saat perlu. Wali dapat melihat bukti kemampuan. Hasil uji menjadi catatan awal bertanggal dan perlu diperiksa kembali. Dampak belajar belum diuji.']
];
// 01: cover.
{
 const f=slide(1,'Numi','','dark');const p=rect(f,88,92,1055,840,'white',30);p.opacity=.97;const a=stack(f,136,132,940,18);tx(a,'Numi',940,144,'ink','title');tx(a,'Belajar berhitung lewat\npetualangan pulau',940,48,'ink','title');tx(a,'Aplikasi numerasi untuk anak usia 6 sampai 12 tahun',940,28);tx(a,'Presentasi proyek RPL\nKelompok Imun',940,24,'muted');tx(a,'Alfrandiano Imanuel Rionaldo Holle  140810247001\nYarfi Setya Nugraha  140810240003\nKhalit Putra Afana  140810240007\nMuhammad Andri Firmansyah  140810240009\nNabil Rizky Aulia Utomo  140810240045',940,22);art(f,'happy',1240,220,490);art(f,'light',1320,735,210);
}
// 02: description and needs.
{
 const f=slide(2,'Kenalan dengan Numi','Belajar numerasi melalui cerita, contoh, dan latihan singkat.');
 block(f,'Apa yang ingin dibantu?','Anak yang sudah lancar menjumlahkan belum tentu paham pecahan.\n\nPilihan latihan perlu melihat hasil pengerjaan anak pada setiap materi.',88,280,850,39);art(f,'think',1380,230,300);
 const a=stack(f,1040,575,750,20);tx(a,'Di dalam Numi',750,43,'ink','title');tx(a,'Anak mengenal cerita pulau, mencoba soal awal, lalu mendapat arahan materi dan latihan.\n\nWali dapat mendampingi dan melihat jejak belajarnya.',750,32);note(f,'Kebutuhan pengguna ini menjadi dasar rancangan dan perlu diperiksa lewat uji pengguna.');
}
// 03: objectives / scope.
{
 const f=slide(3,'Tujuan dan batas aplikasi','Supaya cakupan proyek tetap jelas dan bisa dikerjakan.');
 block(f,'Yang ingin dicapai','Membantu anak memahami numerasi dasar.\n\nMemberi latihan yang sesuai kebutuhan.\n\nMembantu wali memahami bagian yang perlu dilatih.',88,278,800,36);
 const a=stack(f,1020,280,790,18);tx(a,'Batas versi awal',790,45,'ink','title');for(const s of ['Pengguna berusia 6 sampai 12 tahun.','Profil memakai nama panggilan dan usia.','Materi awal berisi 12 topik numerasi.','Data belajar disimpan pada perangkat.'])tx(a,s,790,34);
 note(f,'Cakupan saat ini belum mencakup seluruh matematika SD, termasuk luas, volume, geometri, dan data.');
}
// 04: competitors, editable table.
{
 const f=slide(4,'Aplikasi yang sudah ada','Numi mengambil pelajaran dari produk yang sudah lebih dulu dipakai.');
 const columns=[{w:490,k:'Khan Academy Kids',body:'Anak usia 2 sampai 8 tahun.\n\nKegiatan matematika, membaca, dan bidang lain.\n\nBelajar melalui permainan dan jalur kegiatan.'},{w:490,k:'Matific',body:'Pembelajaran matematika dengan kegiatan interaktif.\n\nMemiliki jalur belajar adaptif.\n\nMenyediakan informasi perkembangan belajar.'},{w:570,k:'Numi',body:'Anak usia 6 sampai 12 tahun.\n\nFokus awal 12 topik numerasi.\n\nCerita pulau, latihan, dan catatan kemampuan per keterampilan sebagai arah rancangan.'}];
 let x=88;for(const c of columns){const a=stack(f,x,285,c.w,24);a.paddingTop=24;a.paddingLeft=28;a.paddingRight=28;a.paddingBottom=30;a.fills=[paint(c.k==='Numi'?'butter':'white')];a.cornerRadius=16;tx(a,c.k,c.w-56,40,'ink','title');tx(a,c.body,c.w-56,31);x+=c.w+50;}
 const s=txt(f,'Sumber: khanacademy.org/kids  dan  matific.com',88,887,1744,23,'muted');s.setRangeHyperlink(8,28,{type:'URL',value:'https://www.khanacademy.org/kids'});note(f,'Matific sudah adaptif. Penyesuaian latihan saja belum cukup menjadi pembeda Numi.');
}
// 05: positioning.
{
 const f=slide(5,'Fokus yang dipilih Numi','Pendekatan proyek yang akan diuji bersama pengguna.','dark');
 block(f,'Materi dekat dengan anak','Bahasa Indonesia, contoh sehari-hari, dan rujukan capaian pembelajaran matematika Indonesia.',88,280,1000,37,'white');
 block(f,'Belajar lewat petualangan','Pulau mewakili materi. Contoh dan latihan membantu anak melanjutkan petualangan sambil belajar.',88,525,1000,37,'white');
 block(f,'Kemampuan dilihat per materi','Anak bisa kuat di satu materi dan masih butuh bantuan di materi lain.',88,770,1000,35,'white');art(f,'rainbow',1370,340,350);art(f,'cheer',1470,670,230);
}
// 06 full UCDC.
{
 const f=slide(6,'UCDC lengkap','Sembilan bagian yang menjadi dasar rancangan Numi.');
 for(let i=0;i<9;i++)card(f,'UCDC lengkap',ucdc[i][0],ucdc[i][1],88+(i%3)*588,238+Math.floor(i/3)*250,i===0?'butter':'white');
 txt(f,'Isi canvas merupakan dugaan kebutuhan dan arah solusi. Validasi pengguna dan materi masih diperlukan.',88,1000,1640,20,'muted');
}
// 07 full detail first four.
{
 const f=slide(7,'UCDC: produk dan pengguna','Perbesaran bagian 1 sampai 4 dari canvas.');
 for(let i=0;i<4;i++)card(f,'UCDC detail',ucdc[i][0],ucdc[i][1],88+(i%2)*876,260+Math.floor(i/2)*326,i===0?'butter':'white');
}
// 08 all five remaining, no omissions.
{
 const f=slide(8,'UCDC: solusi dan manfaat','Perbesaran bagian 5 sampai 9 dari canvas.');
 for(let i=0;i<5;i++)card(f,'UCDC ringkas',ucdc[i+4][0],ucdc[i+4][1],88+(i%3)*600,255+Math.floor(i/3)*352,i===1?'butter':'white');art(f,'cheer',1450,660,230);
}
// 09 actors.
{
 const f=slide(9,'Siapa yang memakai Numi?','Batas peran pada rancangan aplikasi.');
 block(f,'Anak','Mengisi profil dengan bantuan bila perlu, mengerjakan soal, mengikuti materi, dan melihat hasil belajar.',88,295,750,37);art(f,'happy',1400,240,280);
 block(f,'Orang tua atau wali','Membantu anak memakai aplikasi dan membaca ringkasan belajarnya pada perangkat keluarga.',88,590,750,37);
 block(f,'Guru atau ahli materi','Memeriksa tujuan belajar, bahasa soal, jawaban, dan urutan materi. Kegiatan ini berada di luar aplikasi.',1050,590,730,33);
 note(f,'Aktor aplikasi: anak dan wali. Portal guru serta admin konten belum masuk lingkup versi awal.');
}
// 10 FR.
{
 const f=slide(10,'Apa saja yang harus bisa dilakukan?','Analisis kebutuhan fungsional pada rancangan Numi.');
 const rows=[['FR-01','Profil anak','Nama panggilan dan usia 6 sampai 12 tahun.'],['FR-02','Pemetaan awal','Mencatat jawaban dan kebutuhan latihan per keterampilan.'],['FR-03','Peta belajar','Menampilkan materi, prasyarat, dan rekomendasi.'],['FR-04','Materi dan latihan','Memberi contoh, bantuan, dan pembahasan saat belajar.'],['FR-05','Uji penguasaan','Mencatat hasil uji pada keterampilan yang diperiksa.'],['FR-06','Catatan belajar','Menyimpan hasil dan menampilkan ringkasan untuk anak/wali.']];
 const a=stack(f,88,260,1744,0);for(let i=0;i<rows.length;i++){const row=reg(figma.createAutoLayout('HORIZONTAL'));a.appendChild(row);row.resize(1744,104);row.primaryAxisSizingMode='FIXED';row.counterAxisSizingMode='FIXED';row.paddingTop=18;row.paddingBottom=18;row.paddingLeft=20;row.itemSpacing=26;row.fills=[paint(i%2?'white':'sea',i%2?1:.2)];tx(row,rows[i][0],150,28,'muted','bold');tx(row,rows[i][1],365,31,'ink','bold');tx(row,rows[i][2],1110,30);}
 note(f,'Nomor kebutuhan dipakai sebagai penanda dalam presentasi. Rincian setiap fitur dijelaskan di doktek.');
}
// 11 NFR.
{
 const f=slide(11,'Bagaimana aplikasi seharusnya bekerja?','Analisis kebutuhan nonfungsional dan cara memeriksanya.');
 const data=[['Mudah dipahami','Anak bisa membaca instruksi dan mengetahui tombol berikutnya.','Amati saat anak memakai aplikasi.'],['Nyaman di berbagai layar','Konten tetap terbaca dan tombol dapat dijangkau.','Cek ponsel, tablet, desktop, dan teks besar.'],['Data tetap konsisten','Hasil yang tersimpan dapat dimuat kembali.','Uji tutup-buka aplikasi serta kegagalan simpan.'],['Data anak secukupnya','Profil cukup memakai nama panggilan dan usia.','Periksa kolom profil dan data yang disimpan.']];
 for(let i=0;i<4;i++){const a=stack(f,88+(i%2)*900,270+Math.floor(i/2)*330,810,16);tx(a,data[i][0],810,42,'ink','title');tx(a,data[i][1],810,32);tx(a,'Cara cek: '+data[i][2],810,27,'muted');}
}
// 12 software responsibilities.
{
 const f=slide(12,'Pakai apa di bagian mana?','Teknologi yang ada pada kode dan alat bantu perancangan.');
 const rows=[['Flutter + Dart','Layar, navigasi, dan logika aplikasi.'],['Riverpod','Mengatur data dan perubahan tampilan.'],['SharedPreferences','Menyimpan profil dan hasil belajar lokal sebagai JSON.'],['Figma','UCDC, desain layar, dan contoh alur pengguna.'],['PlantUML','Menulis dan memperbarui diagram sistem.'],['Flutter Test','Menguji logika serta interaksi tampilan.']];const a=stack(f,88,262,1080,0);for(const [k,v]of rows){const r=reg(figma.createAutoLayout('HORIZONTAL'));a.appendChild(r);r.resize(1080,100);r.primaryAxisSizingMode='FIXED';r.counterAxisSizingMode='FIXED';r.paddingTop=15;r.itemSpacing=26;r.fills=[];tx(r,k,330,30,'ink','bold');tx(r,v,720,29);}
 art(f,'think',1370,300,270);block(f,'Alur data','Layar berkomunikasi dengan controller. Logika belajar memakai layanan domain. Repository mengurus penyimpanan.',1240,620,570,31);note(f,'Versi kode sekarang memakai penyimpanan lokal. Firebase belum digunakan.');
}
// 13 curriculum.
{
 const f=slide(13,'Kurikulum yang dipakai','Capaian Pembelajaran Matematika, fase A sampai C.');
 const a=stack(f,88,260,900,20);tx(a,'Acuan utama',900,45,'ink','title');tx(a,'Kurikulum Merdeka\nCP Matematika BSKAP\nNomor 046/H/KR/2025',900,40,'ink','bold');tx(a,'Numi mengambil sebagian materi bilangan dan hitungan sebagai cakupan awal.',900,33);tx(a,'Fase dipakai untuk memetakan tujuan materi. Profil aplikasi tetap berdasarkan usia.',900,31);
 block(f,'Kenapa memilih acuan ini?','Dekat dengan pembelajaran anak di Indonesia.\n\nTujuan tiap materi bisa ditelusuri.\n\nUrutan materi dan prasyarat lebih mudah diperiksa bersama guru.',1070,275,735,34);
 const s=txt(f,'Acuan: Ruang GTK Kemendikdasmen, CP BSKAP 046/H/KR/2025.',88,875,1744,24,'muted');s.hyperlink={type:'URL',value:'https://guru.kemendikdasmen.go.id/dokumen/74r6Yln0zK'};note(f,'Umur membantu titik awal. Hasil pengerjaan anak menentukan kebutuhan latihan selanjutnya.');
}
// 14 proposed age timeline.
{
 const f=slide(14,'Gambaran materi usia 6 sampai 12 tahun','Panduan awal penyajian Numi. Urutan bisa berubah sesuai hasil pengerjaan anak.');
 const xs=[88,338,588,838,1088,1338,1588];
 const data=[['6','Mengenal angka\ndan jumlah','Hitung 8 apel.'],['7','Satuan, puluhan,\ntambah dan kurang','24 = 2 puluhan\ndan 4 satuan.'],['8','Hitungan lebih besar\ndan awal perkalian','4 piring, masing-\nmasing 3 kue.'],['9','Pembagian rata\ndan bagian benda','24 kue dibagi\nkepada 6 anak.'],['10','Soal cerita dan\npecahan senilai','Setengah sama\ndengan 2 per 4.'],['11','Hitungan pecahan,\nkelipatan dan faktor','Setengah ditambah\nseperempat.'],['12','Gabungan hitungan,\nKPK dan FPB','Kapan dua jadwal\nbertemu lagi?']];
 path(f,[[168,405],[1730,405]],false,false,'ink',5);
 for(let i=0;i<7;i++){const n=reg(figma.createEllipse());f.appendChild(n);n.resize(100,100);n.x=xs[i]+55;n.y=355;n.fills=[paint(i%2?'butter':'sea')];const t=txt(f,data[i][0],xs[i]+55,374,100,39,'ink','bold');t.textAlignHorizontal='CENTER';const tt=txt(f,'tahun',xs[i],472,210,26,'muted');tt.textAlignHorizontal='CENTER';const b=txt(f,data[i][1],xs[i],540,222,29,'ink','bold');b.textAlignHorizontal='CENTER';const e=txt(f,data[i][2],xs[i],750,222,25);e.textAlignHorizontal='CENTER';}
 txt(f,'Pecahan sederhana dapat dikenalkan lebih awal lewat gambar setengah dan seperempat.',88,875,1744,26,'muted');
 note(f,'Usia pada timeline adalah usulan penyajian, bukan batas kemampuan atau pembagian umur resmi dari kurikulum.');
}
// 15 use cases.
{
 const f=slide(15,'UML: siapa melakukan apa?','Use case diagram untuk rancangan aplikasi pada perangkat keluarga.');
 const bound=rect(f,420,255,1080,640,'white',0);bound.strokes=[paint('black')];bound.strokeWeight=2;txt(f,'Numi',445,272,300,28,'black','umlbold');
 actor(f,'Anak',230,455);actor(f,'Wali',1690,455);
 const labels=['Mengisi profil','Mengerjakan pemetaan awal','Mengikuti materi dan latihan','Mengerjakan uji penguasaan','Melihat catatan belajar'];
 for(let i=0;i<5;i++){const y=332+i*105;ellipse(f,690,y,550,78);const t=txt(f,labels[i],710,y+18,510,28,'black','uml');t.textAlignHorizontal='CENTER';path(f,[[270,540],[490,540],[490,y+39],[690,y+39]]);if([0,2,4].includes(i))path(f,[[1240,y+39],[1430,y+39],[1430,540],[1650,540]]);}
 note(f,'Wali membantu profil dan kegiatan belajar, lalu membaca catatan anak. Guru memvalidasi materi di luar aplikasi.');
}
// 16 activity.
{
 const f=slide(16,'UML: alur belajar anak','Activity diagram yang merangkum alur rancangan.');
 ellipse(f,118,300,24,24,true);umlBox(f,'Isi atau buka profil',210,270,320);umlBox(f,'Pemetaan awal',650,270,320);umlBox(f,'Peta dan rekomendasi',1090,270,390);
 path(f,[[142,312],[210,312]],false,true);path(f,[[530,312],[650,312]],false,true);path(f,[[970,312],[1090,312]],false,true);
 umlBox(f,'Materi dan latihan\ndengan bantuan',1090,465,390,110,18);path(f,[[1285,354],[1285,465]],false,true);
 const d=reg(figma.createVector());f.appendChild(d);d.vectorPaths=[{windingRule:'NONZERO',data:'M 100 0 L 200 65 L 100 130 L 0 65 Z'}];d.x=1185;d.y=650;d.fills=[paint('white')];d.strokes=[paint('black')];d.strokeWeight=2;const q=txt(f,'Siap uji?',1210,694,150,25,'black','uml');q.textAlignHorizontal='CENTER';path(f,[[1285,575],[1285,650]],false,true);
 umlBox(f,'Uji penguasaan',670,672,310);path(f,[[1185,715],[980,715]],false,true);txt(f,'ya',1040,676,80,24,'black','uml');
 path(f,[[1385,715],[1650,715],[1650,520],[1480,520]],false,true);txt(f,'belum',1470,674,130,24,'black','uml');
 umlBox(f,'Hasil dan catatan belajar',210,672,350);path(f,[[670,715],[560,715]],false,true);ellipse(f,107,696,42,42);ellipse(f,115,704,26,26,true);path(f,[[210,715],[149,715]],false,true);
 note(f,'Anak dapat kembali berlatih. Hasil pemeriksaan berlaku pada keterampilan yang benar-benar diuji.');
}
// 17 sequence, target explicit.
{
 const f=slide(17,'UML: saat anak mengirim jawaban','Sequence diagram untuk rancangan uji penguasaan dan penyimpanan per jawaban.');
 const cx=[250,720,1210,1680],labels=['Anak','Layar uji','Controller / layanan','Penyimpanan lokal'];
 for(let i=0;i<4;i++){umlBox(f,labels[i],cx[i]-155,260,310,80);path(f,[[cx[i],340],[cx[i],860]],true);}
 function msg(a,b,y,label,ret=false){path(f,[[cx[a],y],[cx[b],y]],ret,true);const l=Math.min(cx[a],cx[b])+18;txt(f,label,l,y-41,Math.abs(cx[b]-cx[a])-36,25,'black','uml');}
 msg(0,1,410,'Kirim jawaban');msg(1,2,493,'Catat respons pertama');msg(2,3,576,'Simpan respons dan posisi');msg(3,2,659,'Konfirmasi tersimpan',true);msg(2,1,742,'Lanjutkan / hasil akhir',true);msg(1,0,825,'Tampilkan ke anak',true);
 note(f,'Rancangan: pembahasan jawaban muncul setelah blok uji selesai. Jika simpan gagal, tampilkan pilihan coba lagi.');
}
// 18 package main dependencies, intentional abstraction.
{
 const f=slide(18,'UML: pembagian bagian aplikasi','Package diagram ringkas. Panah putus-putus menunjukkan ketergantungan utama.');
 function pkg(label,body,x,y,w,h=155){const n=rect(f,x,y,w,h,'white',0);n.strokes=[paint('black')];n.strokeWeight=2;const tab=rect(f,x,y-22,Math.min(155,w*.4),22,'white',0);tab.strokes=[paint('black')];tab.strokeWeight=2;txt(f,label,x+22,y+17,w-44,32,'black','umlbold');txt(f,body,x+22,y+69,w-44,25,'black','uml');return n;}
 pkg('bootstrap','Menjalankan aplikasi',88,300,320);pkg('features','Layar dan interaksi',580,300,400);pkg('state','Controller dan state',1140,300,390);
 pkg('domain','Aturan pembelajaran',1140,650,390);pkg('data','Model, materi, repository',580,650,400);pkg('core','Tema, konfigurasi, widget',88,650,320);
 path(f,[[408,370],[580,370]],true,true);path(f,[[980,370],[1140,370]],true,true);path(f,[[1335,455],[1335,650]],true,true);path(f,[[1140,735],[980,735]],true,true);path(f,[[1140,420],[1055,420],[1055,690],[980,690]],true,true);path(f,[[700,455],[700,550],[248,550],[248,650]],true,true);path(f,[[1210,805],[1210,865],[248,865],[248,805]],true,true);
 txt(f,'Rincian data',1590,300,250,36,'black','umlbold');txt(f,'models\nBentuk data\n\ncontent\nTopik dan soal\n\nrepositories\nMuat dan simpan',1590,365,250,28,'black','uml');
 note(f,'Versi ringkas mengelompokkan models, content, dan repositories ke data. Rincian import ada pada dokumen package diagram.');
}
// 19 native cloned UI flow, editability preserved.
{
 const f=slide(19,'UI/UX: perjalanan anak di Numi','Contoh layar asli Numi, disusun mengikuti alur penggunaan.');
 const selected=[sources[0],sources[1],sources[2],sources[3],sources[4]],labels=['1. Profil','2. Peta belajar','3. Contoh materi','4. Latihan','5. Uji penguasaan'];
 for(let i=0;i<5;i++){const x=88+i*350;const t=txt(f,labels[i],x,258,320,29,'ink','bold');nativeScreen(f,selected[i],x+12,318,600);}
 note(f,'Sebelum peta, anak mengerjakan pemetaan awal. Uji penguasaan memberi hasil setelah blok soal selesai.');
}
// 20 editable proposed wide profile from original content.
{
 const f=slide(20,'UI/UX: nyaman di berbagai layar','Ponsel memakai susunan vertikal. Layar lebar memberi ruang untuk dua kolom.');
 nativeScreen(f,sources[0],110,310,590);txt(f,'Ponsel',110,915,300,28,'ink','bold');
 const wide=reg(figma.createFrame());f.appendChild(wide);wide.name='Usulan profil landscape / aset asli Numi';wide.resize(1280,640);wide.x=500;wide.y=295;wide.clipsContent=true;wide.fills=[paint('white')];wide.strokes=[paint('line')];wide.strokeWeight=2;wide.cornerRadius=24;const b=reg(figma.createRectangle());wide.appendChild(b);b.resize(1280,640);b.fills=[{type:'IMAGE',imageHash:'ce0722de8954485e3e2d77c24737f32687a411c2',scaleMode:'CROP',imageTransform:[[1,0,0],[0,851/2/1847,.56]],opacity:.24}];
 const left=stack(wide,38,44,490,18);tx(left,'Halo, Teman!',490,58,'ink','title');tx(left,'Isi nama dan umur bersama ayah, ibu, atau wali.',490,30);art(wide,'happy',155,285,230);
 const right=stack(wide,640,40,570,15);right.paddingTop=20;right.paddingBottom=20;right.paddingLeft=24;right.paddingRight=24;right.fills=[paint('white',.97)];right.cornerRadius=20;
 const ids=['115:371','115:372','115:375'];for(const id of ids){const src=await figma.getNodeByIdAsync(id);const n=reg(src.clone());right.appendChild(n);if('reactions'in n)await n.setReactionsAsync([]);}
 const ages=reg(figma.createAutoLayout('HORIZONTAL'));right.appendChild(ages);ages.fills=[];ages.resize(510,64);ages.primaryAxisSizingMode='FIXED';ages.counterAxisSizingMode='FIXED';ages.itemSpacing=8;for(const id of ['115:376','115:378','115:380','115:382','115:384','115:386','115:388']){const n=reg((await figma.getNodeByIdAsync(id)).clone());ages.appendChild(n);n.resize(64,64);}
 const btn=reg((await figma.getNodeByIdAsync('115:391')).clone());right.appendChild(btn);btn.resize(510,66);usedAssets.add('115:391');
 txt(f,'Usulan adaptasi untuk tablet dan desktop',500,950,1280,26,'muted');
}
// 21 tests, no progress or next steps.
{
 const f=slide(21,'Apa saja yang akan diuji?','Skenario pengujian dan hasil yang diharapkan.');
 const data=[['Logika belajar','Jawaban benar/salah, prasyarat, dan perhitungan hasil.','Hasil sesuai kasus uji dan aturan materi.'],['Alur aplikasi','Profil, pemetaan, latihan, uji, dan catatan belajar.','Anak dapat menyelesaikan alur tanpa jalan buntu.'],['Penyimpanan','Tutup-buka aplikasi dan kegagalan menyimpan data.','Data yang berhasil disimpan dapat dimuat kembali.'],['Tampilan dan kemudahan','Ukuran layar, teks besar, serta percobaan bersama anak/wali.','Konten terbaca, tombol terjangkau, instruksi dipahami.']];
 for(let i=0;i<4;i++){const a=stack(f,88+(i%2)*900,267+Math.floor(i/2)*330,810,15);tx(a,data[i][0],810,43,'ink','title');tx(a,data[i][1],810,32);tx(a,'Yang diperiksa: '+data[i][2],810,28,'muted');}
 note(f,'Guru memeriksa materi dan soal sebelum uji bersama anak. Skenario di slide ini merupakan rencana pengujian.');
}
// Remove inherited source navigation from all copied UI. Slide navigation stays on the footer.
for(const f of slides){for(const n of f.findAll(()=>true)){if('reactions'in n&&n.reactions.length)await n.setReactionsAsync([]);}}
const nav=[];
for(let i=0;i<slides.length;i++){
 const f=slides[i];
 if(i>0){const t=txt(f,'Sebelumnya',1370,1022,190,22,i===0||i===4?'white':'muted');t.name='Navigasi slide sebelumnya';await t.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'NODE',destinationId:slides[i-1].id,navigation:'NAVIGATE',transition:null,preserveScrollPosition:false}]}]);nav.push(t.id);}
 if(i<slides.length-1){const r=rect(f,1660,1000,220,70,'white');r.opacity=.001;r.name='Klik nomor untuk slide berikutnya';await r.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'NODE',destinationId:slides[i+1].id,navigation:'NAVIGATE',transition:null,preserveScrollPosition:false}]}]);nav.push(r.id);}
 const all=f.findAll(()=>true),counts={};for(const n of all)counts[n.type]=(counts[n.type]||0)+1;
 const images=all.filter(n=>'fills'in n&&Array.isArray(n.fills)&&n.fills.some(p=>p.type==='IMAGE')).map(n=>({id:n.id,name:n.name,type:n.type,width:n.width,height:n.height}));
 checks.push({id:f.id,name:f.name,width:f.width,height:f.height,descendants:all.length,counts,images});
}
page.flowStartingPoints=[{nodeId:slides[0].id,name:'Presentasi RPL Numi'}];page.prototypeBackgrounds=[paint('ink')];
figma.viewport.scrollAndZoomIntoView(slides.slice(0,3));
return {pageId:page.id,slides:checks,createdNodeIds:made,usedSourceIds:[...usedAssets],navigation:nav,fonts:[...sourceFonts.values()],ucdcBlocks:9,slideCount:slides.length};
