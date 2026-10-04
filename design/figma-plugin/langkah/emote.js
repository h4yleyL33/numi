"use strict";var __m=(()=>{var w=Object.defineProperty;var W=Object.getOwnPropertyDescriptor;var J=Object.getOwnPropertyNames;var q=Object.prototype.hasOwnProperty;var X=(t,o)=>{for(var r in o)w(t,r,{get:o[r],enumerable:!0})},Y=(t,o,r,l)=>{if(o&&typeof o=="object"||typeof o=="function")for(let e of J(o))!q.call(t,e)&&e!==r&&w(t,e,{get:()=>o[e],enumerable:!(l=W(o,e))||l.enumerable});return t};var tt=t=>Y(w({},"__esModule",{value:!0}),t);var mt={};X(mt,{EMOTE:()=>V,utama:()=>kt});var ot=t=>({r:parseInt(t.slice(1,3),16)/255,g:parseInt(t.slice(3,5),16)/255,b:parseInt(t.slice(5,7),16)/255}),D=(t,o=1)=>({type:"SOLID",color:ot(t),opacity:o});var x={garis:"#6B4A3A",tinta:"#4A3328",krem:"#FFF8EC",kertas:"#FFFDF7",pudar:"#8A7A6E",langit:"#BFE6F5",langitBawah:"#EAF7F0",bukit:"#CDEBB0",rumput:"#A8D98A",rumputTua:"#7FBF6A",danau:"#8FD0F0",danauTua:"#6BBCE6",pasir:"#F6E3B4",cahaya:"#FFB547",muda:"#FFE08A"},C=["senang","berpikir","semangat","sedih","mengantuk","bangga","terkejut","tertawa","kagum","tidur","mengedip"],m={biasa:{family:"Inter",style:"Regular"},tebal:{family:"Inter",style:"Bold"}};async function T(){try{let t={biasa:{family:"Nunito",style:"Regular"},tebal:{family:"Nunito",style:"ExtraBold"}};await Promise.all([figma.loadFontAsync(t.biasa),figma.loadFontAsync(t.tebal)]),m=t}catch(t){await Promise.all([figma.loadFontAsync(m.biasa),figma.loadFontAsync(m.tebal)])}}function A(t,o,r={}){var e;let l=figma.createText();return l.fontName=r.tebal?m.tebal:m.biasa,l.characters=t,l.fontSize=o,l.fills=[D((e=r.warna)!=null?e:x.tinta)],r.lebar&&(l.textAutoResize="HEIGHT",l.resize(r.lebar,l.height)),l}var b=(t,o)=>[[t[0][0]*o[0][0]+t[0][1]*o[1][0],t[0][0]*o[0][1]+t[0][1]*o[1][1],t[0][0]*o[0][2]+t[0][1]*o[1][2]+t[0][2]],[t[1][0]*o[0][0]+t[1][1]*o[1][0],t[1][0]*o[0][1]+t[1][1]*o[1][1],t[1][0]*o[0][2]+t[1][1]*o[1][2]+t[1][2]]];function it(t,o,r,l){if(!o)return;let e=o*Math.PI/180,a=Math.cos(e),f=Math.sin(e),s=b(b([[1,0,r],[0,1,l]],[[a,f,0],[-f,a,0]]),[[1,0,-r],[0,1,-l]]);t.relativeTransform=b(s,t.relativeTransform)}var B=(t,o)=>it(t,o,t.x+t.width/2,t.y+t.height/2);function j(t,o){let r=figma.createNodeFromSvg(t);return r.name=o,r.fills=[],r.clipsContent=!1,r}var L=t=>t.replace(/#2A2350/g,x.tinta);async function _(t,o){let r=figma.root.children.find(l=>l.name===t);r||(r=figma.createPage(),r.name=t),await figma.setCurrentPageAsync(r);for(let l of[...r.children])o.includes(l.name)&&l.remove();return r}function rt(t,o,r,l=0){let e=figma.createFrame();return e.name=o,e.layoutMode=t,e.primaryAxisSizingMode="AUTO",e.counterAxisSizingMode="AUTO",e.itemSpacing=r,e.paddingLeft=e.paddingRight=e.paddingTop=e.paddingBottom=l,e.fills=[],e.clipsContent=!1,e}function Q(t,o,r,l=0,e=0){let a=rt("VERTICAL",`judul ${o}`,12);return a.appendChild(A(o,56,{tebal:!0})),a.appendChild(A(r,20,{warna:x.pudar,lebar:1200})),a.x=l,a.y=e,t.appendChild(a),a}async function M(t,o){for(let r=0;r<t.length;r++)await t[r].setReactionsAsync([{trigger:{type:"AFTER_TIMEOUT",timeout:.01},actions:[{type:"NODE",destinationId:t[(r+1)%t.length].id,navigation:"CHANGE_TO",transition:{type:"SMART_ANIMATE",easing:{type:"EASE_IN_AND_OUT"},duration:o},preserveScrollPosition:!1}]}])}function G(t,o){t.layoutMode="HORIZONTAL",t.itemSpacing=24,t.paddingLeft=t.paddingRight=t.paddingTop=t.paddingBottom=24,t.primaryAxisSizingMode="AUTO",t.counterAxisSizingMode="AUTO",t.fills=[D(o)],t.cornerRadius=24}async function E(t){let o={};for(let[e,a]of Object.entries(t.wajah))o[e]=await figma.getNodeByIdAsync(a);let r={};for(let[e,a]of Object.entries(t.mob))r[e]=await figma.getNodeByIdAsync(a);return{wajah:o,set:r,mob:(e,a,f)=>{let n=r[e].children.find(u=>u.name===`pose=${a}`).createInstance();return n.setProperties({[t.prop[e]]:o[f].id}),n.name=`mob-${e}`,n}}}var N=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>
<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M135 151.9 A15.1 10.8 0 0 1 105 151.9" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
</svg>
`;var S=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>
<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="127.2" cy="151.7" r="5" fill="#2A2350"/>
</svg>
`;var I=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>
<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>
<path d="M81.1 97.7 A11.5 6.5 0 0 1 104.2 97.7" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M135.8 97.7 A11.5 6.5 0 0 1 158.9 97.7" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M102.7 147.4 Q120 177.6 137.3 147.4 Z" fill="#2A2350"/>
<circle cx="120" cy="159.6" r="5" fill="#FF7A85"/>
</svg>
`;var R=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>
<ellipse cx="147.4" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="151" cy="118.6" r="3.6" fill="#FFFFFF"/>
<path d="M105 94.8 L83.1 109.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M135 94.8 L156.9 109.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M107.3 157.2 A13 8.6 0 0 1 132.7 157.2" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
</svg>
`;var O=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.2025"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="0.45"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.405"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.1575"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.1575"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<path d="M81.8 123.6 A10.8 6.5 0 0 0 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M136.6 123.6 A10.8 6.5 0 0 0 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<ellipse cx="120" cy="152.4" rx="5.8" ry="7.2" fill="#2A2350"/>
</svg>
`;var H=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<path d="M81.8 123.6 A10.8 9.4 0 0 1 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M136.6 123.6 A10.8 9.4 0 0 1 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M102.7 147.4 Q120 177.6 137.3 147.4 Z" fill="#2A2350"/>
<circle cx="120" cy="159.6" r="5" fill="#FF7A85"/>
</svg>
`;var P=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<circle cx="92.6" cy="123.6" r="12.2" fill="#FFFFFF" stroke="#2A2350" stroke-width="3.6"/>
<circle cx="92.6" cy="123.6" r="5.8" fill="#2A2350"/>
<circle cx="147.4" cy="123.6" r="12.2" fill="#FFFFFF" stroke="#2A2350" stroke-width="3.6"/>
<circle cx="147.4" cy="123.6" r="5.8" fill="#2A2350"/>
<path d="M82.6 95.5 Q92.6 87.6 102.7 95.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M137.3 95.5 Q147.4 87.6 157.4 95.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<ellipse cx="120" cy="156" rx="7.2" ry="9.4" fill="#2A2350"/>
</svg>
`;var z=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<path d="M81.8 126.5 Q92.6 109.2 103.4 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M136.6 126.5 Q147.4 109.2 158.2 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M101.3 145.9 Q120 182.6 138.7 145.9 Z" fill="#2A2350"/>
<ellipse cx="120" cy="162.5" rx="7.9" ry="4.3" fill="#FF7A85"/>
</svg>
`;var $=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<path d="M92.6 109.9 L96 118.9 L105.7 119.4 L98.1 125.4 L100.7 134.7 L92.6 129.4 L84.6 134.7 L87.2 125.4 L79.6 119.4 L89.3 118.9 Z" fill="#2A2350"/>
<circle cx="95.5" cy="120" r="2.5" fill="#FFFFFF"/>
<path d="M147.4 109.9 L150.7 118.9 L160.4 119.4 L152.8 125.4 L155.4 134.7 L147.4 129.4 L139.3 134.7 L141.9 125.4 L134.3 119.4 L144 118.9 Z" fill="#2A2350"/>
<circle cx="150.2" cy="120" r="2.5" fill="#FFFFFF"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M101.3 145.9 Q120 182.6 138.7 145.9 Z" fill="#2A2350"/>
<ellipse cx="120" cy="162.5" rx="7.9" ry="4.3" fill="#FF7A85"/>
</svg>
`;var Z=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.135"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="0.3"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.27"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.105"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.105"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<path d="M81.8 123.6 A10.8 6.5 0 0 0 103.4 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M136.6 123.6 A10.8 6.5 0 0 0 158.2 123.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M114.2 154.6 Q120 158.9 125.8 154.6" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M171.8 89.8 H183.4 L171.8 101.3 H183.4" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M188.4 69.6 H197 L188.4 78.2 H197" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<path d="M200.6 53.8 H207.1 L200.6 60.2 H207.1" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
</svg>
`;var K=`<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
<defs>
  <radialGradient id="halo"><stop offset="0" stop-color="#FFB547" stop-opacity="0.45"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="ekor"><stop offset="0" stop-color="#FFFFFF" stop-opacity="1"/><stop offset="0.45" stop-color="#FFD98A" stop-opacity="0.9"/><stop offset="1" stop-color="#FFB547" stop-opacity="0"/></radialGradient>
  <radialGradient id="badan" cx="0.35" cy="0.3" r="0.75"><stop offset="0" stop-color="#FFD166"/><stop offset="1" stop-color="#F4A340"/></radialGradient>
</defs>
<circle cx="120" cy="134.4" r="126" fill="url(#halo)"/>
<ellipse cx="55.2" cy="80.4" rx="32.4" ry="19.8" transform="rotate(-34.4 80.4 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<ellipse cx="184.8" cy="80.4" rx="32.4" ry="19.8" transform="rotate(34.4 159.6 94.8)" fill="#FFFFFF" fill-opacity="0.55" stroke="#FFFFFF" stroke-opacity="0.9" stroke-width="2.9"/>
<path d="M98.4 69.6 Q105.6 33.6 73.2 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="73.2" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="73.2" cy="22.8" r="7.9" fill="#FFD98A"/>
<path d="M141.6 69.6 Q134.4 33.6 166.8 22.8" fill="none" stroke="#2A2350" stroke-width="5" stroke-linecap="round"/>
<circle cx="166.8" cy="22.8" r="14.4" fill="#FFB547" fill-opacity="0.35"/>
<circle cx="166.8" cy="22.8" r="7.9" fill="#FFD98A"/>
<circle cx="120" cy="202.8" r="30.2" fill="url(#ekor)"/>
<circle cx="120" cy="134.4" r="72" fill="url(#badan)"/>
<ellipse cx="120" cy="159.6" rx="39.6" ry="28.8" fill="#FFF1C1" fill-opacity="0.9"/>
<ellipse cx="92.6" cy="123.6" rx="9.4" ry="12.2" fill="#2A2350"/>
<circle cx="96.2" cy="118.6" r="3.6" fill="#FFFFFF"/>
<path d="M136.6 126.5 Q147.4 109.2 158.2 126.5" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
<circle cx="75.4" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<circle cx="164.6" cy="143" r="8.6" fill="#FF9AA2" fill-opacity="0.55"/>
<path d="M135 151.9 A15.1 10.8 0 0 1 105 151.9" fill="none" stroke="#2A2350" stroke-width="5.8" stroke-linecap="round"/>
</svg>
`;var U={senang:N,berpikir:S,semangat:I,sedih:R,mengantuk:O,bangga:H,terkejut:P,tertawa:z,kagum:$,tidur:Z,mengedip:K};var i=(t,o,r,l)=>({dy:t,s:o,rot:r,wajah:l}),V={senang:{durasi:.35,kunci:[i(0,1,0),i(-10,1.04,0),i(0,1,0),i(-6,1.02,0)],pose:["idle","lambai-a","lambai-b","lambai-a"]},berpikir:{durasi:.5,kunci:[i(0,1,0),i(0,1,8),i(-4,1,10),i(0,1,4)],pose:["idle","tunjuk","tunjuk","idle"]},semangat:{durasi:.3,kunci:[i(0,1,0),i(6,.95,0),i(-28,1.05,-6),i(0,1,0)],pose:["idle","duduk","lompat","idle"]},sedih:{durasi:.7,kunci:[i(0,1,0),i(6,.97,-4),i(8,.96,-6),i(6,.97,-4)],pose:["idle","sedih","sedih","sedih"]},mengantuk:{durasi:.8,kunci:[i(0,1,0),i(4,.99,-8),i(6,.98,-12),i(2,1,-4)],pose:["idle","sedih","sedih","idle"]},bangga:{durasi:.4,kunci:[i(0,1,0),i(-6,1.08,0),i(-8,1.12,0),i(-4,1.06,0)],pose:["idle","lompat","lompat","idle"]},terkejut:{durasi:.25,kunci:[i(0,1,0),i(-20,1.1,0),i(-14,1.06,0),i(0,1,0)],pose:["idle","lompat","idle","idle"]},tertawa:{durasi:.2,kunci:[i(0,1,0),i(-4,1.02,8),i(-4,1.02,-8),i(-2,1.01,4)],pose:["idle","lambai-a","idle","lambai-b"]},kagum:{durasi:.45,kunci:[i(0,1,0),i(-12,1.06,0),i(-16,1.08,0),i(-8,1.04,0)],pose:["idle","lompat","lompat","idle"]},tidur:{durasi:.9,kunci:[i(0,1,0),i(2,1.03,0),i(4,1.05,0),i(2,1.03,0)],pose:["duduk","duduk","duduk","duduk"]},mengedip:{durasi:.3,kunci:[i(0,1,0,"senang"),i(0,1,6),i(0,1,6),i(0,1,0,"senang")],pose:["idle","tunjuk","tunjuk","idle"]}};async function kt(t){await T();let o=await _("anim emote",["judul Animasi emote","emote"]),{mob:r}=await E(t);Q(o,"Animasi emote","Kiri: Numi. Kanan: mob/bulat (pose rig + wajah emosi). Tiap baris adalah component set 4 frame yang tersambung (After delay \u2192 Change to \u2192 Smart Animate). Taruh instance frame=1 di dalam sebuah frame, lalu tekan Present untuk melihat animasinya.");let l=figma.createFrame();l.name="emote",l.fills=[],l.clipsContent=!1,l.y=180,o.appendChild(l);let e={},a=0,f=0;for(let s of C){let n=V[s],u=n.kunci.map((d,g)=>{var k;let c=figma.createComponent();c.name=`frame=${g+1}`,c.resize(260,260),c.fills=[],c.clipsContent=!1;let F=j(L(U[(k=d.wajah)!=null?k:s]),"numi");return c.appendChild(F),F.rescale(d.s),F.x=(260-F.width)/2,F.y=(260-F.height)/2+d.dy,B(F,d.rot),c}),y=figma.combineAsVariants(u,l);y.name=`emote/numi/${s}`,y.description=`Emote Numi ${s}. Pasang instance frame=1 lalu Play: berputar 4 frame dengan Smart Animate.`,G(y,"#DDF1FA"),y.y=a,await M(u,n.durasi);let v=n.kunci.map((d,g)=>{var k;let c=figma.createComponent();c.name=`frame=${g+1}`,c.resize(240,260),c.fills=[],c.clipsContent=!1;let F=r("bulat",n.pose[g],(k=d.wajah)!=null?k:s);return c.appendChild(F),F.x=20,F.y=20+d.dy,B(F,d.rot/2),c}),p=figma.combineAsVariants(v,l);p.name=`emote/mob/${s}`,p.description=`Emote mob ${s}: pose rig dan wajah emosi berganti tiap frame.`,G(p,"#E9F6E1"),p.x=y.width+40,p.y=a,await M(v,n.durasi);let h=A(s,28,{tebal:!0});h.x=p.x+p.width+40,h.y=a+20,l.appendChild(h),e[s]=[y.id,p.id],f=Math.max(f,h.x+200),a+=Math.max(y.height,p.height)+40}return l.resize(f,a),{page:o.id,emote:e,warnaLatar:x.krem}}return tt(mt);})();

return await __m.utama(typeof ID === 'undefined' ? undefined : ID);
