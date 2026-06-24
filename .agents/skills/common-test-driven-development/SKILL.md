---
name: common-test-driven-development
description: Guides the agent to always write unit tests first (TDD) when creating or modifying code, ensuring tests drive implementation.
---

# common-test-driven-development

Write unit tests before or alongside implementation code, following a test-driven development approach to ensure correctness and prevent regressions.

## When to use

Use this skill when:

- Creating new functions, classes, methods, or modules
- Modifying existing business logic or behavior
- Fixing bugs (write a failing test that reproduces the bug first)
- Refactoring code (ensure tests exist and pass before and after changes)
- The user asks to implement any feature or logic

## Instructions

1. **Check for existing tests first.** Before writing any implementation code, search the codebase for existing test files related to the code you are about to change.
   - Look for files matching patterns like `*.test.*`, `*.spec.*`, `*_test.*`, `test_*.*`, or a `tests/`/`__tests__/` directory.
   - If existing tests are found, run them. If they pass, preserve them — do not modify passing tests unless the assertions are no longer valid due to intentional behavior changes.
   - If existing tests fail because assertions reflect outdated behavior that conflicts with the new requirements, update only those specific assertions. Never delete or rewrite tests wholesale.

2. **Write a simple failing test first.** Before implementing any logic:
   - Create the smallest possible unit test that describes the expected behavior.
   - The test must be runnable and must fail (red phase) because the implementation does not exist yet or does not satisfy the new requirement.
   - Name the test clearly to describe the behavior being verified (e.g., `it should return the sum of two numbers` or `test_empty_list_returns_none`).
   - Do NOT write multiple tests at once — start with one.

3. **Make the test pass with minimal implementation.** Write only enough production code to make the failing test pass (green phase).
   - Do not add functionality that is not yet required by a test.
   - Do not over-engineer or anticipate future needs at this stage.
   - Run the test to confirm it passes.

4. **Refactor while keeping tests green.** Once the test passes:
   - Improve code structure, naming, or duplication without changing behavior.
   - Run all related tests after refactoring to confirm nothing broke.

5. **Repeat for additional behavior.** For each new piece of behavior:
   - Write one new failing test.
   - Make it pass with minimal changes.
   - Refactor if needed.
   - Continue until the full requirement is satisfied.

6. **Test quality rules.**
   - Each test must verify exactly one behavior or scenario.
   - Tests must be independent — no shared mutable state, no ordering dependencies.
   - Use descriptive test names that read as specifications.
   - Prefer testing public interfaces over internal implementation details.
   - Avoid mocking everything — only mock external dependencies (I/O, network, databases, clocks).
   - Keep tests fast — unit tests must not depend on network, filesystem, or databases.

7. **Test structure.** Follow the Arrange-Act-Assert (AAA) or Given-When-Then pattern:
   - **Arrange/Given**: Set up inputs and dependencies.
   - **Act/When**: Call the unit under test.
   - **Assert/Then**: Verify the output or side effect.

8. **Edge cases.** After the happy path passes, add tests for:
   - Boundary values (empty collections, zero, null/undefined, max values).
   - Error conditions (invalid input, missing data, exceptions).
   - Only add edge case tests that are relevant to the specific logic being built.

9. **Run the full related test suite.** After all changes are complete, run the full test suite for the affected module or package to ensure no regressions.

10. **Never skip tests to save time.** If you are creating code, you are creating tests. There is no scenario where production code is written without a corresponding test. If pressed for time, reduce scope — but every line of implemented scope must have test coverage.

## Examples

### TDD cycle for a simple function

```text
Step 1 — Write failing test:
  test("adds two positive numbers", () => {
    expect(add(2, 3)).toBe(5);
  });

Step 2 — Minimal implementation:
  function add(a, b) {
    return a + b;
  }

Step 3 — Test passes. Refactor if needed (nothing to refactor here).

Step 4 — Next test:
  test("returns 0 when both arguments are 0", () => {
    expect(add(0, 0)).toBe(0);
  });

Step 5 — Already passes. Move to next behavior.
```

### Handling existing tests

```text
Scenario: You need to change a function's return type from number to string.

1. Run existing tests — they pass.
2. Identify which assertions will break due to the intentional change.
3. Update ONLY those assertions to expect the new string return type.
4. Confirm updated tests fail (since implementation hasn't changed yet).
5. Change the implementation.
6. Confirm all tests pass.
```
