#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-univerSpace2/clawd-controller}"
REF="${REF:-main}"
INSTALLER="${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py"

python3 "$INSTALLER" \
  --repo "$REPO" \
  --ref "$REF" \
  --path skills/clawd-controller \
  --path skills/calm-down-clawd

echo "Installed clawd-controller and calm-down-clawd. Restart Codex to pick up new skills."
