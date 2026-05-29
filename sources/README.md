# sources/

Cached snapshots of upstream guidance on agent instruction files (CLAUDE.md, AGENTS.md, rules, custom instructions). Each file records the canonical URL, the fetch date, and a chrome-stripped capture of the substantive content as of that date.

These exist so a future agent session can read the synthesis in `../CURRENT.md` and, when it needs the primary text, open the relevant snapshot here instead of re-fetching. They are point-in-time captures, not living mirrors: trust the linked URL as source of truth.

## Inventory

| File | Vendor | URL |
|---|---|---|
| `anthropic-claude-code-memory-2026-05-29.md` | Anthropic (Claude Code) | https://code.claude.com/docs/en/memory |
| `agents-md-spec-2026-05-29.md` | Agentic AI Foundation (Linux Foundation) | https://agents.md/ |
| `cursor-rules-2026-05-29.md` | Cursor (Anysphere) | https://cursor.com/docs/context/rules |
| `openai-codex-agents-md-2026-05-29.md` | OpenAI (Codex) | https://developers.openai.com/codex/guides/agents-md |
| `github-copilot-custom-instructions-2026-05-29.md` | GitHub (Copilot) | https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions |

## Refresh cadence

No fixed schedule. Re-fetch when:

- A vendor ships a notable change to its instruction-file mechanism (new file type, new scoping syntax, changed size targets).
- `CURRENT.md` is about to drive a significant change (a CLAUDE.md slim refactor, a new `.claude/rules/` adoption, a first AGENTS.md) and you want to confirm the guidance is still current.
- More than a quarter has passed and you are touching this repo anyway.

Fetch via gstack `/browse` (the global rule), date-stamp the new file (`<vendor>-<topic>-YYYY-MM-DD.md`), update this inventory and the date in `../CURRENT.md`, and log the refresh in `../LOG.md` and `../CHANGELOG.md`. Keep the prior snapshot if you want a diff trail, or overwrite if you do not.
