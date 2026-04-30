# Clawd Controller

Two skills for managing Claude Opus 4.7 / Claude Code work with stricter scope, evidence, and verification discipline.

## Skills

- `clawd-controller`: Codex-side skill for turning a user's task into a disciplined Claude Code prompt.
- `calm-down-clawd`: Claude Code-side skill for executing coding work with guardrails against Opus 4.7 failure modes.

## Install

Install both skills into Codex:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --path skills/clawd-controller \
  --path skills/calm-down-clawd
```

Or use the helper script:

```bash
./install.sh
```

Restart Codex after installing so the new skills are picked up.

## Install One Skill

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --path skills/clawd-controller
```

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --path skills/calm-down-clawd
```
