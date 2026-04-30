---
name: clawd-controller
description: Create disciplined Claude Code prompts from a user's task so Codex can act as an Opus 4.7 agent manager. Use when the user wants Codex to write, refine, or structure instructions for Claude Code, especially to avoid Opus 4.7-style regressions such as instruction drift, overreach, hallucinated root causes, incomplete requirement tracking, long-context misses, or excessive token burn.
---

# Clawd Controller

## Overview

Use this skill to turn a user's raw task into a Claude Code prompt with explicit scope, evidence requirements, checkpoints, and verification. The output is a prompt for Claude Code, not an implementation plan for Codex to execute locally unless the user asks Codex to do the work itself.

## Operating Rule

Default to writing the Claude Code prompt in English unless the user asks for another language. Keep user-facing explanation in the user's language.

Never send Claude Code a vague instruction like "fix this" or "implement X" by itself. Wrap the task in a control structure that makes the model preserve requirements, inspect before editing, avoid unrelated changes, and verify the result.

## Prompt-Building Workflow

1. Extract the real task.
   Identify the objective, the expected artifact or behavior, the repository area, non-goals, and the user's tolerance for broad changes. If a required fact is missing but can be discovered from the repo, instruct Claude Code to discover it. Ask the user only when a wrong assumption would be costly.

2. Convert the task into a requirement ledger.
   List each requirement as a checkable item. Include negative requirements such as "do not refactor unrelated modules" and "do not change public API unless necessary."

3. Add an inspection phase.
   Require Claude Code to inspect relevant files, tests, and conventions before proposing edits. For debugging, require reproduction or evidence before any fix.

4. Add scope boundaries.
   Name likely allowed paths when known. When unknown, require Claude Code to state the intended write set before editing. Include "do not touch unrelated files" and "do not opportunistically modernize, rename, or reformat."

5. Add anti-regression guardrails.
   Address the common Opus 4.7 failure modes directly: preserve all requirements, avoid overbuilding, do not invent causes, keep changes minimal, verify with tests, and stop when evidence contradicts the plan.

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
You are Claude Code working in an existing repository. Treat this as a scoped engineering task, not an open-ended rewrite.

Task:
<one-paragraph concrete objective>

Requirements ledger:
1. <checkable requirement>
2. <checkable requirement>
3. <negative requirement / non-goal>

Before editing:
1. Inspect the relevant files and tests.
2. Identify the current behavior and the smallest likely write set.
3. If this is a bug, establish evidence for the root cause before changing code.
4. If the requirements conflict or a key assumption cannot be checked locally, stop and ask.

Implementation rules:
- Preserve every item in the requirements ledger; do not satisfy one by dropping another.
- Keep the patch minimal and aligned with existing local patterns.
- Do not refactor, rename, reformat, upgrade dependencies, or change public behavior unless required for the task.
- Do not invent root causes, APIs, files, commands, or test results.
- Make one coherent change set, then review the diff against the ledger.

Verification:
- Run the most relevant focused checks first: <known command or "discover the existing test command">.
- Run broader checks only if the changed surface justifies it.
- If a check cannot be run, say exactly why.

Final response:
- List changed files.
- Report each requirement as done / not done / blocked.
- Include verification commands and results.
- Mention residual risks or follow-up only when real.
```

## Prompt Variants

### Bug Fix

Add this block:

```text
Bug-fix discipline:
- Reproduce or locate direct evidence before fixing.
- State the suspected cause only after evidence supports it.
- Prefer the smallest fix that addresses the cause.
- Add or update a regression test when the project has a practical test surface.
```

### Feature Work

Add this block:

```text
Feature discipline:
- Match existing architecture, naming, state management, styling, and test style.
- Implement only the user-visible behavior requested.
- Include expected empty, loading, error, and edge states only when they are part of this feature's natural workflow.
```

### Large or Risky Refactor

Add this block:

```text
Refactor discipline:
- First map current dependencies and behavior.
- Split the work into safe slices.
- Preserve public contracts unless the task explicitly changes them.
- After each slice, run the narrowest meaningful verification before continuing.
```

### Long-Context Repository Task

Add this block:

```text
Long-context discipline:
- Build a short working map of relevant files before editing.
- Re-check exact names, signatures, and requirements before using them.
- Do not rely on memory for file contents that can be reopened.
- Before finalizing, compare the diff against the original requirements ledger.
```

## Manager Output Format

When responding to the user, provide:

1. A short note explaining any important assumptions.
2. A ready-to-paste Claude Code prompt in a fenced `text` block.
3. Optional tuning knobs only if useful, such as "make this stricter", "allow broader refactor", or "force tests first."

Do not include a long essay before the prompt. The goal is to hand the user an operational prompt they can paste into Claude Code.
