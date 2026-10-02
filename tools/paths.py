"""Où sont le dossier de la mission et le code Python de VMCT, pour chaque script de tools/.

VMCT_PY pointe sur src/python/veaf-tools d'un checkout de VMCT (develop) ; par défaut le dépôt voisin
../VEAF-Mission-Creation-Tools. Lancer les scripts avec l'environnement poetry de VMCT, chemin ABSOLU du
script (poetry -C change de répertoire) :

    poetry -C ../VEAF-Mission-Creation-Tools run python "$PWD/tools/gather.py"
"""

import os
import sys
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent
VMCT_PY = os.environ.get("VMCT_PY", str(ROOT.parent / "VEAF-Mission-Creation-Tools" / "src" / "python" / "veaf-tools"))

if VMCT_PY not in sys.path:
    sys.path.insert(0, VMCT_PY)
    print(f"[tools] code VMCT : {VMCT_PY}", file=sys.stderr)
