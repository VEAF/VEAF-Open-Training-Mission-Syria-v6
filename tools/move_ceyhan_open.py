"""Le champ de tir hélicoptères de Ceyhan, deuxième déplacement : sur les collines nues à l'est de Körkuyu.

Le premier (fix_ceyhan_range.py, 16/11/2026) l'avait posé plein sud du FARP, de nouveau en forêt : David l'a vu sur la
carte F10, qui dessine les forêts que la sonde de DCS ne voit pas sur Syria.
Cette place-ci est choisie sur sa capture F10 (mode Map, 9,28 m par pixel, calée sur le FARP et le cercle de la
zone) : chaque véhicule a au moins 95 % de terrain dégagé dans un rayon de 60 m, et les deux lanceurs radar 98 %
dans 80 m. La vue Sat de la même capture y montre des collines nues.

- toute la famille (3 zones, cibles et marqueurs, orbite du Reaper 1, dessins F10 « H ») : +600 N, +7 000 E ;
- SA-19 Tunguska à 1,2 km au nord-est des cibles (10,4 km du FARP, portée 8 km) ;
- SA-8 Osa à 1,2 km à l'est (11,4 km du FARP, portée 10,3 km).
Une seule fois : il refuse de repasser.
"""

import sys

from paths import ROOT  # noqa: F401  (met aussi le code VMCT sur sys.path)
from veaf_mission_mcp.actions import register_default_actions  # noqa: E402
from veaf_mission_mcp.catalog import ActionCatalog  # noqa: E402
from veaf_mission_mcp.mission_folder import load_folder_mission  # noqa: E402

sys.stdout.reconfigure(encoding="utf-8")
M = ROOT.as_posix()
cat = ActionCatalog()
register_default_actions(cat)

OLD = (212316, 2506)                  # centre posé par fix_ceyhan_range.py
DX, DZ = 600, 7000
RADARS = {"combatZone_Ceyhan_Hard-Hard-H4-2": (213955, 10106),   # SA-19
          "combatZone_Ceyhan_Hard-Hard-H4-3": (213124, 10688)}   # SA-8
ZONES = ["combatZone_Ceyhan_Easy", "combatZone_Ceyhan_Medium", "combatZone_Ceyhan_Hard"]


def run(action, **params):
    res = cat.run_action(action, {"mission_path": M, **params})
    warn = res.get("warnings") if isinstance(res, dict) else None
    print(f"{action} {params.get('group_name') or params.get('zone_name') or params.get('name')}: ok"
          + (f" — {warn}" if warn else ""))


def as_list(t):
    return [t[k] for k in sorted(t)] if isinstance(t, dict) else (t or [])


content = load_folder_mission(ROOT).mission_content
zones = {z["name"]: z for z in as_list(content["triggers"]["zones"])}
if (round(zones[ZONES[0]]["x"]), round(zones[ZONES[0]]["y"])) != OLD:
    sys.exit("déjà fait, ou Ceyhan n'est plus à la place que ce script attend")

for name in ZONES:
    run("edit_zone", zone_name=name, position={"x": zones[name]["x"] + DX, "y": zones[name]["y"] + DZ})
for co in content["coalition"].values():
    for c in as_list(co.get("country")):
        for cat_ in ("vehicle", "static", "plane"):
            for g in as_list((c.get(cat_) or {}).get("group")):
                if g["name"] in RADARS:
                    x, z = RADARS[g["name"]]
                    run("set_group_properties", group_name=g["name"], move_to={"x": x, "y": z})
                elif g["name"].startswith("combatZone_Ceyhan_") or g["name"] == "Reaper 1":
                    run("set_group_properties", group_name=g["name"], move_to={"x": g["x"] + DX, "y": g["y"] + DZ})
for layer in as_list(content["drawings"]["layers"]):
    for d in as_list(layer.get("objects")):
        if d.get("name") in ("H cercle", "H étiquette"):
            run("edit_map_drawing", layer=d["layerName"], name=d["name"],
                position={"x": d["mapX"] + DX, "y": d["mapY"] + DZ})
