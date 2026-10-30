from pathlib import Path
import re, json, collections

root=Path(__file__).resolve().parents[3]
lib=root/'app/lib'
def package(path):
    p=path.parts
    if len(p)==1:return 'bootstrap'
    return '.'.join(p[:2]) if p[0]=='data' else p[0]
edges=collections.Counter(); evidence=collections.defaultdict(list); external=collections.Counter()
files=list(lib.rglob('*.dart'))
for f in files:
    source=package(f.relative_to(lib))
    for imp in re.findall(r"import\s+['\"]([^'\"]+)['\"]",f.read_text(encoding='utf-8')):
        if imp.startswith('package:'):
            external[imp.split('/')[0][8:]]+=1
            continue
        if imp.startswith('dart:'):continue
        dest=(f.parent/imp).resolve().relative_to(lib.resolve())
        target=package(dest)
        if source!=target:
            edges[source,target]+=1
            evidence[source,target].append({'source':str(f.relative_to(root)).replace('\\','/'),'import':imp})
tests=list((root/'app/test').rglob('*.dart'))
result={'date':'2026-10-28','dart_files':len(files),'test_files':len(tests),'declared_tests':sum(len(re.findall(r'\btest(?:Widgets)?\(',p.read_text(encoding='utf-8'))) for p in tests),'packages':dict(collections.Counter(package(f.relative_to(lib)) for f in files)),'edges':[{'from':a,'to':b,'count':n,'examples':evidence[a,b][:3]} for (a,b),n in sorted(edges.items())],'external_imports':dict(external)}
(Path(__file__).parent/'package-evidence.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k!='edges'},ensure_ascii=False))
print(json.dumps([{k:v for k,v in e.items() if k!='examples'} for e in result['edges']]))
