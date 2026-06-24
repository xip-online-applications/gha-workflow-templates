---
name: common-conventional-commits
description: Guides the agent to always write commit messages following the Conventional Commits 1.0.0 specification, ensuring structured, parseable, and semantically meaningful commit history.
---

# common-conventional-commits

Write all commit messages following the Conventional Commits 1.0.0 specification — producing structured, consistent commit history that enables automated tooling and clear communication.

## When to use

Use this skill when:

- Writing a commit message (via `git commit`, interactive rebase, squash, etc.)
- Suggesting a commit message to the user
- Reviewing or correcting a commit message
- Splitting work into multiple commits and deciding how to describe each

## Instructions

### 1. Commit message structure

Every commit message must follow this format:

```text
<type>[(<ticket-number>)]: <description>

[optional body]

[optional footer(s)]
```

### 2. Type (required)

The first word of the commit must be a type — a noun describing the category of change. Use lowercase.

| Type | When to use |
|------|-------------|
| `feat` | Adds a new feature (correlates with MINOR in SemVer) |
| `fix` | Fixes a bug (correlates with PATCH in SemVer) |
| `docs` | Documentation-only changes |
| `style` | Code style changes (formatting, whitespace) — no logic change |
| `refactor` | Code restructuring that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `build` | Changes to the build system or external dependencies |
| `ci` | Changes to CI configuration files and scripts |
| `chore` | Maintenance tasks that don't modify src or test files |
| `revert` | Reverts a previous commit |

Decision tree:

- Does it add new functionality the user can observe? → `feat`
- Does it fix broken behaviour? → `fix`
- Does it change how code is structured without changing behaviour? → `refactor`
- Does it only affect tests? → `test`
- Does it only affect docs? → `docs`
- Does it improve speed/resource usage? → `perf`
- Does it change build/CI config? → `build` or `ci`
- None of the above? → `chore`

### 3. Scope (optional)

A scope may be provided in parentheses after the type to indicate the section of the codebase affected. The scope must be a noun.

```text
feat(auth): add OAuth2 login flow
fix(parser): handle empty arrays correctly
docs(readme): update installation instructions
```

Use scopes consistently within a project. Common scopes include module names, feature areas, or package names.

### 4. Ticket number (preferred)

Include the ticket number from the issue tracker as the commit scope. Extract the ticket number from the current git branch name.

Rules:

1. Run `git branch --show-current` to get the branch name.
2. Extract the ticket number — it is the uppercase identifier matching the pattern `<PROJECT>-<number>` (e.g., `XODO-123`, `PROJ-42`).
3. Use the ticket number as the scope in parentheses after the type.
4. If no ticket number can be determined from the branch name, omit it.

```text
// Branch: feat/XODO-123-add-user-registration
feat(XODO-123): add user registration page

// Branch: fix/XODO-456-login-session-expired
fix(XODO-456): resolve login failure when session is expired

// Branch: main (no ticket number)
chore: update dependencies
```

### 5. Description (required)

The description immediately follows the colon and space after the type/scope prefix (and ticket number, if present).

Rules:

1. Use imperative mood ("add feature" not "added feature" or "adds feature").
2. Do not capitalise the first letter.
3. Do not end with a period.
4. Keep it concise — aim for under 72 characters total (type + scope + description).
5. Describe **what** the commit does, not **how**.

```text
// Bad
feat: Added the new user registration page.
fix: This fixes the bug where users couldn't log in

// Good
feat: add user registration page
fix: resolve login failure when session is expired
```

### 6. Body (optional)

A longer body may be provided after one blank line following the description. Use the body to explain **what** and **why**, not **how** (the diff shows how).

- Free-form text.
- May consist of multiple paragraphs separated by blank lines.
- Use imperative mood.

```text
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.
```

### 7. Footer(s) (optional)

Footers are provided one blank line after the body. Each footer consists of a token, a separator (`` : `` or `` # ``), and a value.

Common footers:

- `BREAKING CHANGE: <description>` — indicates a breaking API change (correlates with MAJOR in SemVer)
- `Refs: #<issue-number>` — references related issues
- `Reviewed-by: <name>` — attribution
- `Co-authored-by: <name> <email>` — co-authors

Footer tokens use `-` in place of spaces (e.g., `Acked-by`), except for `BREAKING CHANGE` which is allowed as-is.

### 8. Breaking changes

Breaking changes must be indicated in one of two ways (or both):

1. **A `!` after the type/scope, before the colon:**

   ```text
   feat!: remove deprecated API endpoints
   feat(api)!: change response format for /users
   ```

2. **A `BREAKING CHANGE:` footer:**

   ```text
   feat: change response format for /users

   BREAKING CHANGE: the /users endpoint now returns an array instead of an object wrapper
   ```

If `!` is used, the `BREAKING CHANGE:` footer may be omitted and the description serves as the breaking change explanation.

### 9. One logical change per commit

Each commit must represent exactly one logical change. If a commit conforms to more than one type, split it into multiple commits.

- Do not mix a bug fix with a refactor in the same commit.
- Do not mix a feature with unrelated style changes.
- This enables meaningful changelogs and clean reverts.

### 10. Examples

```text
feat(XODO-123): add email notification on order completion
```

```text
fix(XODO-456): resolve token refresh loop on expired sessions
```

```text
docs(XODO-789): correct installation steps for Docker setup
```

```text
refactor(XODO-101): extract price calculation into dedicated service
```

```text
feat(XODO-202)!: change pagination response envelope

BREAKING CHANGE: list endpoints now return { data, meta } instead of a flat array

Refs: #452
```

```text
revert(XODO-123): add email notification on order completion

Refs: 676104e
```

### 11. Validation checklist

Before finalising a commit message, verify:

- [ ] Starts with a valid type in lowercase.
- [ ] Scope (if present) is a noun in parentheses.
- [ ] A colon and space separate type/scope from description.
- [ ] Ticket number from branch is used as scope (if available).
- [ ] Description is in imperative mood, lowercase first letter, no trailing period.
- [ ] Total first line is ≤ 72 characters.
- [ ] Body (if present) is separated by one blank line.
- [ ] Breaking changes are indicated with `!` and/or `BREAKING CHANGE:` footer.
- [ ] The commit represents a single logical change.

## References

- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
