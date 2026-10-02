"""Écrit le briefing DCS de la mission (titre, situation, tâches bleue et rouge) depuis briefing_data.json.

Les chiffres (fréquences, TACAN, niveaux de vol, rayons de QRA, bullseye et ravitailleur de chaque zone) sont
relevés dans la mission par gather.py : lancer gather.py avant. Le texte de contexte est écrit ici.
Passe par l'action set_briefing de veaf-mission-mcp (dossier de mission, durable).
"""

import json

from paths import ROOT, TOOLS
from veaf_mission_mcp.actions import register_default_actions
from veaf_mission_mcp.catalog import ActionCatalog

D = json.load(open(TOOLS / "briefing_data.json", encoding="utf-8"))
NAMES = {"Adana Sakirpasa": "Adana", "King Hussein Air College": "King Hussein AC"}


def fl(ft):
    return f"FL{round(ft / 100):03d}"


def support_line(s):
    kind = {"KC-135": "perche", "KC135MPRS": "panier", "IL-78M": "panier"}.get(s["type"], "")
    tac = f" TACAN {s['tacan']}" if s["tacan"] else ""
    what = f"{s['type']}, {kind}" if kind else s["type"]
    return f"- {s['name']} ({what}){tac} U{s['freq']:.1f} {fl(s['alt_ft'])}"


blue_support = [s for s in D["support"] if s["side"] == "blue" and s["name"] != "Darkstar 1"]
red_support = [s for s in D["support"] if s["side"] == "red" and s["name"] != "Focus 1"]
qra_red = [q for q in D["qra"] if q["side"] == "red"]
qra_blue = [q for q in D["qra"] if q["side"] == "blue"]
real = [z for z in D["zones"] if not z["training"]]
blue_bases = [NAMES.get(b["name"], b["name"]) for b in D["bases"] if b["side"] == "blue"]
red_bases = [b["name"] for b in D["bases"] if b["side"] == "red"]

situation = f"""VEAF Open Training — Syrie, juin 2017.
La coalition (Turquie, Israël, Jordanie, Royaume-Uni à Chypre, garnison américaine d'At Tanf) fait face au régime syrien et à ses alliés russes. Deux fronts : la frontière turco-syrienne au nord, le Golan et la frontière jordanienne au sud. Le Liban, le nord de Chypre et l'Irak sont neutres. La ligne de front tracée sur la carte est approximative.

Météo au départ : ${{METAR}}
Bullseye : Homs {D['bullseye']['ddm']}, le même pour les deux camps.

COMBAT ENTRE JOUEURS
Autorisé sur le théâtre et dans l'arène (ouest de Chypre, au-dessus de la mer, rayon {D['arena_zone']['radius_nm']} nm, bullseye {D['arena_zone']['be']}). INTERDIT dans les sanctuaires (hexagones) autour de chaque base et FARP avec slots : un intrus est averti, puis détruit au bout de 60 s ; les missiles tirés sur un appareil qui s'y trouve sont détruits.

SOUTIEN BLEU (menu F10 > Assets ; tous escortés)
{chr(10).join(support_line(s) for s in blue_support)}
- Stennis TACAN 74X ICLS 11 U305.0 ; Roosevelt 71X ICLS 12 U306.0 ; Tarawa 73X ICLS 13 U307.0.
- S-3B embarqués : Stennis 55Y U295.0, Roosevelt 56Y U296.0.
- FARP {", ".join(f"{f['name']} {float(f['freq']):.1f}" for f in D["farps"])} (VHF AM), avec dépôt de munitions (CTLD).

QRA (décollage 90 s après l'entrée du premier intrus ; pas de réaction aux hélicoptères)
- Rouges : {" ; ".join(f"{q['name']} ({q['radius_nm']} nm autour de {q['airport']})" for q in qra_red)}. Le centre (Homs) et le désert restent libres.
- Bleues : {" ; ".join(f"{q['name']} ({q['radius_nm']} nm)" for q in qra_blue)}.

ZONES (menu F10 > Zones de combat)
Entraînement : H1-H3 hélicoptères à Ceyhan, A1-A3 attaque à Akamas (Chypre), S1-S3 SEAD à Karpas (Chypre du Nord).
{chr(10).join(f"- {z['name']} : bullseye {z['be']}." for z in real)}
Le briefing de chaque zone (menu F10 > la zone > Infos) donne ses coordonnées et les ravitailleurs les plus proches.

CAP à la demande, missions scénarisées (escorte, interception) : menu F10 > Missions de combat.
Commandes VEAF utiles (marqueur F10) : « -tanker Texaco 1 » amène ce ravitailleur sur le marqueur ; « -tankerhigh » / « -tankerlow » passent le ravitailleur le plus proche au FL220 / FL120 ; « -afac » fait apparaître un drone de guidage laser ; « -point NOM » nomme un point."""

blue = f"""Bleu — bases avec slots : {", ".join(blue_bases)} ; porte-avions Stennis, Roosevelt et Tarawa ; FARP {", ".join(f["name"] for f in D["farps"])}.
Choisissez une zone dans le menu F10, activez-la, puis allez la détruire. Les bases rouges avec slots ({", ".join(red_bases)}) sont des sanctuaires : n'y entrez pas."""

red = f"""Rouge — bases avec slots : {", ".join(red_bases)}.
Soutien : {" ; ".join(support_line(s)[2:] for s in red_support)}.
Interceptez les appareils de la coalition qui viennent frapper le territoire ; les CAP bleues se lancent depuis le menu F10 > Missions de combat. Les bases bleues avec slots sont des sanctuaires : n'y entrez pas. Pas de zone de combat côté rouge ; l'arène est ouverte aux deux camps (slots en vol)."""

catalog = ActionCatalog()
register_default_actions(catalog)
result = catalog.run_action("set_briefing", {"mission_path": str(ROOT), "sortie": "VEAF Open Training — Syrie",
                                             "situation": situation, "blue_task": blue, "red_task": red})
print(f"VERDICT : briefing écrit ({len(situation)} caractères de situation) — {result['written']}")
