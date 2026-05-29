#!/usr/bin/env bash
# Install the skills shipped by this repo as symlinks into ~/.claude/skills/.
#
# agent-docs is primarily a reference repo (CURRENT.md + sources/), but it also
# hosts the agent-files-architect skill, which audits agent files against the
# guidance in CURRENT.md. This installer wires that skill into Claude Code.
#
# Usage: ./install.sh
# Idempotent: re-running refreshes the symlinks and prunes any that point into
# this repo but no longer resolve.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.claude/skills"

mkdir -p "$TARGET"
echo "Installing skills from $REPO/skills into $TARGET ..."

shopt -s nullglob
for skill in "$REPO"/skills/*/; do
  skill="${skill%/}"
  [[ -f "$skill/SKILL.md" ]] || continue
  name="$(basename "$skill")"
  link="$TARGET/$name"
  ln -sfn "$skill" "$link"
  echo "  linked: $name -> $skill"
done

# Prune stale symlinks that point into this repo but no longer resolve.
for link in "$TARGET"/*; do
  [[ -L "$link" ]] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$REPO"/*)
      if [[ ! -e "$target" ]]; then
        rm "$link"
        echo "  removed stale: $(basename "$link")"
      fi
      ;;
  esac
done

echo "Done. Restart your Claude Code session to pick up the skill."
