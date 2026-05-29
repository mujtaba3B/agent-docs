# AGENTS.md (the open cross-vendor format)

- Source: https://agents.md/
- Fetched: 2026-05-29 (via gstack `/browse`)
- Steward: Agentic AI Foundation under the Linux Foundation

> Snapshot of the agents.md homepage/spec as of the fetch date. Chrome stripped.

---

## What it is

"A simple, open format for guiding coding agents, used by over 60k open-source projects." Think of AGENTS.md as a README for agents: a dedicated, predictable place for the context and instructions that help AI coding agents work on your project.

README.md is for humans (quick starts, descriptions, contribution guidelines). AGENTS.md complements it with the extra, sometimes detailed context agents need (build steps, tests, conventions) that would clutter a README. Kept separate deliberately to give agents a predictable place and keep READMEs human-focused.

It is just standard Markdown. Rather than a proprietary file, they chose a name and format anyone can adopt.

## One file, many agents

Compatible with a growing ecosystem: OpenAI Codex, Google Jules, Google Gemini CLI, GitHub Copilot coding agent, Cursor, Windsurf (Cognition), Devin, VS Code, Zed, Warp, Aider, goose, RooCode, Phoenix, UiPath Autopilot, Amp, opencode, Semgrep, Junie (JetBrains), Kilo Code, Ona, Augment Code, Factory, and more.

(CLAUDE.md is Claude-specific; AGENTS.md is the universal alternative.)

## Recommended content

"Anything you'd tell a new teammate." Popular sections:

- Project overview
- Build and test commands
- Code style guidelines
- Testing instructions
- Security considerations
- Commit message / PR guidelines, deployment steps, large datasets, gotchas.

Sample:

```markdown
# AGENTS.md
## Setup commands
- Install deps: `pnpm install`
- Start dev server: `pnpm dev`
- Run tests: `pnpm test`

## Code style
- TypeScript strict mode
- Single quotes, no semicolons
- Use functional patterns where possible
```

## How to use it

1. Add `AGENTS.md` at the repo root (many agents can scaffold one if asked).
2. Cover what matters (sections above).
3. Add extra instructions (commit/PR guidelines, security gotchas, deployment steps).
4. **Large monorepo? Use nested AGENTS.md files for subprojects.** Agents read the nearest file in the directory tree; the closest one takes precedence and every subproject can ship tailored instructions. (The main OpenAI repo had 88 AGENTS.md files at time of writing.)

## FAQ highlights

- **Required fields?** No. Standard Markdown; use any headings.
- **Conflicts?** The closest AGENTS.md to the edited file wins; explicit user chat prompts override everything.
- **Will the agent run testing commands found in it?** Yes, if you list them; the agent attempts relevant programmatic checks and fixes failures before finishing.
- **Update later?** Yes, treat it as living documentation.
- **Migrate existing docs?** Rename to AGENTS.md, create symlinks for back-compat: `mv AGENT.md AGENTS.md && ln -s AGENTS.md AGENT.md`.
- **Aider**: `read: AGENTS.md` in `.aider.conf.yml`. **Gemini CLI**: `{ "context": { "fileName": "AGENTS.md" } }` in `.gemini/settings.json`.

## Governance

Emerged from collaboration across the ecosystem (OpenAI Codex, Amp, Jules, Cursor, Factory). Now stewarded by the **Agentic AI Foundation under the Linux Foundation** as an open format.
