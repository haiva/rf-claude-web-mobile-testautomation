#!/usr/bin/env bash
# Ympäristön esitarkistus. Aja projektin juuressa: bash scripts/tarkista_ymparisto.sh
cd "$(dirname "$0")/.."
ok(){ printf "  [OK]  %s\n" "$1"; }; ng(){ printf "  [!!]  %s\n" "$1"; }
has(){ command -v "$1" >/dev/null 2>&1; }

echo "== Työkalut =="
for t in git node claude; do has "$t" && ok "$t" || ng "$t puuttuu (ks. README)"; done
{ has python3 || has python; } && ok "python" || ng "python puuttuu"

echo "== Python-ympäristö (.venv) =="
if [ -x .venv/bin/robot ] || [ -x .venv/Scripts/robot.exe ]; then ok "robot asennettu .venv:iin"
else ng ".venv tai robot puuttuu (README, vaihe 3)"; fi
if [ -x .venv/bin/robotmcp ] || [ -x .venv/Scripts/robotmcp.exe ]; then ok "robotmcp asennettu .venv:iin"
else ng "robotmcp puuttuu .venv:stä (pip install -r requirements.txt)"; fi
[ -n "${VIRTUAL_ENV:-}" ] && ok ".venv aktivoitu" || ng ".venv ei ole aktiivinen (source .venv/bin/activate tai .venv/Scripts/activate)"

echo "== Tunnukset =="
[ -n "${YLE_USER:-}" ] && ok "YLE_USER asetettu" || ng "YLE_USER puuttuu (README, vaihe 4)"
[ -n "${YLE_PASSWORD:-}" ] && ok "YLE_PASSWORD asetettu" || ng "YLE_PASSWORD puuttuu"

echo "== RF-MCP =="
has robotmcp && (robotmcp doctor -C . >/dev/null 2>&1 && ok "robotmcp doctor" || ng "robotmcp doctor -C . ilmoitti ongelmasta")

echo "== Rakenne (dryrun) =="
for p in web mobile; do
  bash scripts/aja.sh "$p" --dryrun --output NONE --report NONE --log NONE >/dev/null 2>&1 \
    && ok "$p dryrun" || ng "$p dryrun epäonnistui (aja: bash scripts/aja.sh $p --dryrun)"
done
