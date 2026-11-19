"""Render tujuh diagram secara lokal; periksa paket terhadap impor Dart nyata."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[3]
GROUPS = {"Boot": "bootstrap", "UI": "features", "App": "state",
          "Domain": "domain", "Data": "data", "Core": "core"}


def imports():
    lib = REPO / "app/lib"
    edges = {}
    for path in sorted(lib.rglob("*.dart")):
        rel = path.relative_to(lib)
        owner = rel.parts[0] if len(rel.parts) > 1 else "bootstrap"
        text = path.read_text(encoding="utf-8")
        for match in re.finditer(r"^import\s+['\"]([^'\"]+)['\"]", text, re.M):
            uri = match[1]
            if uri.startswith("package:numi/"):
                target = lib / uri[len("package:numi/"):]
            elif ":" in uri:
                continue
            else:
                target = (path.parent / uri).resolve()
            target = target.relative_to(lib)
            used = target.parts[0] if len(target.parts) > 1 else "bootstrap"
            if owner != used:
                edges.setdefault((owner, used), []).append({
                    "file": path.relative_to(REPO).as_posix(),
                    "line": text[:match.start()].count("\n") + 1,
                    "import": uri,
                })
    drawn = {(GROUPS[a], GROUPS[b]) for a, b in re.findall(
        r"^(\w+) \.\.> (\w+)$", (ROOT / "src/packages.puml").read_text(), re.M)}
    if drawn != set(edges):
        raise ValueError(f"Diagram paket berbeda dari kode: kurang={set(edges)-drawn}, lebih={drawn-set(edges)}")
    return [{"from": a, "to": b, "count": len(refs), "example": refs[0]}
            for (a, b), refs in sorted(edges.items())]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jar", default=os.environ.get("PLANTUML_JAR"), required=not os.environ.get("PLANTUML_JAR"))
    parser.add_argument("--java", default=shutil.which("java") or "java")
    parser.add_argument("--dot", default=os.environ.get("GRAPHVIZ_DOT"))
    args = parser.parse_args()
    dependency_report = imports()
    sources = sorted((ROOT / "src").glob("*.puml"))
    if len(sources) != 7:
        raise ValueError("Paket ini harus memuat tujuh diagram.")
    env = os.environ.copy()
    if args.dot:
        env["GRAPHVIZ_DOT"] = args.dot
    for fmt in ("png", "svg"):
        out = ROOT / fmt
        out.mkdir(exist_ok=True)
        subprocess.run([args.java, "-Djava.awt.headless=true", "-jar", args.jar,
                        "-charset", "UTF-8", "-failfast2", f"-t{fmt}", "-o", str(out),
                        *map(str, sources)], check=True, env=env)
    manifest = []
    for source in sources:
        png = ROOT / "png" / f"{source.stem}.png"
        svg = ROOT / "svg" / f"{source.stem}.svg"
        image = png.read_bytes()
        if image[:8] != b"\x89PNG\r\n\x1a\n" or "<svg" not in svg.read_text(encoding="utf-8"):
            raise ValueError(f"Hasil render tidak sah: {source.stem}")
        width, height = struct.unpack(">II", image[16:24])
        manifest.append({"diagram": source.stem, "width": width, "height": height,
                         "sha256": {f"{fmt}/{source.stem}.{fmt}": hashlib.sha256(
                             (ROOT / fmt / f"{source.stem}.{fmt}").read_bytes()).hexdigest()
                             for fmt in ("png", "svg")}})
    (ROOT / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (ROOT / "imports.json").write_text(json.dumps(dependency_report, indent=2) + "\n", encoding="utf-8")
    print(f"Lulus: {len(manifest)} PNG, {len(manifest)} SVG; {len(dependency_report)} dependensi paket cocok dengan impor Dart.")


if __name__ == "__main__":
    main()
