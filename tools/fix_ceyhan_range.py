"""Le champ de tir hélicoptères de Ceyhan sort de la forêt et reçoit un vrai niveau difficile (FIX-OPEN-TRAINING-PILOT-FEEDBACK).

Retours de David après vol (15/11/2026) :
  - « la zone d'entraînement hélico nord, vers YF69, est pourrie : elle est en pleine forêt » ;
  - « l'entraînement hélico en difficile, c'est en fait le niveau moyen ; le vrai difficile, ce serait avec des Tor ou
    des Tunguska ».

Ce que fait ce script, une seule fois (il refuse de repasser) :
  1. toute la famille Ceyhan (3 zones de déclenchement, cibles et marqueurs des 3 niveaux, orbite du Reaper 1) se
     déplace d'un même vecteur, de 8,8 km à l'est du FARP à la même distance plein sud, dans la plaine cultivée entre
     Körkuyu et Kurtkulağı. Sur Syria la sonde de DCS ne voit pas certaines forêts (limitation connue
     disposition-blind-to-akamas-forest) : la nouvelle place se vérifie à l'œil en jeu ;
  2. moyen = artillerie légère + défense courte portée à guidage infrarouge : les deux équipes SA-18 passent du
     difficile au moyen, et le `_spawn samgroup, defense 3` du difficile (qui tire un Osa, à guidage radar, une fois
     sur cinq) est remplacé par deux SA-13 dont un seul apparaît ;
  3. difficile = moyen + deux lanceurs à guidage radar tirés parmi trois, chacun placé au-delà des cibles, au plus près
     qui laisse toute base bleue avec slots hors de sa portée DCS avec 1 km de marge.
"""

import math
import sys

from paths import ROOT  # noqa: F401  (met aussi le code VMCT sur sys.path)
from veaf_mission_mcp.actions import register_default_actions  # noqa: E402
from veaf_mission_mcp.catalog import ActionCatalog  # noqa: E402
from veaf_mission_mcp.mission_folder import load_folder_mission  # noqa: E402

sys.stdout.reconfigure(encoding="utf-8")
M = ROOT.as_posix()
cat = ActionCatalog()
register_default_actions(cat)

FARP = (221016, 2506)          # FARP Ceyhan (mission)
ZONES = ["combatZone_Ceyhan_Easy", "combatZone_Ceyhan_Medium", "combatZone_Ceyhan_Hard"]
NEW_CENTRE_BEARING, NEW_CENTRE_DIST = 180, 8700      # depuis le FARP
RANGES = {"Tor 9A331": 12000, "2S6 Tunguska": 8000, "Osa 9A33 ln": 10300}   # threat_range_m (list_unit_types)
RADAR = [("-sa15", "Tor 9A331"), ("-sa19", "2S6 Tunguska"), ("-sa8", "Osa 9A33 ln")]
MARGIN = 1000
RED = {"coalition": "red", "country_id": 47, "country_name": "Syria"}


def off(p, brg, m):
    r = math.radians(brg)
    return (p[0] + m * math.cos(r), p[1] + m * math.sin(r))


def run(action, **params):
    res = cat.run_action(action, {"mission_path": M, **params})
    warn = res.get("warnings") if isinstance(res, dict) else None
    print(f"{action} {params.get('group_name') or params.get('zone_name') or params.get('name')}: ok"
          + (f" — {warn}" if warn else ""))
    return res


def as_list(t):
    return [t[k] for k in sorted(t)] if isinstance(t, dict) else (t or [])


content = load_folder_mission(ROOT).mission_content
if any(g["name"].startswith("combatZone_Ceyhan_Hard-Hard-H4-")
       for co in content["coalition"].values() for c in as_list(co.get("country"))
       for g in as_list((c.get("vehicle") or {}).get("group"))):
    sys.exit("déjà fait : le niveau difficile de Ceyhan a ses lanceurs H4")

