---
name: security-defensive-programming
description: Guides the agent to apply defensive programming practices — validating inputs, handling failures safely, and preventing common vulnerability classes in every piece of code it writes.
---

# security-defensive-programming

Write code that anticipates misuse, invalid input, and unexpected conditions — failing safely rather than silently corrupting state or exposing vulnerabilities.

## When to use

Use this skill when:

- Writing or modifying any function that accepts external input (HTTP requests, CLI arguments, file contents, environment variables, database results, message queues)
- Creating APIs, controllers, services, or data processing logic
- Handling authentication, authorization, or session management
- Working with file systems, databases, or network calls
- Constructing queries, commands, or output that includes dynamic values
- The user asks to implement any feature that processes data from an untrusted or semi-trusted source

## Core concepts

Defensive programming assumes that **all input is hostile until proven otherwise** and that **any operation can fail**. The goal is not to over-engineer but to prevent entire vulnerability classes by applying consistent, minimal safeguards at the right boundaries.

Key principles:

- **Validate at the boundary, trust within.** Validate input once at the entry point (controller, handler, public API method). Internal functions may assume validated data after that boundary check.
- **Fail fast and explicitly.** Reject invalid state immediately with clear errors rather than propagating corrupt data deeper into the system.
- **Least privilege.** Grant only the minimum access, scope, or capability needed for the operation.
- **Defence in depth.** Do not rely on a single layer. Combine input validation, parameterised queries, output encoding, and access checks.

## Instructions

### 1. Input validation

For every function that accepts external input:

1. **Define the expected shape.** Specify the type, format, length, range, and allowed characters before processing.
2. **Reject anything that does not match.** Use an allowlist approach — define what IS valid rather than trying to blacklist what is invalid.
3. **Validate early.** Perform validation at the system boundary (controller, API handler, CLI parser) before the data reaches business logic.
4. **Sanitise where necessary.** If input must be passed to a context where special characters have meaning (HTML, SQL, shell, regex), apply context-appropriate encoding or escaping — or better, use parameterised APIs.
5. **Treat absence as invalid unless explicitly optional.** If a field is required, reject its absence — never silently default to an unsafe value.

Decision tree:

- If the language/framework offers a schema/validation library (e.g., Zod, Joi, class-validator, Pydantic, JSON Schema) → use it.
- If no library is available → write explicit guard clauses at the function entry.

### 2. Output encoding and injection prevention

Never construct executable strings (SQL, HTML, shell commands, LDAP queries, log entries) via string concatenation with user-supplied data.

1. **SQL** → Always use parameterised queries or prepared statements. Never interpolate values.
2. **HTML** → Use the framework's templating engine with auto-escaping enabled. If rendering raw HTML is required, use a well-tested sanitizer library.
3. **Shell commands** → Avoid spawning shell processes with user input. If unavoidable, use array-based APIs (e.g., `execFile` not `exec`, `subprocess.run([...])` not `subprocess.run(shell=True)`).
4. **Logging** → Sanitize or encode user input before writing to logs to prevent log injection and forgery.
5. **URLs and redirects** → Validate redirect targets against an allowlist of domains or paths. Never redirect to an unvalidated user-supplied URL.

### 3. Error handling and failure safety

1. **Catch specific errors.** Never write bare `catch` or `except` blocks without at least logging or re-raising. Catch only the expected failure modes.
2. **Do not expose internals.** Error messages returned to users must not reveal stack traces, file paths, database schemas, or internal state. Log details server-side; return generic messages client-side.
3. **Fail closed.** If a security check cannot determine whether access is allowed (e.g., the auth service is unreachable), deny access by default.
4. **Clean up resources.** Use try-finally, `using`/`with` blocks, or RAII patterns to ensure file handles, connections, and locks are released on all code paths.
5. **Avoid swallowing errors.** If you catch an exception, you must either handle it meaningfully, re-throw it, or log it. Empty catch blocks are never acceptable.

### 4. Authentication and authorization

1. **Never roll your own crypto or auth.** Use well-established libraries and platform features.
2. **Check authorization on every protected operation.** Do not rely solely on UI-level hiding — enforce access rules server-side.
3. **Use constant-time comparison for secrets.** Comparing tokens, hashes, or API keys must use timing-safe comparison functions.
4. **Invalidate sessions and tokens properly.** On logout or permission change, ensure old tokens cannot be reused.

### 5. Secrets and sensitive data handling

1. **Never hardcode secrets.** API keys, passwords, tokens, and certificates must come from environment variables, secret managers, or encrypted configuration — never from source code.
2. **Never log secrets.** Before logging request/response objects, strip or redact sensitive fields (passwords, tokens, credit card numbers, PII).
3. **Minimise sensitive data in memory.** Do not store passwords in plain text variables longer than needed. Clear buffers after use where the language allows.
4. **Use HTTPS/TLS for all external communication.** Never send sensitive data over unencrypted channels.

### 6. Null/undefined safety

1. **Check for null/undefined before accessing properties or calling methods** — unless the language's type system provably guarantees non-null.
2. **Use the type system to express optionality.** Prefer `Optional<T>`, nullable types, or union types over relying on runtime checks alone.
3. **Return meaningful defaults or error values** rather than returning null when the caller cannot handle absence.

### 7. Concurrency and race conditions

1. **Identify shared mutable state.** If two code paths can read/write the same resource concurrently, protect it (mutex, transaction, atomic operation).
2. **Avoid time-of-check-to-time-of-use (TOCTOU) bugs.** Do not separate a permission check from the operation it guards — combine them atomically where possible.
3. **Use idempotency patterns** for operations that may be triggered multiple times (retries, message redelivery).

### 8. Dependency and supply chain awareness

1. **Pin dependency versions.** Use lock files and specify exact versions for production dependencies.
2. **Check for known vulnerabilities** in dependencies before adding them (use tools like `npm audit`, `pip-audit`, `trivy`, or Dependabot).
3. **Minimise dependency surface.** Prefer well-maintained, widely-used libraries. Do not add a dependency for trivial functionality.

### 9. Self-validation checklist

After writing or modifying code, verify:

- [ ] All external inputs are validated before use.
- [ ] No dynamic strings are assembled with unsanitised user data for SQL, HTML, shell, or log contexts.
- [ ] Errors are handled explicitly and do not leak internal details.
- [ ] Secrets are not hardcoded or logged.
- [ ] Authorization is enforced server-side for protected operations.
- [ ] Nullable values are checked before access.
- [ ] Resources (connections, handles) are cleaned up in all code paths.
- [ ] No new dependencies introduced without a clear need and vulnerability check.

## Anti-patterns to avoid

- **"Trust the frontend."** Never assume client-side validation is sufficient — always re-validate server-side.
- **"It's only internal."** Internal services get compromised. Apply the same defensive principles regardless of network position.
- **"We'll add security later."** Security bolted on after the fact is fragile. Build it in from the start.
- **"Blacklist the bad stuff."** Blacklists are always incomplete. Use allowlists to define what is accepted.
- **"Catch all, ignore all."** Swallowing exceptions hides bugs and security failures. Handle or propagate every error.
- **"It works on my machine."** Environment differences expose assumptions. Validate configuration and fail fast if required values are missing.
