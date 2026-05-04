# Clawd Controller

Two skills for managing Claude Opus 4.7 / Claude Code work with stricter scope, evidence, and verification discipline.

## Skills

- `clawd-controller`: Codex-side skill for turning a user's task into a disciplined Claude Code prompt.
- `calm-down-clawd`: Claude Code-side skill for executing coding work with guardrails against Opus 4.7 failure modes.

## Install

List the skills with the skills.sh CLI:

```bash
npx --yes skills add univerSpace2/clawd-controller --list
```

Install the recommended setup globally:

```bash
npx --yes skills add univerSpace2/clawd-controller \
  --skill clawd-controller \
  --agent codex \
  --global \
  --yes
```

```bash
npx --yes skills add univerSpace2/clawd-controller \
  --skill calm-down-clawd \
  --agent claude-code \
  --global \
  --yes
```

Restart Codex and Claude Code after installing so the new skills are picked up.

## Install Both Everywhere

To install both skills into both Codex and Claude Code:

```bash
npx --yes skills add univerSpace2/clawd-controller \
  --skill clawd-controller \
  --skill calm-down-clawd \
  --agent codex \
  --agent claude-code \
  --global \
  --yes
```

Omit `--global` to install into the current project instead of your user-level agent directories.
