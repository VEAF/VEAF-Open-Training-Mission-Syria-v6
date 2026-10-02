## Pour les créateurs de mission

Construite de zéro le 02/10/2026 avec VEAF Mission Creation Tools (`veaf-tools`) et le serveur MCP `veaf-mission-mcp`,
d'après le prompt Open Training de VMCT, en s'inspirant de l'Open Training Syrie v5 (`VEAF-Open-Training-Mission-Syria`)
sans la recopier : bases, QRA, CAP et esprit repris ; Damas et le Liban, bleus en v5, rendus au régime et à la neutralité.

### Construire

```powershell
# outils et scripts VEAF installés par l'updater (veaf-tools.exe + published/, hors dépôt)
.\veaf-tools.exe validate

# configuration serveur : sécurité active, logs info, 15 variantes météo dans missions/
.\veaf-tools.exe build

# essais sur un poste : sécurité coupée, logs debug, noms de groupes lisibles, pas de variantes
.\veaf-tools.exe build --profile LOCAL_TEST
```

Mission de test locale (game master, A-10C II en slot classique au sol moteur chaud à Incirlik, pont dcs-bridge) :
`tools/make_test_mission.py` → `bridge/bridge-Syria-OT.miz`. Les slots dynamiques ne marchent qu'en multijoueur.

### Fichiers

| Fichier | Rôle |
|---|---|
| `mission.yaml` | Identité, sécurité, profil `LOCAL_TEST`, modules, zones (niveaux imbriqués par `includes:`), QRA, CAP, missions scénarisées, actifs, sanctuaires |
| `src/mission/` | La mission DCS éclatée (groupes, zones de déclenchement, aérodromes, dessins F10, briefing) |
| `src/presets.yaml` | Plan radio bleu et rouge ; canaux d'aérodromes aux fréquences que DCS donne aux tours |
| `src/versions.yaml` | Variantes météo et heure (METAR réel de LTAG, dégagé, épars, pluie) |
| `src/waypoints.yaml` | Points de navigation injectés dans les appareils joueurs |
| `src/warehouses.yaml` | Bases qui offrent des slots (`exclude_airports` pour les autres), carburant et munitions illimités |
| `src/dynamic-slot-templates.yaml` | Appareils proposés en slots dynamiques, de l'époque seulement (WW2 et premiers jets retirés) |
| `docs/carte.jpg`, `docs/cartes/` | La carte de ce briefing et ses zooms (fond OpenStreetMap) ; les mêmes images sont dans `src/mission/l10n/DEFAULT/` pour le briefing DCS, listées côté bleu et neutre seulement |
| `tools/` | Scripts qui lisent la mission et produisent briefing, cartes et contrôles |

### Régénérer ce document

Ce README est **généré depuis la mission**. Après tout changement, depuis le dossier de la mission, avec l'environnement
poetry de VMCT (chemin absolu des scripts : `poetry -C` change de répertoire) :

```powershell
poetry -C ..\VEAF-Mission-Creation-Tools run python "$PWD\tools\gather.py"              # mission -> tools/briefing_data.json
poetry -C ..\VEAF-Mission-Creation-Tools run python "$PWD\tools\sync_zone_briefings.py" # ligne « Position » des briefings de zone
poetry -C ..\VEAF-Mission-Creation-Tools run python "$PWD\tools\gen_briefing.py"        # briefing DCS
poetry -C ..\VEAF-Mission-Creation-Tools run python "$PWD\tools\gen_readme.py"          # ce README, et les cartes (gen_map.py)
poetry -C ..\VEAF-Mission-Creation-Tools run python "$PWD\tools\verify.py"              # contrôles des .miz construits (ligne VERDICT)
```

### Limites connues

- Les placements au sol (statiques, sites sol-air, convois) ne sont pas vérifiés contre le décor de DCS : aucun catalogue
  de terrain dégagé n'existe pour la Syrie. À vérifier en jeu, comme les dessins F10 et l'aspect du ciel.
- Les portées utilisées pour le contrôle des défenses sont le `ThreatRange` de DCS (dump de la base d'unités du 16/11/2025).
- Les missions scénarisées n'ont pas de condition de réussite ou d'échec (le YAML ne sait pas en porter).
- Le menu F10 *Assets* montre aux deux camps les actifs des deux camps.
- Codes laser des drones : CTLD ne retire pas de sa plage un code imposé et annonce une fréquence calculée depuis le code,
  pas celle d'ASSETS (correction en cours dans VMCT). D'où `jtacLaserCodeMax: 1686` dans `ctld-config.yaml` (le modèle
  `veafSpawn-MQ9 - AFAC - JTAC - DRONE` prend 1686) et des Reaper en bas de plage, 1511 et 1512, sur la fréquence que
  CTLD en déduit (35.55 et 35.6 FM).