zones = {z["name"]: z for z in as_list(content["triggers"]["zones"])}
old = (zones["combatZone_Ceyhan_Easy"]["x"], zones["combatZone_Ceyhan_Easy"]["y"])
new = off(FARP, NEW_CENTRE_BEARING, NEW_CENTRE_DIST)
dx, dy = new[0] - old[0], new[1] - old[1]
print(f"centre ({old[0]:.0f}, {old[1]:.0f}) -> ({new[0]:.0f}, {new[1]:.0f}), delta ({dx:+.0f} N, {dy:+.0f} E)")

# 1. la famille, d'un même vecteur
for name in ZONES:
    z = zones[name]
    run("edit_zone", zone_name=name, position={"x": z["x"] + dx, "y": z["y"] + dy})
movers = []
for co in content["coalition"].values():
    for c in as_list(co.get("country")):
        for cat_ in ("vehicle", "static", "plane"):
            for g in as_list((c.get(cat_) or {}).get("group")):
                if g["name"].startswith("combatZone_Ceyhan_") or g["name"] == "Reaper 1":
                    movers.append((g["name"], g["x"], g["y"]))
for name, x, y in movers:
    run("set_group_properties", group_name=name, move_to={"x": x + dx, "y": y + dy})
# les dessins F10 de la famille, en absolu (le cercle sur la zone, l'étiquette 3,5 ou 4,5 km au nord) ; ceux
# d'Akamas, oubliés au déplacement du 12/11 (bee652e), rejoignent leurs zones
akamas = (zones["combatZone_Akamas_Easy"]["x"], zones["combatZone_Akamas_Easy"]["y"])
for name, (px, py) in (("H cercle", new), ("H étiquette", (new[0] + 3500, new[1])),
                       ("A cercle", akamas), ("A étiquette", (akamas[0] + 4500, akamas[1]))):
    d = next(d for layer in as_list(content["drawings"]["layers"]) for d in as_list(layer.get("objects"))
             if d.get("name") == name)
    run("edit_map_drawing", layer=d["layerName"], name=name, position={"x": px, "y": py})

# 2. le moyen prend la défense infrarouge
run("remove_group", group_name="combatZone_Ceyhan_Hard-Hard-SHORAD")   # un second passage s'arrête ici
for tag in ("Hard-Manpads", "Hard-Manpads-B"):
    run("set_group_properties", group_name=f"combatZone_Ceyhan_Hard-{tag}",
        new_name=f"combatZone_Ceyhan_Medium-{tag.replace('Hard-', 'Medium-')}", acknowledge_conventions=True)
for i, brg in enumerate((200, 250), 1):
    p = off(new, brg, 1000)
    run("add_group", **RED, category="vehicle", name=f"Medium-SA13-{i}", position={"x": p[0], "y": p[1]},
        keep_position=True, for_combat_zone="combatZone_Ceyhan_Medium",
        units=[{"type": "Strela-10M3", "name": f'#command="-sa13" #spawngroup="CeyhanSR" #spawncount=1 #Medium-SA13-{i}'}])

# 3. le difficile : lanceurs radar au-delà des cibles, hors de portée de toute base bleue
bases = [FARP]
away = (NEW_CENTRE_BEARING) % 360       # le FARP est au nord : au-delà, c'est plein sud
for i, (alias, carrier) in enumerate(RADAR):
    reach = RANGES[carrier] + MARGIN
    for dist in range(1500, 3501, 250):
        brg = (away + 25 * i - 25) % 360
        p = off(new, brg, dist)
        if all(math.dist(p, b) >= reach for b in bases):
            break
    else:
        print(f"{alias} : aucune place à moins de 3,5 km des cibles hors de portée du FARP, écarté")
        continue
    print(f"H4-{i + 1} {alias} relèvement {brg}°, {dist} m des cibles, FARP à {math.dist(p, FARP) / 1000:.1f} km")
    run("add_group", **RED, category="vehicle", name=f"Hard-H4-{i + 1}", position={"x": p[0], "y": p[1]},
        keep_position=True, for_combat_zone="combatZone_Ceyhan_Hard",
        units=[{"type": carrier, "name": f'#command="{alias}" #spawngroup="CeyhanRAD" #spawncount=2 #H4-{i + 1}'}])
