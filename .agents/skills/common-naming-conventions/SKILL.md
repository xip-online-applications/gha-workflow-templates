---
name: common-naming-conventions
description: Guides the agent to apply consistent, meaningful naming conventions across all code — variables, functions, classes, files, and infrastructure — ensuring readability and predictability.
---

# common-naming-conventions

Apply consistent, intention-revealing naming conventions to all code artifacts — making the codebase readable, searchable, and self-documenting.

## When to use

Use this skill when:

- Writing or modifying any code (variables, functions, classes, interfaces, files, directories)
- Creating database schemas, API endpoints, or configuration keys
- Naming test files, test cases, or test fixtures
- Defining environment variables, constants, or feature flags
- Reviewing code and noticing inconsistent or unclear naming

## Instructions

### 1. Use English

All code, variable names, comments, documentation, commit messages, and branch names must be written in English. No exceptions.

### 2. Be descriptive — choose clarity over brevity

Do not worry about long names. A long descriptive name is better than a short enigmatic name. A long descriptive name is better than a long descriptive comment.

1. The name must answer: what does it hold, what does it do, or what does it represent?
   - Bad: `d`, `tmp`, `data`, `result`, `info`, `val`, `item`
   - Good: `elapsedDays`, `parsedResponse`, `activeUsers`, `validationResult`
2. Avoid meaningless qualifiers like `data`, `temp`, `obj`, `value`, `stuff`. If you feel the need to append these, the name is not specific enough.

### 3. Be consistent

Use one name for one concept. Do not use names that can have more than one meaning. Align naming with the whole team, including non-technical teams (marketing, management, product). If the project includes a dictionary or ubiquitous language, follow it.

- Choose `get` OR `fetch` OR `retrieve` — not all three for the same operation.
- Choose `create` OR `add` OR `insert` — not interchangeably.
- Do not alternate between `user`, `account`, and `person` for the same entity.

### 4. Always be affirmative

Never use negated boolean names. Negations add cognitive load by forcing the reader to correct for double-negatives.

- Bad: `notEditable`, `disabled`, `isNotValid`, `noResults`
- Good: `isEditable`, `isEnabled`, `isValid`, `hasResults`

### 5. Don't use abbreviations

Do not abbreviate unless the abbreviation is more commonly used than the full word. The following abbreviations are explicitly allowed:

- `app` for application
- `args` for arguments
- `auto` for automatic
- `id` for identifier
- `info` for information
- `init` for initialize
- `min` for minimum
- `max` for maximum
- `param` / `params` for parameter(s)
- `prop` / `props` for property/properties
- `ref` for reference
- `ui` for user interface
- `util` / `utils` for utility/utilities
- Well-known acronyms: `url`, `http`, `api`, `html`, `css`, `sql`, `json`

Everything else must be spelled out in full. Do not use cryptic contractions like `cntUsr`, `mngr`, `svc`, `btn`, `msg`.

### 6. Use verbs in function names

Function and method names must start with a verb that describes the action performed: `do`, `render`, `get`, `format`, `calculate`, `send`, `validate`, `create`, `update`, `delete`, `find`, `check`, `parse`, `build`.

```text
// Bad: does not start with a verb
const valid(value: string): boolean => {}

// Good: starts with a verb
const checkValidity(value: string): boolean => {}
```

### 7. Use nouns for classes, variables, and properties

All non-function names (classes, variables, constants, properties) must be nouns or noun phrases. They represent a thing, not an action.

```text
// Bad: class name is a verb phrase
class CheckValidity {}

// Good: class name is a noun
class FormValidator {}
```

### 8. Use prefix terms for booleans

Boolean variables, properties, and parameters must start with `is`, `has`, `will`, `should`, `can`, or `was` to indicate their on/off state.

```text
// Bad: does not include correct prefix
const value = true;
const visible = true;

// Good: includes prefix
const hasValue = true;
const isVisible = true;
```

### 9. Casing conventions

Apply the correct casing style per context. When the project already uses a convention, follow it. Otherwise use these defaults:

