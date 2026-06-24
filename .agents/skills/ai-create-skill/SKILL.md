---
name: ai-create-skill
description: Guides the agent through creating a new AI skill following the agentskills.io format and this repository's conventions.
---

# ai-create-skill

Create new AI agent skills that follow the [Agent Skills](https://agentskills.io/) format and fit into this repository's category structure.

## When to use

Use this skill when:

- Creating a new skill from scratch
- Helping a user define agent instructions for a practice, pattern, or tool
- Reviewing whether an existing skill follows the correct format

## Instructions

1. **Choose the correct category.** Place the skill under the most specific matching category:
   - `ai/` — Cross-cutting skills applicable to any project
   - `common/` — Cross-cutting skills applicable to any project
   - `operations/` — DevOps, CI/CD, deployment, and infrastructure skills
   - `frontend/` — General frontend skills
   - `frontend/*/` — Technology specific skills
   - `backend/` — General backend skills
   - `backend/*/` — Technology specific skills

2. **Create the skill directory.** Use a kebab-case name that clearly identifies the skill:

   ```text
   skills/<category>/<skill-name>/
   ```

3. **Create `SKILL.md` with frontmatter.** Every skill must have a `SKILL.md` file with YAML frontmatter containing `name` and `description`:

   ```markdown
   ---
   name: <category>-<skill-name>
   description: A single sentence describing what this skill does.
   ---
   ```

   - The `name` must be unique across the repository.

   - The `description` should be concise — it is used for skill discovery and matching.

4. **Write the skill body.** Structure the Markdown body with these sections:

   **Required sections:**
   - `# <name>` — Title matching the frontmatter name, followed by a one-line summary.
   - `## When to use` — Bullet list of situations where this skill should activate.
   - `## Instructions` — Numbered step-by-step instructions the agent must follow.

   **Optional sections:**
   - `## Prerequisites` — Other skills or tools required before this one applies.
   - `## Core concepts` — Background knowledge the agent needs to reason correctly.
   - `## Examples` — Concrete code or output examples demonstrating correct behavior.
   - `## References` — Links to external documentation or standards.

5. **Write instructions for an AI agent, not a human.**
   - Be explicit and unambiguous — the reader is a language model, not a developer skimming docs.
   - Use imperative language: "Do X", "Never Y", "Always Z".
   - Provide decision trees when multiple paths exist (if A then B, otherwise C).
   - Include validation checks the agent can self-evaluate ("Ask: can X hold without Y?").
   - Avoid vague guidance like "use best practices" — spell out exactly what to do.

6. **Keep skills focused.** One skill = one concern. If a skill grows beyond ~150 lines, consider splitting it into multiple skills and referencing prerequisites between them.

7. **Add optional supporting files if needed:**
   - `scripts/` — Executable helper scripts the agent can invoke (shell, Node.js, Python).
   - `references/` — Supporting documentation, checklists, or lookup tables.

8. **Update the category README.** Add the new skill to the bullet list in `skills/<category>/README.md`:

   ```markdown
   - <skill-name>/SKILL.md
   ```

9. **Validate the skill.**
   - Does the frontmatter parse as valid YAML?
   - Is the `name` unique in the repository?
   - Does the "When to use" section give enough signal for skill matching?
   - Are instructions actionable without external context?
   - Would an AI agent know exactly what to do after reading only this file?

## Template

Use this as a starting point for a new skill:

```markdown
---
name: <category>-<skill-name>
description: A brief description of what this skill does.
---

# <category>-<skill-name>

One-line summary of what this skill accomplishes.

## When to use

Use this skill when:

- Situation A
- Situation B
- Situation C

## Instructions

1. First actionable step.
2. Second actionable step.
3. Additional steps as needed.
```
