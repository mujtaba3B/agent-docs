# GitHub Copilot: Repository custom instructions

- Source: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
- Fetched: 2026-05-29 (via gstack `/browse`)
- Vendor: GitHub (Copilot)

> Snapshot of the GitHub Copilot repository custom-instructions docs as of the fetch
> date. Chrome stripped. The onboarding prompt is reproduced because it is a strong
> reusable template for generating an instructions file.

---

## Three types of repository custom instructions

1. **Repository-wide custom instructions** apply to all requests in the repo context. Specified in `.github/copilot-instructions.md`.
2. **Path-specific custom instructions** apply to requests in the context of files matching a path. Specified in one or more `NAME.instructions.md` files within or below `.github/instructions/`. If a path matches a file Copilot is working on and a repo-wide file also exists, both are used.
3. **Agent instructions** used by AI agents: one or more `AGENTS.md` files stored anywhere in the repo; the nearest one in the directory tree takes precedence. Alternatively a single `CLAUDE.md` or `GEMINI.md` at the repo root.

For Copilot code review, the user's personal "use custom instructions" choice must be enabled (default on).

## Path-specific instructions file shape

`.github/instructions/<name>.instructions.md`. These are the Copilot analogue of Anthropic's path-scoped `.claude/rules/` and Cursor's globbed `.cursor/rules/`. (Frontmatter `applyTo` globs scope them to matching files; repo-wide `copilot-instructions.md` always applies.)

## Generating a `copilot-instructions.md` (Copilot cloud agent)

You can ask Copilot cloud agent (github.com/copilot/agents) to generate one. GitHub publishes this reusable onboarding prompt:

```text
Your task is to "onboard" this repository to Copilot cloud agent by adding a
.github/copilot-instructions.md file describing how a cloud agent seeing it for
the first time can work most efficiently. Do this once per repository.

Goals:
- Reduce the likelihood of a cloud-agent PR getting rejected (CI/validation failures, misbehavior).
- Minimize bash command and build failures.
- Let the agent complete tasks faster by minimizing exploration (grep/find/code search).

Limitations:
- No longer than 2 pages. Not task specific.

What to add:
- High-level details: what the repo does; size, type, languages, frameworks, runtimes.
- Build/validate instructions: for bootstrap, build, test, run, lint and each scripted
  step, document the exact sequence and tool versions. Validate each command by running it.
  Note preconditions/postconditions, ordering, errors observed and workarounds, timings,
  and "always do X" steps (e.g. "always run npm install before building").
- Project layout/architecture: major architectural elements with relative paths, config
  file locations (lint/compile/test), the checks run before check-in (GitHub workflows, CI),
  non-obvious dependencies, root file listing, README contents, key source files.

Steps to follow:
- Inventory the codebase (README, CONTRIBUTING, all docs; scan for HACK/TODO; all scripts,
  pipelines, project files, config/lint files). For each file decide whether its existence
  or contents matter to implement/build/test/validate/demo a change; if yes, document in detail.
- Finally, instruct the agent to TRUST these instructions and only search when the
  information is incomplete or in error.
```

## Notes for a Claude-first user

- GitHub Copilot natively reads `.github/copilot-instructions.md` and `.github/instructions/*.instructions.md`, but also honors a root `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` for agent work. So a single root `CLAUDE.md` (or `AGENTS.md`) covers both Claude Code and Copilot's coding agent.
- The 2-page / "not task specific" / "trust the instructions" framing matches Anthropic's <200-line, concise, verifiable guidance.