| Context | Style | Example |
|---------|-------|---------|
| Local variables | camelCase | `userName`, `totalAmount` |
| Function / method names | camelCase | `calculateTotal()`, `getUserById()` |
| Class / interface / type names | PascalCase | `UserService`, `PaymentGateway` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS` |
| Enum members | UPPER_SNAKE_CASE or PascalCase (match project) | `ORDER_STATUS_PENDING` |
| Environment variables | UPPER_SNAKE_CASE | `DATABASE_URL`, `API_SECRET_KEY` |
| CSS classes | kebab-case (or BEM) | `nav-item`, `btn--primary` |
| Database tables | snake_case, plural | `order_items`, `user_accounts` |
| Database columns | snake_case | `created_at`, `first_name` |
| URL paths / API endpoints | kebab-case, plural nouns for resources | `/api/user-accounts` |

### 10. Files and folders

1. **Use kebab-case.** All file and folder names use lower-case, kebab-case. Because some systems are case-sensitive and some are not, never use capitals in file names.

2. **Use singular folder names** when a folder contains multiple files for one concept (e.g., a component with its helpers): `text-input/`.

3. **Use plural folder names** when a folder contains multiple files of the same type: `text-inputs/`, `validators/`.

4. **Include the file type in the name**, delimited with dots, when a file contains a single type of concept:

   ```text
   // Bad: uses camelCase, no type
   customInput.ts

   // Good: uses kebab-case and includes type
   custom-input.class.ts
   custom-input.component.ts
   custom-input.service.ts
   custom-input.spec.ts
   ```

### 11. Collections and counts

1. **Collections** use plural nouns: `users`, `orderItems`, `activeConnections`.
   - Do not encode the type: avoid `userList`, `orderItemArray`.

2. **Counts and measurements** include the unit or concept: `retryCount`, `timeoutMs`, `maxWidthPx`.
   - Avoid bare names like `count`, `timeout`, `max`.

### 12. Interfaces and implementations

1. **Do NOT prefix interfaces with `I`** unless the project already consistently does so. Name the interface after the capability: `Logger`, `PaymentGateway`, `UserRepository`.

2. **Implementations** may include the adapter or strategy name: `ConsoleLogger`, `StripePaymentGateway`, `PostgresUserRepository`.

### 13. API and database naming

1. **REST endpoints** use plural nouns for collections:
   - `GET /api/orders` — list
   - `GET /api/orders/{orderId}` — single
   - `POST /api/orders` — create
   - Never use verbs in URLs: avoid `/api/getOrders`, `/api/createOrder`

2. **Foreign keys** reference the related table in singular form with `_id` suffix: `user_id`, `order_id`.

3. **Timestamps** use past participle: `created_at`, `updated_at`, `deleted_at`.

4. **Boolean columns** use `is_`/`has_` prefix: `is_active`, `has_verified_email`.

### 14. Decision process for naming

When naming anything, follow this process:

1. **What is it?** Identify whether it is an entity, action, property, collection, or flag.
2. **What casing does this context require?** Apply from the table in section 9.
3. **Is it consistent with existing names for the same concept in this codebase?** If a pattern exists, follow it.
4. **Is it affirmative?** If it is a boolean, make sure it uses a positive prefix.
5. **Would a new team member understand this name without additional context?** If not, choose something clearer.
6. **Is it spelled out?** Check it does not use a non-allowed abbreviation.

## Anti-patterns to avoid

- **Single-letter variables** outside of trivial loops (`i`, `j` in array iteration are acceptable; `u` for user is not).
- **Hungarian notation** — encoding type in the name: `strName`, `arrItems`, `bIsActive`. Let the type system communicate types.
- **Meaningless prefixes** like `my`, `the`, `a`: `myService`, `theUser`, `aResult`.
- **Inconsistent pluralisation** — a variable called `user` holding an array of users, or `orders` holding a single order.
- **Copy-paste naming** — `handleClick1`, `handleClick2`. If names need numeric suffixes, the abstraction is wrong.
- **Capitals in file names** — always use lower-case kebab-case for files and folders.

## References

- [XIP Naming Conventions](https://dev.xip.nl/docs/common/standards/naming-conventions)
