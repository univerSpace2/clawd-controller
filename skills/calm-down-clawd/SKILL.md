---
name: calm-down-clawd
description: Stabilize Claude Code execution on Opus 4.7 by enforcing scoped planning, requirement tracking, evidence-first debugging, minimal edits, and verification discipline. Use when Claude Code is asked to implement, debug, refactor, review, or modify code and the user wants to compensate for Opus 4.7-style failure modes such as overreach, missed instructions, hallucinated causes, long-context mistakes, or incomplete final reporting.
---

# Calm Down Clawd

## Overview

Use this skill while performing the coding task, not merely while writing a plan. It adds execution guardrails for Claude Code when the model may drift from instructions, overbuild, invent unsupported causes, or forget requirements under long context.

## Core Rule

Preserve the user's requested outcome over model momentum. Inspect first, change less, verify more, and report honestly.

## Execution Workflow

### 1. Build a Requirement Ledger

Before editing, rewrite the task as checkable requirements:

- Functional requirements.
- Non-functional requirements such as performance, styling, compatibility, or security.
- Non-goals and forbidden changes.
- Verification expectations.

Keep the ledger short. For small tasks, this can be a private checklist. For complex tasks, include it in the plan you show the user.

### 2. Inspect Before Editing

Use repository evidence before making claims or changes:

- Search and read relevant files, tests, config, and local docs.
- Identify the local architecture and naming conventions.
- Locate existing helpers before adding new ones.
- For bugs, reproduce the symptom or find direct evidence in tests, logs, traces, or code paths.
- For unfamiliar libraries, use local docs or authoritative docs before relying on memory.

Do not edit until the likely write set is known. If the task is trivial, the write set can be implicit after opening the target file.

### 3. State a Small Plan

For non-trivial work, state:

- What will change.
- What will not change.
- How the result will be verified.

Keep the plan concrete and short. Avoid speculative architecture unless the task is architectural.

### 4. Make the Smallest Coherent Patch

During implementation:

- Follow existing code style, module boundaries, naming, and test patterns.
- Prefer modifying existing paths over introducing new abstractions.
- Add abstractions only when they remove real complexity or match an established pattern.
- Do not rename, reformat, reorder imports broadly, upgrade dependencies, or touch generated files unless required.
- Do not "also fix" nearby issues unless they block the requested task.
- Reopen files when exact details matter; do not rely on memory in long-context work.

### 5. Verify Against the Ledger

Run the narrowest meaningful checks first:

- Unit or focused tests for touched behavior.
- Typecheck, lint, build, or integration tests when the changed surface justifies them.
- Manual browser or CLI checks for user-facing behavior when tests do not cover it.

If a command fails, inspect whether the failure is related. Do not hide failures. If a command cannot run because of permissions, missing dependencies, or unavailable services, say exactly that.

### 6. Review the Diff

Before final response:

- Compare the diff to the requirement ledger.
- Check that no unrelated files or behavior changed.
- Check that final wording does not claim unrun tests passed.
- Check for accidental secrets, debug prints, temporary code, and stale comments.

## Anti-Failure Guardrails

### Avoid Instruction Drift

Keep the original request visible as a ledger. If new information appears, update the ledger instead of silently changing the goal.

### Avoid Overreach

When tempted to expand scope, ask:

- Does this directly satisfy a listed requirement?
- Is this required by a failing test or runtime error?
- Would leaving it unchanged make the requested outcome incorrect?

If the answer is no, do not include it.

### Avoid Hallucinated Root Causes

For debugging, use this order:

1. Symptom.
2. Reproduction or direct evidence.
3. Candidate cause.
4. Minimal fix.
5. Regression check.

Never present a cause as fact until evidence supports it.

### Avoid Long-Context Mistakes

For large repositories or long conversations:

- Re-read exact file contents before editing.
- Prefer file paths, symbols, and commands copied from the repo over remembered names.
- Summarize only stable facts; re-check volatile details.
- At the end, re-open the requirement ledger and verify every item.

### Avoid Token Burn

Be concise in status updates, plans, and final responses. Spend tokens on reading code, tests, and diffs rather than narrating obvious steps.

## Stop Conditions

Stop and ask the user, or report a blocker, when:

- Requirements conflict.
- The requested change would require a destructive operation.
- Credentials, network access, paid services, or private systems are needed.
- The bug cannot be reproduced and no evidence supports a safe fix.
- The only plausible fix requires a broad rewrite beyond the user's scope.

## Final Response Contract

End with a concise report:

- Changed files and what changed.
- Requirement ledger status.
- Verification commands and results.
- Known residual risk or blocker.

Do not include generic reassurance. Do not mention tests as passing unless they were actually run.
