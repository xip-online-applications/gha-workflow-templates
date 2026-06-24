---
name: ai-code-review
description: Defines a strict code review process where the agent validates quality through linting, tests, complexity analysis, and critical challenge of design decisions.
---

# ai-code-review

Perform a rigorous code review that enforces quality standards. Challenge assumptions, verify correctness, and ensure the code is simple, tested, and maintainable.

## When to use

Use this skill when:

- Asked to review a pull request, diff, or set of changes
- Asked to review specific files or a feature implementation
- Performing a self-review before presenting code to the user
- Validating code quality as part of the execute phase

## Instructions

### Step 1: Run automated checks

Before any manual review, verify that automated quality gates pass.

1. **Linting.** Run the project's configured linter (e.g., `eslint`, `phpcs`, `phpstan`, `prettier --check`, `stylelint`). Report every violation. Do not proceed until lint errors are addressed or explicitly acknowledged.
2. **Type checking.** If the project uses static types (TypeScript, PHPStan, mypy), run the type checker. Zero type errors allowed.
3. **Unit tests.** Run the test suite. All existing tests must pass. If new code lacks tests, flag it as a blocking issue (see Step 4).
4. **Build.** If applicable, verify the project compiles/builds without errors or warnings.

If any automated check fails, stop the review and report the failures. Do not continue to manual review until the code is green.

### Step 2: Review for complexity

Evaluate whether the code is as simple as it can be while still meeting requirements.

1. **Cyclomatic complexity.** Flag any function or method with more than 10 branches. Suggest extraction or simplification.
2. **Function length.** Flag functions longer than 40 lines. Each function should do one thing.
3. **Nesting depth.** Flag nesting deeper than 3 levels. Suggest early returns, guard clauses, or extraction.
4. **Parameter count.** Flag functions with more than 4 parameters. Suggest using an options object, builder, or splitting responsibilities.
5. **Cognitive load.** Read the code as if seeing it for the first time. If you need to re-read a block to understand it, it is too complex. Suggest renaming, restructuring, or adding a clarifying comment only as a last resort.
6. **Duplication.** Identify repeated logic (3+ occurrences or 5+ duplicated lines). Suggest extraction into a shared function, method, or module.

### Step 3: Review for correctness

Verify the code does what it claims to do.

1. **Edge cases.** Identify inputs or states the code does not handle: nulls, empty collections, boundary values, concurrent access, error paths.
2. **Error handling.** Verify errors are caught, logged, and either recovered from or propagated meaningfully. No swallowed exceptions. No generic catch-all without re-throw.
3. **Side effects.** Identify unexpected mutations, global state changes, or I/O hidden inside pure-looking functions.
4. **Security.** Check for injection vulnerabilities (SQL, XSS, command), unsanitised user input, leaked secrets, and missing authorisation checks.
5. **Performance.** Flag obvious inefficiencies: N+1 queries, unnecessary allocations in loops, missing pagination, unbounded collections in memory.

### Step 4: Review for test coverage

Assess whether the code is adequately tested.

1. **New behaviour must have tests.** Every new public function, method, endpoint, or behaviour path requires at least one test. Flag any that are missing.
2. **Test quality.** Tests must assert meaningful outcomes, not just that code runs without crashing. Flag tests with no assertions or only trivial assertions.
3. **Edge case coverage.** At minimum, tests should cover: happy path, one error/failure path, and one boundary condition.
4. **Test isolation.** Tests must not depend on execution order, shared mutable state, or external services without mocking/faking.
5. **Naming.** Test names must describe the scenario and expected outcome (e.g., `should return 404 when order does not exist`).

### Step 5: Review for design and conventions

Verify the code fits the codebase and follows established patterns.

1. **Consistency.** Does the code follow the naming conventions, file structure, and patterns already present in the project? Flag deviations.
2. **Separation of concerns.** Is business logic mixed with infrastructure, presentation, or orchestration code? Flag violations.
3. **API design.** Are public interfaces (function signatures, class APIs, HTTP endpoints) clear, minimal, and hard to misuse?
4. **Dependency direction.** Do dependencies point in the correct direction per the project's architecture (e.g., hexagonal, layered)?
5. **SOLID principles.** Flag classes or modules that violate single responsibility, have broken abstractions, or use inheritance where composition is cleaner.

### Step 6: Challenge the engineer

Do not just find issues — actively challenge the design and approach.

1. **Ask "why".** For any non-obvious design decision, ask the author to justify it. Examples:
   - "Why is this a separate service instead of a method on the existing aggregate?"
   - "Why was inheritance chosen over composition here?"
   - "What happens if this external call fails?"
2. **Propose alternatives.** When you identify a concern, do not just flag it — suggest a concrete alternative with reasoning.
3. **Question necessity.** For every added dependency, abstraction, or layer: "Is this needed now, or is it speculative?" If speculative, recommend removal.
4. **Simulate failure.** Pick a critical path and mentally (or actually) trace what happens when it fails. Report any unhandled failure mode.
5. **Demand justification for complexity.** If something is complex, the author must prove that a simpler approach does not work. Complexity is not accepted by default.

### Step 7: Produce the review summary

Output a structured review with clear severity levels.

```markdown
## Review Summary

### Blocking (must fix before merge)
- [ ] Issue description — file:line — suggested fix

### Should fix (strongly recommended)
- [ ] Issue description — file:line — suggested fix

### Nitpick (optional improvements)
- [ ] Issue description — file:line — suggested fix

### Questions (need clarification)
- [ ] Question — file:line

### Positive observations
- What was done well
```

**Severity rules:**

- **Blocking:** failing tests, lint errors, type errors, missing tests for new code, security issues, broken functionality, data loss risk.
- **Should fix:** complexity violations, poor naming, missing error handling, design concerns, performance issues.
- **Nitpick:** style preferences beyond linter scope, minor readability improvements, documentation suggestions.

### Step 8: Verify resolution

If the engineer addresses your feedback:

1. Re-run automated checks (Step 1).
2. Verify each blocking issue is resolved.
3. Confirm "should fix" items are addressed or explicitly deferred with a reason.
4. Approve only when all blocking items are resolved and no new issues are introduced.

## Review principles

- **Be strict, not hostile.** The goal is quality, not gatekeeping. Every piece of feedback must be actionable and justified.
- **No rubber-stamping.** Never approve without thorough review. "Looks good" is not a valid review.
- **Assume bugs exist.** Review with the mindset that something is wrong — your job is to find it.
- **Simpler is better.** When in doubt, argue for the simpler solution.
- **Code is read more than written.** Optimise for the next person reading it, not the person writing it now.
