---
name: clawd-controller
description: Convert a user's coding request into a scoped Claude Code task prompt. Use in Codex when preparing implementation instructions for Claude Code. Creates a structured brief with a requirement ledger, inspection instructions, allowed write scope, verification plan, stop conditions, and final response contract to reduce common coding-agent failures such as requirement drift, overreach, hallucinated root causes, and unverified claims.
---

# Clawd Controller

## Overview

Use this skill to turn a user's raw coding request into a paste-ready prompt for Claude Code. The prompt should give Claude Code explicit scope, a requirement ledger, inspection instructions, boundaries, verification expectations, stop conditions, and a final response contract.

This skill is for Codex-side prompt preparation. Codex should not modify the repository while using this skill unless the user directly asks Codex to do the implementation work itself.

## Operating Rule

Default to writing the Claude Code prompt in English unless the user asks for another language. Keep user-facing explanation in the user's language.

Never send Claude Code a vague instruction like "fix this" or "implement X" by itself. Wrap the task in a control structure that makes the model preserve requirements, inspect before editing, avoid unrelated changes, and verify the result.

## Prompt-Building Workflow

0. Classify the task.
   Determine the task type and scale before building the prompt:
   - Quick fix (1-3 files, clear symptom): Lightweight prompt. Skip the plan phase. Short ledger.
   - Standard task (known scope, testable outcome): Full prompt with all sections.
   - Exploratory (unclear scope or root cause): Split into an investigation prompt and a separate implementation prompt. Do not combine "find the problem" and "fix it" into one prompt.
   Match the prompt weight to the task scale. Do not wrap a one-line fix in a 200-word control structure.

1. Extract the real task.
   Identify the objective, the expected artifact or behavior, the repository area, non-goals, and the user's tolerance for broad changes. If a required fact is missing but can be discovered from the repo, instruct Claude Code to discover it. Ask the user only when a wrong assumption would be costly.

2. Convert the task into a requirement ledger.
   List each requirement as a checkable item. Include negative requirements such as "do not refactor unrelated modules" and "do not change public API unless necessary."

3. Add an inspection phase.
   Instruct Claude Code to inspect relevant files, tests, and conventions before proposing edits. For debugging, include a requirement to gather reproduction evidence or direct code evidence before any fix.

4. Add scope boundaries.
   Name likely allowed paths when known. When unknown, instruct Claude Code to state the intended write set before editing. Include prompt language that separates allowed paths from forbidden areas and unrelated work.

5. Add anti-regression guardrails.
   Address common coding-agent failure modes. Include in the prompt: preserve all requirements, avoid overbuilding, do not invent causes, keep changes minimal, verify with actual checks, and stop when evidence contradicts the plan.

6. Add checkpoints.
   For small tasks, one checkpoint before editing is enough. For broad tasks, require a short plan, then implementation, then a verification summary. Do not require excessive ceremony for simple changes.

7. Add a final response contract.
   Require Claude Code to report changed files, requirement status, verification commands and results, and any unresolved risk. The final answer must not bury failed tests.

## Required Prompt Sections

Every generated Claude Code prompt should include these sections unless the user asks for a very short prompt:

- **Role**: Define Claude Code as a scoped engineering agent, not a product brainstormer.
- **Task**: State the concrete user goal.
- **Requirements Ledger**: Checkable requirements and non-goals.
- **Inspection First**: Files, tests, commands, or evidence Claude Code should gather before editing.
- **Implementation Rules**: Minimal patch, follow local patterns, no unrelated refactors.
- **Verification**: Focused tests, broader tests if risk justifies them, and explicit failure reporting.
- **Stop Conditions**: Ask or stop when the task is ambiguous, contradictory, or blocked by missing credentials, network, permissions, or unreproducible behavior.
- **Final Answer Contract**: Changed files, status per requirement, tests run, residual risk.

## Claude Code Prompt Template

Use this as the default shape:

```text
You are Claude Code working in this repository. Treat this as a scoped engineering task.

Task:
<one-paragraph concrete objective>

Requirement ledger:
- [ ] <checkable requirement>
- [ ] <checkable requirement>
- [ ] <negative requirement / non-goal>

Context to inspect first:
- <file, test, config, or command to examine before editing>
- <for bugs: reproduction evidence or direct symptom location>

Allowed write scope:
- <specific paths or modules, or "state write set before editing">

Do not change:
- <explicitly forbidden areas, files, or behaviors>

Verification:
- <specific test command or "discover the project's test command">
- If a check cannot be run, say exactly why.

Stop conditions:
- Stop and ask if requirements conflict or scope becomes unclear.
- Stop if the bug cannot be reproduced and no evidence supports a fix.
- Stop if credentials, network, or paid services are needed.

Final response:
| File | What changed |
|------|-------------|
| ...  | ...         |

| # | Requirement | Status | Evidence |
|---|------------|--------|----------|
| 1 | ...        | ✅/❌/⏸ | ...     |

Verification performed:
- `<command>` → <actual result>
- Or: "Not run: <reason>"

Residual risk: <"None" or specific concern>
```

## Prompt Variants

### Bug Fix

For bug-fix tasks, add to the prompt:

```text
Bug-fix discipline:
- State observed symptom and reproduction evidence before proposing a cause.
- Do not state a root cause as fact without supporting evidence from code, logs, or tests.
- Prefer the smallest fix that addresses the evidenced cause.
- Add a regression test if the project has a practical test surface.
```

### Feature Work

For feature tasks, add to the prompt:

```text
Feature discipline:
- Implement only the user-visible behavior requested.
- Match existing architecture, naming, state management, and test style.
- Include error/empty/loading states only when part of this feature's natural workflow.
- Note any API or data contract changes explicitly.
```

### Large or Risky Refactor

For refactor tasks, add to the prompt:

```text
Refactor discipline:
- Map current dependencies and behavior before changing anything.
- Preserve public contracts unless the task explicitly changes them.
- Split into safe slices; verify after each slice.
- No opportunistic cleanup outside the stated scope.
```

### Long-Context Repository Task

For long-context tasks, add to the prompt:

```text
Long-context discipline:
- Build a short file map of relevant modules before editing.
- Re-read file contents before editing if more than a few tool calls have passed since last read.
- Re-check the requirement ledger before writing the final response.
- Stop if context uncertainty becomes high; ask rather than guess.
```

## Common Mistakes to Avoid in Generated Prompts

Do not generate prompts that:
- Say "fix this" or "implement X" without scope, ledger, or verification.
- Include execution rules that duplicate what Claude Code's own guardrail skill already enforces (inspect first, minimal patch, honest reporting). Focus on task-specific context instead.
- Combine investigation and implementation into one prompt when the root cause is unknown. Split them.
- Require excessive ceremony for trivial changes (e.g., a full requirement ledger for a typo fix).
- Specify verification commands that do not exist in the project. Use "discover the project's test command" when unsure.

## Manager Output Format

When responding to the user, provide:

1. Task classification (quick fix / standard / exploratory) and any important assumptions, in 1-2 sentences.
2. A ready-to-paste Claude Code prompt in a fenced `text` block.
3. Optional tuning knobs only if useful: "make this stricter", "allow broader refactor", "split into two prompts", "force tests first."

Do not write a long essay before the prompt. The goal is a paste-ready operational prompt.
