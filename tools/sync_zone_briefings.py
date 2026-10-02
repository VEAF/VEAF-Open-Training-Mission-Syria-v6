"""Réécrit la ligne « Position » du briefing de chaque zone de combat dans mission.yaml.

Depuis tools/briefing_data.json (lancer gather.py avant) : bullseye (relèvement vrai/distance), coordonnées DDM,
ravitailleurs bleus à perche et à panier les plus proches (distance au segment de leur piste). Le reste du
briefing (le texte écrit à la main) est gardé. Finit sur une ligne VERDICT.
"""

import json
import re

from paths import ROOT, TOOLS

D = json.load(open(TOOLS / "briefing_data.json", encoding="utf-8"))
by_key = {z["key"]: z for z in D["zones"]}
path = ROOT / "mission.yaml"
lines = open(path, encoding="utf-8").read().split("\n")

current, changed = None, 0
for i, line in enumerate(lines):
    m = re.match(r"^\s+zone_name: (\S+)\s*$", line)
    if m:
        current = m.group(1)
        continue
    m = re.match(r'^(\s+briefing: )"(.*)"\s*$', line)
    if m and current in by_key:
        z = by_key[current]
        body = json.loads(f'"{m.group(2)}"').split("\nPosition :")[0]
        pos = f"Position : bullseye {z['be']} ({z['ddm']}). Ravitailleurs : {z['tankers']}."
        new = m.group(1) + json.dumps(f"{body}\n{pos}", ensure_ascii=False)
        if new != line:
            lines[i] = new
            changed += 1
        current = None

open(path, "w", encoding="utf-8").write("\n".join(lines))
print(f"VERDICT : {changed} briefing(s) de zone réécrit(s) sur {len(by_key)} zones")
