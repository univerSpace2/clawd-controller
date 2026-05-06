# Clawd Controller

Practical guardrails for multi-agent coding workflows. Two skills that reduce common coding-agent failures — scope creep, instruction drift, hallucinated root causes, and unverified claims — when Codex delegates work to Claude Code.

## How It Works

```
User → Codex (clawd-controller) → structured prompt → Claude Code (calm-down-clawd) → verified result
```

1. You describe a coding task to Codex.
2. Codex uses `clawd-controller` to build a scoped prompt with requirements, boundaries, and verification criteria.
3. You paste the prompt into Claude Code.
4. Claude Code uses `calm-down-clawd` to execute with inspect-first discipline and honest reporting.

## Skills

- **`clawd-controller`** — Codex-side prompt builder. Converts a user's coding request into a structured Claude Code task prompt.
- **`calm-down-clawd`** — Claude Code-side execution guardrail. Enforces scoped planning, minimal changes, evidence-based debugging, and honest verification during implementation.

## Recommended Setup

Install each skill only in its intended agent:

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

Restart Codex and Claude Code after installing.

> **Why not install both everywhere?** Each skill is written for a specific role. `clawd-controller` speaks to Codex about how to *write* prompts. `calm-down-clawd` speaks to Claude Code about how to *execute* tasks. Installing both in both agents causes role confusion and redundant instructions.

Omit `--global` to install into the current project instead of your user-level agent directories.
