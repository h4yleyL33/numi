"use strict";var __m=(()=>{var B=Object.defineProperty;var se=Object.getOwnPropertyDescriptor;var ce=Object.getOwnPropertyNames,H=Object.getOwnPropertySymbols;var D=Object.prototype.hasOwnProperty,pe=Object.prototype.propertyIsEnumerable;var $=(e,a,i)=>a in e?B(e,a,{enumerable:!0,configurable:!0,writable:!0,value:i}):e[a]=i,T=(e,a)=>{for(var i in a||(a={}))D.call(a,i)&&$(e,i,a[i]);if(H)for(var i of H(a))pe.call(a,i)&&$(e,i,a[i]);return e};var de=(e,a)=>{for(var i in a)B(e,i,{get:a[i],enumerable:!0})},ge=(e,a,i,n)=>{if(a&&typeof a=="object"||typeof a=="function")for(let t of ce(a))!D.call(e,t)&&t!==i&&B(e,t,{get:()=>a[t],enumerable:!(n=se(a,t))||n.enumerable});return e};var me=e=>ge(B({},"__esModule",{value:!0}),e);var Ne={};de(Ne,{POSE:()=>I,TIPE:()=>oe,utama:()=>Re});var fe=e=>({r:parseInt(e.slice(1,3),16)/255,g:parseInt(e.slice(3,5),16)/255,b:parseInt(e.slice(5,7),16)/255}),b=(e,a=1)=>({type:"SOLID",color:fe(e),opacity:a});var h={garis:"#6B4A3A",tinta:"#4A3328",krem:"#FFF8EC",kertas:"#FFFDF7",pudar:"#8A7A6E",langit:"#BFE6F5",langitBawah:"#EAF7F0",bukit:"#CDEBB0",rumput:"#A8D98A",rumputTua:"#7FBF6A",danau:"#8FD0F0",danauTua:"#6BBCE6",pasir:"#F6E3B4",cahaya:"#FFB547",muda:"#FFE08A"},R=["senang","berpikir","semangat","sedih","mengantuk","bangga","terkejut","tertawa","kagum","tidur","mengedip"],M={biasa:{family:"Inter",style:"Regular"},tebal:{family:"Inter",style:"Bold"}};async function Q(){try{let e={biasa:{family:"Nunito",style:"Regular"},tebal:{family:"Nunito",style:"ExtraBold"}};await Promise.all([figma.loadFontAsync(e.biasa),figma.loadFontAsync(e.tebal)]),M=e}catch(e){await Promise.all([figma.loadFontAsync(M.biasa),figma.loadFontAsync(M.tebal)])}}function L(e,a,i={}){var t;let n=figma.createText();return n.fontName=i.tebal?M.tebal:M.biasa,n.characters=e,n.fontSize=a,n.fills=[b((t=i.warna)!=null?t:h.tinta)],i.lebar&&(n.textAutoResize="HEIGHT",n.resize(i.lebar,n.height)),n}var E=(e,a)=>[[e[0][0]*a[0][0]+e[0][1]*a[1][0],e[0][0]*a[0][1]+e[0][1]*a[1][1],e[0][0]*a[0][2]+e[0][1]*a[1][2]+e[0][2]],[e[1][0]*a[0][0]+e[1][1]*a[1][0],e[1][0]*a[0][1]+e[1][1]*a[1][1],e[1][0]*a[0][2]+e[1][1]*a[1][2]+e[1][2]]];function k(e,a,i,n){if(!a)return;let t=a*Math.PI/180,l=Math.cos(t),s=Math.sin(t),c=E(E([[1,0,i],[0,1,n]],[[l,s,0],[-s,l,0]]),[[1,0,-i],[0,1,-n]]);e.relativeTransform=E(c,e.relativeTransform)}function N(e,a,i,n=[]){let t=figma.createFrame();return t.name=e,t.resize(a,i),t.fills=n,t.clipsContent=!1,t}function A(e,a,i,n,t,l,s={}){var p;let c=figma.createEllipse();return c.name=e,c.x=a,c.y=i,c.resize(n,t),c.fills=[b(l,(p=s.opacity)!=null?p:1)],s.garis&&(c.strokes=[b(h.garis)],c.strokeWeight=s.garis),c}function _(e,a){let i=figma.createNodeFromSvg(e);return i.name=a,i.fills=[],i.clipsContent=!1,i}var Z=e=>e.replace(/#2A2350/g,h.tinta);async function W(e,a){let i=figma.root.children.find(n=>n.name===e);i||(i=figma.createPage(),i.name=e),await figma.setCurrentPageAsync(i);for(let n of[...i.children])a.includes(n.name)&&n.remove();return i}function he(e,a,i,n=0){let t=figma.createFrame();return t.name=a,t.layoutMode=e,t.primaryAxisSizingMode="AUTO",t.counterAxisSizingMode="AUTO",t.itemSpacing=i,t.paddingLeft=t.paddingRight=t.paddingTop=t.paddingBottom=n,t.fills=[],t.clipsContent=!1,t}function U(e,a,i,n=0,t=0){let l=he("VERTICAL",`judul ${a}`,12);return l.appendChild(L(a,56,{tebal:!0})),l.appendChild(L(i,20,{warna:h.pudar,lebar:1200})),l.x=n,l.y=t,e.appendChild(l),l}var G=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>
<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M67.7 69 A7.8 5.5 0 0 1 52.3 69" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
</svg>
`;var V=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>
<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="63.7" cy="68.9" r="2.6" fill="#2A2350"/>
</svg>
`;var J=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>
<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>
<path d="M40 41.1 A5.9 3.3 0 0 1 51.9 41.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.1 41.1 A5.9 3.3 0 0 1 80 41.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M51.1 66.7 Q60 82.2 68.9 66.7 Z" fill="#2A2350"/>
<circle cx="60" cy="73" r="2.6" fill="#FF7A85"/>
</svg>
`;var Y=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>
<ellipse cx="74.1" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="75.9" cy="51.9" r="1.9" fill="#FFFFFF"/>
<path d="M52.3 39.6 L41 47.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M67.7 39.6 L79 47.1" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M53.5 71.7 A6.7 4.4 0 0 1 66.5 71.7" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
</svg>
`;var q=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<path d="M40.4 54.5 A5.5 3.3 0 0 0 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.5 54.5 A5.5 3.3 0 0 0 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<ellipse cx="60" cy="69.3" rx="3" ry="3.7" fill="#2A2350"/>
</svg>
`;var X=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<path d="M40.4 54.5 A5.5 4.8 0 0 1 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.5 54.5 A5.5 4.8 0 0 1 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M51.1 66.7 Q60 82.2 68.9 66.7 Z" fill="#2A2350"/>
<circle cx="60" cy="73" r="2.6" fill="#FF7A85"/>
</svg>
`;var ee=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<circle cx="45.9" cy="54.5" r="6.3" fill="#FFFFFF" stroke="#2A2350" stroke-width="1.9"/>
<circle cx="45.9" cy="54.5" r="3" fill="#2A2350"/>
<circle cx="74.1" cy="54.5" r="6.3" fill="#FFFFFF" stroke="#2A2350" stroke-width="1.9"/>
<circle cx="74.1" cy="54.5" r="3" fill="#2A2350"/>
<path d="M40.8 40 Q45.9 36 51.1 40" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.9 40 Q74.1 36 79.2 40" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<ellipse cx="60" cy="71.1" rx="3.7" ry="4.8" fill="#2A2350"/>
</svg>
`;var ae=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<path d="M40.4 55.9 Q45.9 47.1 51.5 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.5 55.9 Q74.1 47.1 79.6 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M50.4 65.9 Q60 84.8 69.6 65.9 Z" fill="#2A2350"/>
<ellipse cx="60" cy="74.4" rx="4.1" ry="2.2" fill="#FF7A85"/>
</svg>
`;var ie=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<path d="M45.9 47.4 L47.7 52.1 L52.6 52.3 L48.8 55.4 L50.1 60.1 L45.9 57.4 L41.8 60.1 L43.1 55.4 L39.3 52.3 L44.2 52.1 Z" fill="#2A2350"/>
<circle cx="47.4" cy="52.6" r="1.3" fill="#FFFFFF"/>
<path d="M74.1 47.4 L75.8 52.1 L80.7 52.3 L76.9 55.4 L78.2 60.1 L74.1 57.4 L69.9 60.1 L71.2 55.4 L67.4 52.3 L72.3 52.1 Z" fill="#2A2350"/>
<circle cx="75.5" cy="52.6" r="1.3" fill="#FFFFFF"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M50.4 65.9 Q60 84.8 69.6 65.9 Z" fill="#2A2350"/>
<ellipse cx="60" cy="74.4" rx="4.1" ry="2.2" fill="#FF7A85"/>
</svg>
`;var te=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<path d="M40.4 54.5 A5.5 3.3 0 0 0 51.5 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M68.5 54.5 A5.5 3.3 0 0 0 79.6 54.5" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M57 70.4 Q60 72.6 63 70.4" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M86.6 37.1 H92.6 L86.6 43 H92.6" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M95.2 26.7 H99.6 L95.2 31.1 H99.6" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<path d="M101.4 18.6 H104.8 L101.4 21.9 H104.8" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
</svg>
`;var ne=`<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">
<ellipse cx="45.9" cy="54.5" rx="4.8" ry="6.3" fill="#2A2350"/>
<circle cx="47.8" cy="51.9" r="1.9" fill="#FFFFFF"/>
<path d="M68.5 55.9 Q74.1 47.1 79.6 55.9" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
<circle cx="37.1" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="82.9" cy="64.4" r="4.4" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M67.7 69 A7.8 5.5 0 0 1 52.3 69" fill="none" stroke="#2A2350" stroke-width="3" stroke-linecap="round"/>
</svg>
`;var re={senang:G,berpikir:V,semangat:J,sedih:Y,mengantuk:q,bangga:X,terkejut:ee,tertawa:ae,kagum:ie,tidur:te,mengedip:ne};var oe=[{id:"bulat",nama:"Bulat (beruang kecil)",warna:"#FFF6E8",perut:"#FFE7C7",bw:140,bh:120,cy:130,lengan:40,kaki:26,tebal:22,telinga:"bulat"},{id:"tinggi",nama:"Tinggi (katak penjaga pulau)",warna:"#A8D98A",perut:"#E3F5D3",bw:96,bh:150,cy:118,lengan:50,kaki:30,tebal:20},{id:"mungil",nama:"Mungil (kucing kacang)",warna:"#FFC2CC",perut:"#FFE6EA",bw:88,bh:84,cy:150,lengan:28,kaki:20,tebal:16,telinga:"runcing"},{id:"bersayap",nama:"Bersayap (sepupu Numi)",warna:"#FFE08A",perut:"#FFF4CC",bw:110,bh:110,cy:124,lengan:34,kaki:22,tebal:18,sayap:!0,antena:!0}],I={idle:{L:-12,R:12,KL:0,KR:0,B:0,S:0,dy:0},"lambai-a":{L:-12,R:150,KL:0,KR:0,B:4,S:10,dy:0},"lambai-b":{L:-12,R:112,KL:0,KR:0,B:2,S:-6,dy:0},lompat:{L:-150,R:150,KL:-28,KR:28,B:0,S:24,dy:-28},duduk:{L:-40,R:40,KL:-80,KR:80,B:0,S:0,dy:18},sedih:{L:-3,R:3,KL:0,KR:0,B:-6,S:-16,dy:4},tunjuk:{L:-12,R:88,KL:0,KR:0,B:3,S:0,dy:0}},S=3;function Me(e,a,i){let n=I[a],t=figma.createComponent();t.name=`pose=${a}`,t.resize(200,220),t.fills=[],t.clipsContent=!1;let l=N("rig/root",200,220);t.appendChild(l);let s=100,c=e.cy,p=c-e.bh/2,j=c+e.bh/2,F=new Map,o=(v,x,u,g,z,le)=>{let C=N(`rig/${v}`,g,z);return C.x=x-g/2,C.y=u,C.appendChild(A("bentuk",0,0,g,z,le,{garis:S})),F.set(C,[x,u]),l.appendChild(C),C},f=null,r=null;e.sayap&&(f=o("sayap-kiri",s-e.bw*.2,p+e.bh*.15,36,62,"#DFF4FF"),r=o("sayap-kanan",s+e.bw*.2,p+e.bh*.15,36,62,"#DFF4FF"));let w=o("kaki-kiri",s-e.bw*.22,j-10,e.tebal,e.kaki,e.warna),m=o("kaki-kanan",s+e.bw*.22,j-10,e.tebal,e.kaki,e.warna),d=N("rig/badan",e.bw,e.bh);if(d.x=s-e.bw/2,d.y=p,l.appendChild(d),e.telinga==="bulat")d.appendChild(A("telinga-kiri",e.bw*.1,-10,32,32,e.warna,{garis:S})),d.appendChild(A("telinga-kanan",e.bw*.9-32,-10,32,32,e.warna,{garis:S}));else if(e.telinga==="runcing")for(let[v,x,u]of[["telinga-kiri",e.bw*.08,-1],["telinga-kanan",e.bw*.62,1]]){let g=_(`<svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 26 26"><path d="M${u<0?"2 24 L6 2 L24 16":"24 24 L20 2 L2 16"} Z" fill="${e.warna}" stroke="${h.garis}" stroke-width="${S}" stroke-linejoin="round"/></svg>`,v);g.x=x,g.y=-12,d.appendChild(g)}if(e.antena)for(let[v,x]of[["antena-kiri",e.bw*.3],["antena-kanan",e.bw*.7]]){let u=N(`rig/${v}`,6,30);u.x=x-3,u.y=-26;let g=figma.createRectangle();g.name="batang",g.resize(3,28),g.x=1.5,g.fills=[b(h.garis)],u.appendChild(g),u.appendChild(A("cahaya",-5,-8,16,16,h.muda,{garis:2})),d.appendChild(u)}d.appendChild(A("badan",0,0,e.bw,e.bh,e.warna,{garis:S})),d.appendChild(A("perut",e.bw*.24,e.bh*.52,e.bw*.52,e.bh*.4,e.perut));let y=i.createInstance();y.name="slot/wajah",y.rescale(Math.min(e.bw,e.bh)*1.35/120),y.x=(e.bw-y.width)/2,y.y=e.bh*.42-y.height/2,d.appendChild(y);let O=p+e.bh*.45,K=o("lengan-kiri",s-e.bw/2+e.tebal*.3,O,e.tebal,e.lengan,e.warna),P=o("lengan-kanan",s+e.bw/2-e.tebal*.3,O,e.tebal,e.lengan,e.warna);return k(K,n.L,...F.get(K)),k(P,n.R,...F.get(P)),k(w,n.KL,...F.get(w)),k(m,n.KR,...F.get(m)),f&&r&&(k(f,35+n.S,...F.get(f)),k(r,-35-n.S,...F.get(r))),k(d,n.B,s,j),l.y=n.dy,t}async function Re(){await Q();let a=await W("mob base plate",["judul Mob base plate","wajah emosi","base plate","contoh emosi"]);U(a,"Mob base plate",'Badan polos tanpa wajah. Emosi dipasang sebagai wajah lewat properti "emosi", pose lewat properti "pose". Tulang: rig/root > rig/badan (badan, perut, telinga, antena, slot/wajah), rig/lengan-*, rig/kaki-*, rig/sayap-*. Sendi tiap tulang ada di tengah atas frame-nya. Semua variant memakai nama layer yang sama, jadi mengganti pose dengan Smart Animate = animasi rig.');let i=figma.createFrame();i.name="wajah emosi",i.fills=[b(h.kertas)],i.cornerRadius=24,i.resize(1690,210),i.y=200,a.appendChild(i);let n={};R.forEach((o,f)=>{let r=figma.createComponent();r.name=`wajah/${o}`,r.resize(120,120),r.fills=[],r.clipsContent=!1;let w=_(Z(re[o]),"garis");r.appendChild(w),w.x=0,w.y=0,r.description=`Wajah ${o}. Dipasang ke slot/wajah base plate dan stiker barang lewat properti "emosi".`,r.x=20+f*150,r.y=20,i.appendChild(r);let m=L(o,16,{tebal:!0,warna:h.pudar});m.x=r.x+10,m.y=160,i.appendChild(m),n[o]=r});let t=figma.createFrame();t.name="base plate",t.fills=[],t.clipsContent=!1,t.y=460,a.appendChild(t);let l={wajah:{},mob:{},prop:{}};for(let o of R)l.wajah[o]=n[o].id;let s=0,c=0;for(let o of oe){let f=L(o.nama,24,{tebal:!0});f.y=s,t.appendChild(f);let r=figma.combineAsVariants(Object.keys(I).map(m=>Me(o,m,n.senang)),t);r.name=`mob/${o.id}`,r.description=`Base plate mob ${o.nama}. Pilih pose dan emosi dari panel properti.`,r.layoutMode="HORIZONTAL",r.itemSpacing=40,r.paddingLeft=r.paddingRight=r.paddingTop=r.paddingBottom=30,r.primaryAxisSizingMode="AUTO",r.counterAxisSizingMode="AUTO",r.fills=[b(h.kertas)],r.cornerRadius=24,r.y=s+44;let w=r.addComponentProperty("emosi","INSTANCE_SWAP",n.senang.id,{preferredValues:R.map(m=>({type:"COMPONENT",key:n[m].key}))});for(let m of r.children){let d=m.findOne(y=>y.name==="slot/wajah");d.componentPropertyReferences={mainComponent:w}}l.mob[o.id]=r.id,l.prop[o.id]=w,s+=44+r.height+50,c=Math.max(c,r.width)}t.resize(c,s);let p=figma.createFrame();p.name="contoh emosi",p.fills=[],p.clipsContent=!1,p.y=460+s+40,a.appendChild(p),p.appendChild(L("Contoh: mob/bulat dengan 11 emosi",24,{tebal:!0}));let F=(await figma.getNodeByIdAsync(l.mob.bulat)).children.find(o=>o.name==="pose=idle");return R.forEach((o,f)=>{let r=F.createInstance();r.setProperties({[l.prop.bulat]:n[o].id}),r.x=f*210,r.y=50,p.appendChild(r)}),p.resize(2310,280),T({page:a.id},l)}return me(Ne);})();

return await __m.utama(typeof ID === 'undefined' ? undefined : ID);
