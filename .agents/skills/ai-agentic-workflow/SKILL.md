---
name: ai-agentic-workflow
description: Defines the analyse-plan-execute workflow that the agent must follow for non-trivial tasks.
---

# ai-agentic-workflow

Follow a structured three-phase workflow — analyse, plan, execute — for every non-trivial task to ensure accurate, well-reasoned outcomes.

## When to use

Use this skill when:

- Receiving a task that requires more than a single-step action
- The request involves multiple files, components, or concepts
- The problem is ambiguous and needs clarification before acting
- A failure could result from acting without understanding the full context

Do **not** use this workflow for trivial requests (e.g., "rename this variable", "fix this typo") — act directly instead.

## Instructions

### Phase 1: Analyse

Understand the problem completely before proposing any solution.

1. **Read the request carefully.** Identify what the user explicitly asked for and what they likely expect but did not state.
2. **Gather context.** Explore relevant files, dependencies, and existing patterns in the codebase. Do not guess — use tools to verify assumptions.
3. **Identify constraints.** Note technology choices, architectural patterns, coding conventions, and any referenced skills that apply.
4. **Clarify ambiguity.** If the request has multiple valid interpretations and you cannot determine the correct one from context, ask a single focused question. Otherwise, proceed with the most reasonable interpretation and state your assumption.
5. **Summarise findings.** Produce a brief internal summary:
   - What needs to change
   - What already exists that is relevant
   - What constraints or patterns must be respected
   - What risks or edge cases exist

### Phase 2: Plan

Design the solution before writing any code.

1. **Break the task into discrete steps.** Each step should be independently verifiable.
2. **Order steps by dependency.** Do foundational work first (types, interfaces, models) before implementation that depends on it.
3. **Identify affected files.** List every file that will be created or modified.
4. **Consider side effects.** Will this change break existing tests, imports, or integrations? Plan for those.
5. **Choose the minimal path.** Prefer the smallest change that fully satisfies the request. Do not refactor unrelated code unless explicitly asked.
6. **Present the plan.** Output a concise numbered checklist of what you will do. If the task is large or risky, pause for user confirmation before executing. For smaller tasks, proceed immediately.

### Phase 3: Execute

Implement the plan step by step.

1. **Follow the plan in order.** Do not skip steps or change the approach mid-execution without re-planning.
2. **Implement one logical change at a time.** Complete each step fully before moving to the next.
3. **Validate as you go.** After each significant change:
   - Check for errors in modified files.
   - Run relevant tests or build commands if available.
   - Verify the change works in context (imports resolve, types align, logic flows correctly).
4. **Handle unexpected issues.** If a step fails or reveals a problem:
   - Stop and re-analyse the specific issue.
   - Adjust the remaining plan if needed.
   - Do not force through errors with workarounds unless no better option exists.
5. **Confirm completion.** When all steps are done, verify the full solution:
   - All checklist items completed
   - No introduced errors or regressions
   - The original request is fully satisfied

## Applying the phases

| Task complexity | Analyse | Plan | Execute |
|-----------------|---------|------|---------|
| Trivial (single obvious action) | Skip | Skip | Act directly |
| Small (2–5 steps, clear path) | Brief mental model | Inline checklist | Execute immediately |
| Medium (multiple files, some ambiguity) | Thorough context gathering | Explicit numbered plan | Step-by-step with validation |
| Large (cross-cutting, architectural) | Deep exploration, ask if unclear | Detailed plan, wait for confirmation | Incremental with checkpoints |

## Anti-patterns to avoid

- **Jumping to code without understanding.** Never edit files before completing analysis.
- **Planning without context.** A plan based on assumptions instead of verified facts will fail.
- **Deviating from the plan silently.** If you need to change course, acknowledge it and re-plan.
- **Over-engineering.** Implement what was asked, not what might be needed someday.
- **Incomplete execution.** Do not stop at "mostly done" — finish all steps including validation.
