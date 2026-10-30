from pathlib import Path
p=Path('app/lib/features/lesson/lesson_screen.dart');s=p.read_text(encoding='utf-8')
start=s.index('            Text(widget.lesson.judul')
end=s.index('            Expanded(',start)
header=s[start:end]
s=s[:start]+s[end:]
point=s.index('                children: [',start)+len('                children: [')
s=s[:point]+'\n'+header+s[point:]
p.write_text(s,encoding='utf-8')
