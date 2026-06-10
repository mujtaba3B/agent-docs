# PLAYBOOK.md - how agent-docs runs its plays

The canonical, human-readable record of the repeatable things we do in this repo. Tracked in git on purpose: this is a durable process narrative and a build backlog, not agent scratch.

## What this is

- A **play** is a discrete repeatable thing we do (refresh the synthesis, audit a tree, propagate the skill).
- A play is **born as prose**: a written description of how we currently do it, often still by hand.
- A play **graduates into a skill** once it recurs and proves out. When it does, its entry keeps the *judgment* (why we do it this way) and points at the skill for the *mechanics*.
- So this file is a skill book where some plays are formed skills (linked) and some are still prose. **The prose plays are the backlog of what to systematize next.**

`/close-out` runs a harvest at the end of a session: it spots repeatable flows, searches for an existing skill or tool that already covers them, and proposes either "reuse X" or "build a skill for this," appending confirmed plays here.

## Play format

```
### Play: <name>
- **What / when:** one line
- **Status:** `skill: <name>`  |  `prose (candidate skill)`  |  `external: <tool>`
- **Notes:** the non-obvious judgment + gotchas worth not re-deriving
```

---

## Synthesis maintenance

### Play: Refresh CURRENT.md from upstream guidance
- **What / when:** upstream agent-files guidance shifts (Anthropic, Cursor, OpenAI Codex, GitHub Copilot, agents.md); re-synthesize the working page.
- **Status:** `prose (candidate skill)` (drift *detection* is `agent-files-architect --research`; the re-fetch + re-synthesis is still manual)
- **Notes:** re-fetch via `/browse` (global rule, not WebFetch), add a date-stamped `sources/<vendor>-<topic>-YYYY-MM-DD.md`, revise `CURRENT.md`, bump its "Last synthesized" date, and record why in `CHANGELOG.md` + `LOG.md`. `--research` reads the cached `sources/` first and only re-pulls upstream when a snapshot is stale (>~90d) or missing, so the common case costs zero web fetches.

---

## Auditing

### Play: Audit a tree against the agent-files standard
- **What / when:** check one repo, or the whole `~/dev` workspace, against the four-file + tracking-posture + deploy ontology.
- **Status:** `skill: agent-files-architect` (`--deep` for the workspace-wide sweep)
- **Notes:** advisory only; never bootstraps placeholder files (anti-pattern 7). The workspace-wide alignment sweep (classify active vs vendored/legacy, score four-file presence, check git-tracked-vs-ignored posture, flag deploy-convention gaps) is this play at `~/dev` scope. A tracking-posture check (are the local-only files actually git-ignored, is PLAYBOOK tracked) is a candidate extension the skill does not yet do.

---

## Propagation

### Play: Propagate the skill to MuTwo
- **What / when:** after any merge that changes `skills/agent-files-architect/SKILL.md` (or `CURRENT.md` / `sources/`).
- **Status:** `external: mutwo/scripts/sync-agent-docs-skills.sh`
- **Notes:** the `~/.claude/skills/agent-files-architect` copy is a **symlink** to canonical, so it reflects edits instantly. The two MuTwo copies (`container/skills/...`, `vendor/agent-docs/...`) are **git-ignored, generated** artifacts: the script clones `origin/main` (`git reset --hard`) and projects via `sed 's#<agent-docs>/##g'`. Run it **post-merge**; never hand-edit the copies (not committable, blown away on next sync). `install.sh` only manages the symlink, not the MuTwo copies.

---

## Shipping

### Play: Ship an agent-docs change through the gate stack
- **What / when:** any tracked change to this repo (`main` is branch-protected: merge-clearance + enforce_admins).
- **Status:** `skill chain: qa:qa-plan -> ship -> eng:cr -> land-and-deploy`
- **Notes:** the repo is opted into the QA-plan, ship-PR, and merge-clearance gates. No `VERSION` file and no test suite, so `/ship`'s version-bump and test steps are no-ops; docs/skill-only changes get `dev_verified` from grep/diff checks. `/eng:cr` mints the merge-clearance stamp; `/land-and-deploy` runs `merge-clearance clear` (posts the `local-review/merge-clearance` status) then squash-merges. PRs assigned to `mujtaba3B`.
