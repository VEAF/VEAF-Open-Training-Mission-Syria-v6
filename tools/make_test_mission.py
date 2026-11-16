"""Construit la mission de test locale : profil LOCAL_TEST + game master + un A-10C II en slot classique + dcs-bridge.

Les slots dynamiques ne fonctionnent qu'en multijoueur : un test en solo a besoin d'un slot `Client` classique.
Ces ajouts vont dans la COPIE DE TEST seulement, jamais dans les sources : le build serveur ne doit pas les gagner.

Usage (depuis le dossier de la mission, environnement poetry de VMCT) :
    poetry -C ../VEAF-Mission-Creation-Tools run python "$PWD/tools/make_test_mission.py"
Sortie : bridge/bridge-Syria-OT.miz. Le build passe par le veaf-tools.exe du dossier (celui de develop,
déployé par `veaf-build publish-local`), le reste par le catalogue veaf-mission-mcp du même code.
"""

import os
import shutil
import subprocess
import time

from paths import ROOT
from mission_tools.miz_tools import read_miz, write_miz
from veaf_mission_mcp.actions import register_default_actions
from veaf_mission_mcp.catalog import ActionCatalog

BRIDGE_LUA = os.environ.get("BRIDGE_LUA", str(ROOT.parent / "VEAF-dcs-bridge" / "src" / "lua" / "dcs-bridge.lua"))
BUILT = ROOT / "VEAF_OpenTraining_Syria_LOCAL_TEST.miz"
OUT = ROOT / "bridge" / "bridge-Syria-OT.miz"
EXE = str(ROOT / "veaf-tools.exe")

# le build LOCAL_TEST réécrit src/scripts/veaf-config.lua (sécurité coupée, logs debug) : on garde la copie des
# sources et on la remet, pour qu'un commit après un test n'embarque jamais la configuration de test
CONFIG = ROOT / "src" / "scripts" / "veaf-config.lua"
config_before = CONFIG.read_bytes() if CONFIG.exists() else None
started = time.time()
try:
    subprocess.run([EXE, "build", "--profile", "LOCAL_TEST", BUILT.name], cwd=ROOT, check=True, stdout=subprocess.DEVNULL)
finally:
    if config_before is not None:
        CONFIG.write_bytes(config_before)
# le .miz que CE build a écrit : veaf-tools ajoute le suffixe du profil au nom donné (…_LOCAL_TEST_LOCAL_TEST.miz),
# et copier BUILT tel quel a fait tester un fichier d'octobre, l'ancien Ceyhan compris (16/11/2026)
fresh = [p for p in ROOT.glob("*LOCAL_TEST*.miz") if p.stat().st_mtime >= started]
if len(fresh) != 1:
    raise SystemExit(f"build LOCAL_TEST : {len(fresh)} .miz écrit(s) par ce build, attendu 1 : {fresh}")
OUT.parent.mkdir(exist_ok=True)
shutil.copy(fresh[0], OUT)

# un game master par camp
miz = read_miz(OUT)
miz.mission_content["groundControl"]["roles"]["instructor"] = {"blue": 1, "red": 1, "neutrals": 0}
write_miz(miz, OUT)

# A-10C II, au sol moteur chaud, au parking d'Incirlik (base mère)
catalog = ActionCatalog()
register_default_actions(catalog)
print(catalog.run_action("add_air_group", dict(
    mission_path=str(OUT), coalition="blue", country_id=2, country_name="USA", name="TEST A-10C II Incirlik",
    unit_type="A-10C_2", count=1, start="parking-hot", airfield="Incirlik", skill="Client", frequency_mhz=251,
    task="CAS")))

subprocess.run([EXE, "dcs", "inject-bridge", "--bridge-lua", BRIDGE_LUA, str(OUT)], cwd=ROOT, check=True)
print("OK", OUT)
