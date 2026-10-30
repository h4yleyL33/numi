from pathlib import Path
import json, zipfile

root = Path(__file__).resolve().parents[3]
audit = Path(__file__).resolve().parent
rev = audit.parent / 'revisi-v2-2026-10-28'
uml = audit.parent / 'uml/target-v3-2026-10-29'
scope = ('Numi ditujukan bagi anak usia 6–12 tahun. Profil meminta nama panggilan dan usia, tanpa pilihan kelas sekolah. '
         'MVP mencakup dua belas topik yang dipetakan ke sebagian CP Matematika Fase A–C. '
         'Materi, bantuan, dan remedial mengikuti bukti tiap keterampilan dan prasyaratnya.')
vision = json.loads((rev/'visi-bersama.json').read_text(encoding='utf-8'))
vision['scope'] = scope
(rev/'visi-bersama.json').write_text(json.dumps(vision, ensure_ascii=False, indent=2),encoding='utf-8')
pkg = json.loads((rev/'package_content.json').read_text(encoding='utf-8'))
pkg['purpose'] = vision['vision'] + ' ' + scope
(rev/'package_content.json').write_text(json.dumps(pkg,ensure_ascii=False,indent=2),encoding='utf-8')
v = json.loads((audit/'verification.json').read_text(encoding='utf-8'))
v.pop('grades',None);v.pop('unknownGradeOption',None)
v.update(ages=list(range(6,13)),schoolGradeInput=False,umlStyle='black text and lines on white background')
for d in v['nativeDocuments']:
    d['title'] = {'doktek':'Numi — Dokumentasi Teknis v2.2 — Usia 6–12 dan UML Target',
                  'proposal':'Numi — Proposal PPL v2.2 — Usia 6–12 dan Kurikulum',
                  'kurikulum':'Numi — Rencana Kurikulum v2.1 — Usia 6–12 Tahun'}[d['document']]
(audit/'verification.json').write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
js = audit/'figma-target-v3.js'
t=js.read_text(encoding='utf-8')
if not t.startswith('// ARSIP'):
    js.write_text('// ARSIP generator sebelum keputusan usia. Jangan gunakan sebagai spesifikasi aktif.\n// Lihat keputusan-usia-dan-gaya-uml.md dan prototype native terbaru.\n'+t,encoding='utf-8')
p=audit/'HASIL-AUDIT.md';t=p.read_text(encoding='utf-8').replace('lampiran aktor, cakupan kelas,','lampiran aktor, batas usia dan cakupan materi,')
t=t.replace('Kesimpulan:','Keputusan terbaru: pengguna berusia 6–12 tahun; profil meminta nama dan usia. Pilihan kelas sekolah dibatalkan. Sepuluh UML target memakai teks dan garis hitam pada latar putih.\n\nKesimpulan:',1)
p.write_text(t,encoding='utf-8')
p=uml/'README.md';t=p.read_text(encoding='utf-8').replace('model target kelas, CP, skill, konten, bukti, dan checkpoint.','model target profil usia 6–12, CP, skill, konten, bukti, dan checkpoint.')
t += '\nKeputusan terbaru: profil cukup nama panggilan dan usia 6–12 tahun; tidak ada pilihan kelas sekolah. Diagram memakai teks dan garis hitam, latar putih, serta bentuk sederhana. Lihat ../../audit-kurikulum-2026-10-29/keputusan-usia-dan-gaya-uml.md.\n'
p.write_text(t,encoding='utf-8')
dest=root/'output/Numi_UML_Target_v3_2026-10-29.zip'
with zipfile.ZipFile(dest,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(uml.rglob('*')):
        if p.is_file():z.write(p,p.relative_to(uml.parent))
print(json.dumps({'zip':str(dest),'bytes':dest.stat().st_size,'sourceScopeUpdated':True}))
