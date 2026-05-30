# LOG - agent-docs

Chronological decision log. Why things were decided, not every commit. Date-headed sections; entries tagged `[topic][subtopic]`. Companion to `INDEX.md` (where things live) and `CHANGELOG.md` (why each `CURRENT.md` revision happened).

## 2026-05-29

### `[meta][founding]` Repo founded after sms-hero session

Stood up `~/dev/agent-docs/` as a personal reference for agent instruction files. Trigger: a `/agent-files-architect --research` run during an sms-hero session re-derived upstream guidance (Anthropic, agents.md, Cursor) with no durable home for the findings. This repo is that home: `CURRENT.md` is the synthesis a future session reads instead of re-researching per project.

### `[sources][fetch]` Cached five upstream sources via /browse

Fetched fresh snapshots of Anthropic Claude Code memory docs, agents.md, Cursor rules, OpenAI Codex AGENTS.md, and GitHub Copilot custom instructions. The prior research run had covered only the first three; Codex and Copilot were fetched for the first time. Notable freshness vs the prior run: Anthropic's page now documents auto memory, `claudeMdExcludes`, and the `InstructionsLoaded` hook; agents.md is now under the Linux Foundation; Cursor added Team Rules. All in `sources/`.

### `[current][synthesis]` Founding CURRENT.md

Wrote `CURRENT.md` with a ranked "if you only read one page" section, per-vendor reference, and a cross-vendor reconciliation with opinions. Top recommendation baked in: Anthropic's <200-line CLAUDE.md target vs `~/.claude/CLAUDE.md` at ~400 lines / ~3,940 tokens; documented fix is `~/.claude/rules/<topic>.md` (none exist yet). The slim refactor itself is deliberately deferred to the main session, not applied from this sidequest.

### `[skill][install]` Added install.sh + wired --research to the local cache

Gave the repo an `install.sh` (symlinks `skills/*` into `~/.claude/skills/`, replaces a pre-existing real dir before linking, prunes stale links). Wired the skill's `--research` Step 7 to read `CURRENT.md` + `sources/` first (resolved relative to its own symlink, so it works wherever agent-docs is cloned) and only re-fetch upstream via `/browse` when a snapshot is stale (>~90d) or missing. Refreshed the source-of-record URLs to the current canonical pages. Co-location is now functional, not just physical.

### `[ops][mini]` Migrated the nanoclaw (Mac mini) install

The mini ran nanoclaw with `~/.claude/skills/agent-files-architect` symlinked from its mutwo-skills clone (`~/dev/mutwo/skills/`). Cloned the private `agent-docs` on the mini and ran its `install.sh`, re-pointing the symlink to `~/dev/agent-docs/skills/agent-files-architect`. The mini's gh is authed as `mujtaba3B` (repo scope), so the private clone worked. The symlink now points outside the mutwo-skills repo, so when the mini later pulls mutwo-skills PR #31 the prune loop leaves it alone. The mini's agent-docs clone is temporarily on `feat/founding-scaffold`; finalize with `git checkout main && git pull` once PR #1 merges.

### `[skill][relocate]` Moved agent-files-architect into this repo

`git mv` of `skills/agent-files-architect/` out of the public `mutwo-skills` repo into `agent-docs/skills/`. Re-pointed `~/.claude/skills/agent-files-architect` to the new location. Removal from `mutwo-skills` goes via a separate PR (its `main` is branch-protected). This deliberately flips the skill from public to private; agent-docs is now both the reference data and the skill's home.

### `[meta][visibility]` Flipped repo back to public to unblock the nanoclaw container clone

Made `mujtaba3B/agent-docs` public (was private). Driver: mutwo PR #75 adds a `container/entrypoint.sh` block that clones agent-docs into every nanoclaw agent container at startup and runs `install.sh` to install the skill. The clone is an unauthenticated `git clone https://github.com/...`, identical to the existing gstack-extensions block. A private repo would have failed there silently: the nanoclaw OneCLI gateway only injects GitHub auth for the `api.github.com` host pattern, but `git clone` hits `github.com`, and `git` ignores the placeholder `GH_TOKEN` (it uses a credential helper, which nothing in the container configures). The failure is swallowed by `2>/dev/null || true`, so the skill would just never appear with zero signal. Options were: make public, or add a `github.com` gateway rule plus `gh auth setup-git`. Content scanned clean (no secrets, keys, or personal data: the repo is best-practices reference + public-doc snapshots), and the founder confirmed he is fine sharing it, so public was the simple unblock. This reverses the earlier deliberate private decision in the `[skill][relocate]` entry above.
