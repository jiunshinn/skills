#!/usr/bin/env bash
# install.sh — install these skills for every agent that supports Agent Skills.
#
#   ./install.sh <project dir>     project install: <dir>/.agents/skills/ + <dir>/.claude/skills/ links
#   ./install.sh --global          user install:    ~/.agents/skills/     + ~/.claude/skills/ links
#   ./install.sh ... --skill open-pr   install one skill only (repeatable)
#
# .agents/skills/ is read by Codex, Antigravity, Devin and OpenCode.
# Claude Code reads only .claude/skills/, so it gets a symlink to the same folder.
# Existing folders that are not links made by this script are never overwritten.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
all_skills=(open-pr open-pr-setup)
skills=()
root=""

while (($#)); do
  case "$1" in
    --global) root="$HOME" ;;
    --skill) shift; skills+=("$1") ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) root="$(cd "$1" && pwd)" ;;
  esac
  shift
done
[[ -n "$root" ]] || { echo "usage: ./install.sh <project dir> | --global [--skill <name>]" >&2; exit 2; }
((${#skills[@]})) || skills=("${all_skills[@]}")

main_dir="$root/.agents/skills"
link_dir="$root/.claude/skills"
mkdir -p "$main_dir" "$link_dir"

for s in "${skills[@]}"; do
  [[ -f "$here/$s/SKILL.md" ]] || { echo "✗ unknown skill: $s" >&2; exit 1; }
  dest="$main_dir/$s"
  if [[ -e "$dest" && ! -f "$dest/.installed-from-skills-repo" ]]; then
    echo "⚠ skip $dest — it exists and was not installed by this script"
  else
    rm -rf "$dest"
    cp -R "$here/$s" "$dest"
    touch "$dest/.installed-from-skills-repo"
    echo "✓ $dest"
  fi
  link="$link_dir/$s"
  if [[ -L "$link" || ! -e "$link" ]]; then
    # Relative, so the link still works after the project is committed and cloned elsewhere.
    ln -sfn "../../.agents/skills/$s" "$link"
    echo "✓ $link → ../../.agents/skills/$s"
  else
    echo "⚠ skip $link — a real folder exists; Claude Code keeps using it"
  fi
done

echo
echo "Next: in the target repository, ask your agent to \"set up open-pr for this repo\"."
