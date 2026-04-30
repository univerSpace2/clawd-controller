# Clawd Controller

Two skills for managing Claude Opus 4.7 / Claude Code work with stricter scope, evidence, and verification discipline.

## Skills

- `clawd-controller`: Codex-side skill for turning a user's task into a disciplined Claude Code prompt.
- `calm-down-clawd`: Claude Code-side skill for executing coding work with guardrails against Opus 4.7 failure modes.

## Install

Install both skills through Codex's skill installer:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --method git \
  --path skills/clawd-controller skills/calm-down-clawd
```

Restart Codex after installing so the new skills are picked up.

## Install One Skill

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --method git \
  --path skills/clawd-controller
```

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo univerSpace2/clawd-controller \
  --method git \
  --path skills/calm-down-clawd
```
