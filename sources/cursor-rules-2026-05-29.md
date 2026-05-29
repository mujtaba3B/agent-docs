# Cursor: Rules

- Source: https://cursor.com/docs/context/rules
- Fetched: 2026-05-29 (via gstack `/browse`)
- Vendor: Cursor (Anysphere)

> Snapshot of the Cursor rules docs as of the fetch date. Chrome stripped.

---

## Four kinds of rules

- **Project Rules**: stored in `.cursor/rules`, version-controlled, scoped to the codebase.
- **User Rules**: global to your Cursor environment, used by Agent (Chat).
- **Team Rules**: team-wide, managed from the dashboard (Team and Enterprise plans).
- **AGENTS.md**: agent instructions in markdown, a simple alternative to `.cursor/rules`.

LLMs don't retain memory between completions; rules provide persistent, reusable context at the prompt level. When applied, rule contents are included at the start of the model context.

## Project rules (`.cursor/rules/*.mdc`)

Project rules live in `.cursor/rules` as `.mdc` files, version-controlled. They are scoped by path patterns, invoked manually, or included by relevance. A plain `.md` file in `.cursor/rules` is **ignored** (no frontmatter for `description`/`globs`/`alwaysApply`); use AGENTS.md if you want plain markdown. Rules can be organized in folders.

### Rule anatomy (frontmatter controls application)

| Rule Type | Behavior |
|---|---|
| Always Apply | Apply to every chat session |
| Apply Intelligently | When Agent decides it's relevant based on `description` |
| Apply to Specific Files | When a file matches a `globs` pattern |
| Apply Manually | When `@`-mentioned in chat (e.g. `@my-rule`) |

Frontmatter field interaction:

| `alwaysApply` | `description` | `globs` | Behavior |
|---|---|---|---|
| true | - | - | Always included; globs and description ignored |
| false | - | provided | Auto-attached when a matching file is in context |
| false | provided | omitted | Agent reads description, pulls rule in when relevant |
| false | omitted | omitted | Included only when `@`-mentioned in chat |

Example (always applied):

```text
---
alwaysApply: true
---
- All source files must include the company copyright header
- Never modify generated files in the `dist/` or `build/` directories
```

Example (auto-attached by file pattern):

```text
---
globs: src/components/**/*.tsx
alwaysApply: false
---
- Use named exports, not default exports
- Keep components under 200 lines
```

Glob patterns: `*` (one segment), `**` (recursive), `*.ts`, `**/*.ts`, `src/**`, `src/**/*.tsx`, comma-separated `docs/**/*.md, docs/**/*.mdx`, `tailwind.config.*`. You can reference files with `@file` instead of copying their contents.

### Creating rules

`/create-rule` in chat, or Cursor Settings > Rules, Commands > + Add Rule.

## Best practices

- Keep rules under **500 lines**.
- Split large rules into multiple composable rules.
- Provide concrete examples or referenced files.
- Avoid vague guidance; write rules like clear internal docs.
- **Reference files instead of copying their contents** to keep rules short and prevent staleness.

What to avoid: copying entire style guides (use a linter); documenting every command (Agent knows npm/git/pytest); rare edge-case instructions; duplicating what is already in your codebase (point to canonical examples).

"Start simple. Add rules only when you notice Agent making the same mistake repeatedly. Don't over-optimize before you understand your patterns." Check rules into git; update a rule when Agent makes a mistake.

## Team Rules (Team / Enterprise)

Created and enforced org-wide from the Cursor dashboard. Admins set whether each rule is required. Free-form text (no folder structure). Support glob patterns for file-scoped application; rules without a glob apply to every conversation.

- **Enable immediately** vs save as draft.
- **Enforce**: when on, required for all members, cannot be disabled in their settings.
- **Precedence**: Team Rules > Project Rules > User Rules. All applicable rules merge; earlier sources win on conflict.
- Note: "AI guidance should not be your only security control."

## Importing rules

Import from external sources to reuse configs. **Remote rules (via GitHub)**: Cursor Settings > Rules, Commands > + Add Rule > Remote Rule (GitHub), paste a repo URL; Cursor scans for `.mdc` files and syncs them into your project (public or private repos you have access to).
