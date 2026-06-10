# Changelog

Why each revision of `CURRENT.md` (and the repo) happened. Newest first.

## 2026-06-09 - PLAYBOOK.md becomes a first-class agent file

Made `PLAYBOOK.md` a fourth first-class per-repo agent file in the ontology, the convention, and the architect machinery. A `PLAYBOOK.md` is the canonical, human-readable record of a repo's repeatable **plays**: a play is born as prose and graduates into a skill once it recurs and proves out, at which point the entry keeps the judgment and points at the skill for the mechanics. The prose plays are the backlog of what to systematize next. Unlike its siblings `LOG.md` / `INDEX.md` (git-ignored agent scratch), `PLAYBOOK.md` is deliberately **git-tracked**: its purpose is a durable, reviewable process narrative and build backlog that must survive a fresh clone. It loads on demand (CLAUDE.md carries a one-line pointer), not every session. Design vetted by a 4-model `/second-opinion` panel plus a run of the architect itself. Reference implementation: `~/dev/businesses/dxangels/PLAYBOOK.md`.

Architect changes (`skills/agent-files-architect/SKILL.md`): added the `<repo>/PLAYBOOK.md` ontology row and routing rule, extended the three-file gap to a four-file gap, added a cross-repo candidate-skills harvest (aggregates `prose`-status plays from every PLAYBOOK.md into a "plays to systematize" advisory list), added `PLAYBOOK.md` to the Step 1 up-walk and the close-out Trigger 4 presence loop, and noted the tracked-vs-local-only exception. Open question flagged for the human: where a single durable aggregated backlog should live (ephemeral report section vs a tracked top-level `~/dev/PLAYS-TO-SYSTEMATIZE.md`); until decided the list stays in the architect's run artifacts. The `~/dev/CLAUDE.md` four-file mandate and the `/close-out` per-session playbook-harvest step are companion changes handled in their own repos.

## 2026-06-07 - Architect fires on a required-file gap

Added Trigger 4 to `agent-files-architect`'s `/close-out` gate. The gate previously fired only on TTL/activity signals (7 days, 10 sessions, 3 files touched), so the architect stayed silent in the exact case it is most useful: a project folder missing its agent files entirely. Trigger 4 is a cheap structural scan (one `git rev-parse` plus three `test -e`) that runs on every close-out and fires when the current project folder is missing one of `CLAUDE.md` / `LOG.md` / `INDEX.md`. "Project folder" is any git repo, OR any folder under the `~/dev/` workspace (caught even before `git init`, so a freshly-created `~/dev/newproj` is detected; because `~/dev` is itself a git repo, the resolver prefers a nested repo toplevel and otherwise falls back to the immediate child of `~/dev`). Stays silent at `~`, in `Downloads`, `/tmp`, and other non-`~/dev` non-repo dirs; honors `.agent-doctor-ignore`; never bootstraps placeholder files.

## 2026-05-29 - Founded

Founded after an sms-hero session in which `/agent-files-architect --research` re-ran upstream research (Anthropic, agents.md, Cursor) and produced findings that had nowhere durable to live. Standing up this repo so the synthesis is consulted once, not re-derived per project.

- Wrote the founding `CURRENT.md` synthesizing five upstream sources (Anthropic, agents.md, Cursor, OpenAI Codex, GitHub Copilot) with a ranked "if you only read one page" section.
- Cached fresh `/browse` snapshots of all five sources in `sources/` (Codex AGENTS.md and GitHub Copilot custom instructions were fetched for the first time this session; the prior research run had only covered Anthropic, agents.md, Cursor).
- Top finding baked in: Anthropic's <200-line-per-CLAUDE.md target vs `~/.claude/CLAUDE.md` at ~400 lines / ~3,940 tokens, with the `.claude/rules/<topic>.md` escape hatch as the recommended fix. The slim refactor itself is deliberately left to the main session, not applied here.
- Relocated the `agent-files-architect` skill into this repo (`skills/agent-files-architect/`) from the public `mutwo-skills` repo, deliberately flipping it from public to private. agent-docs is now both the reference data and the skill's home.
