# agent-docs - project schema (Claude instructions)

Schema for the `agent-docs` repo. Applies to every Claude Code session under `/Users/mujtaba/dev/agent-docs/`. Follows the cross-project schema at `/Users/mujtaba/dev/CLAUDE.md`.

<!-- This file eats its own dog food: it follows the <200-line target it documents. Keep it that way. -->

## What this repo is

Mujtaba's personal best-practices reference for agent instruction files (CLAUDE.md, AGENTS.md, `.claude/rules/`, `.cursor/rules/`, Copilot custom instructions). `CURRENT.md` is the synthesis a session reads before any nontrivial agent-files change; `sources/` holds cached upstream snapshots; `skills/agent-files-architect/` is the audit skill, symlinked into `~/.claude/skills/`.

Public repo. Local folder `~/dev/agent-docs/`; GitHub `mujtaba3B/agent-docs`.

## Repo layout

```text
~/dev/agent-docs/
  CURRENT.md     the synthesis (read this first)
  sources/       date-stamped upstream snapshots + refresh note
  skills/agent-files-architect/SKILL.md   the audit skill
  CHANGELOG.md   why each CURRENT.md revision happened
  README.md      public-facing intro
  install.sh     symlinks skills/* into ~/.claude/skills/
  CLAUDE.md LOG.md INDEX.md   the ~/dev/ three-file schema
```

## Conventions

- **`CURRENT.md` is the product.** When upstream guidance shifts, re-fetch via `/browse`, add a date-stamped `sources/<vendor>-<topic>-YYYY-MM-DD.md`, revise `CURRENT.md`, and record why in `CHANGELOG.md` + `LOG.md`. Bump the "Last synthesized" date in `CURRENT.md`.
- **`sources/` are point-in-time captures, not mirrors.** Trust the linked URL as source of truth. Strip page chrome; keep substantive content.
- **Practice what this repo preaches.** Every CLAUDE.md here (this one, and any the skill recommends) stays under ~200 lines; use `<!-- -->` for human-only notes (stripped before context injection); reference, do not copy.
- **The skill lives here now.** `skills/agent-files-architect/SKILL.md` is symlinked from `~/.claude/skills/agent-files-architect`. Its `description` frontmatter is load-bearing (the only text Claude sees to decide triggering); do not degrade it. This skill was moved out of `mutwo-skills` so the skill and the reference data it consults live together (co-location, not privacy: the repo is public).

## When to update LOG.md / INDEX.md

Per `~/dev/CLAUDE.md`. LOG = why a decision was made (new source added, `CURRENT.md` revised, skill changed, convention established). INDEX = where artifacts live (new `sources/` file, new section, the skill). Skip every-commit noise; `git log` covers that.

## Conventions inherited from `~/dev/CLAUDE.md`

- No em-dash characters anywhere (see `~/.claude/CLAUDE.md`).
- All work through PRs; never commit to `main`. PRs assigned to `mujtaba3B` with a type label.
- Local Codex review on every PR before merge (`codex review --base main`).
- New repos private by default; CodeRabbit installed after first push.
