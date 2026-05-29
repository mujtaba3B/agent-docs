# Changelog

Why each revision of `CURRENT.md` (and the repo) happened. Newest first.

## 2026-05-29 - Founded

Founded after an sms-hero session in which `/agent-files-architect --research` re-ran upstream research (Anthropic, agents.md, Cursor) and produced findings that had nowhere durable to live. Standing up this repo so the synthesis is consulted once, not re-derived per project.

- Wrote the founding `CURRENT.md` synthesizing five upstream sources (Anthropic, agents.md, Cursor, OpenAI Codex, GitHub Copilot) with a ranked "if you only read one page" section.
- Cached fresh `/browse` snapshots of all five sources in `sources/` (Codex AGENTS.md and GitHub Copilot custom instructions were fetched for the first time this session; the prior research run had only covered Anthropic, agents.md, Cursor).
- Top finding baked in: Anthropic's <200-line-per-CLAUDE.md target vs `~/.claude/CLAUDE.md` at ~400 lines / ~3,940 tokens, with the `.claude/rules/<topic>.md` escape hatch as the recommended fix. The slim refactor itself is deliberately left to the main session, not applied here.
- Relocated the `agent-files-architect` skill into this repo (`skills/agent-files-architect/`) from the public `mutwo-skills` repo, deliberately flipping it from public to private. agent-docs is now both the reference data and the skill's home.
