#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
MODE="install"

case "${1:-install}" in
  install|"") MODE="install" ;;
  --check) MODE="check" ;;
  --uninstall) MODE="uninstall" ;;
  -h|--help)
    echo "Usage: ./install.sh [install | --check | --uninstall]"
    exit 0
    ;;
  *)
    echo "Unknown argument: $1" >&2
    exit 1
    ;;
esac

TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
)

# Auto-detect T3 Code Antigravity skills directories if present
if [ -d "$HOME/.t3/userdata/providers/antigravity" ]; then
  for dir in "$HOME/.t3/userdata/providers/antigravity"/*; do
    if [ -d "$dir" ]; then
      TARGETS+=("$dir/config/skills")
    fi
  done
fi

for target_root in "${TARGETS[@]}"; do
  if [ "$MODE" = "install" ]; then
    mkdir -p "$target_root"
  fi
  for skill_path in "$SKILLS_DIR"/*; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    dest="$target_root/$skill_name"

    if [ "$MODE" = "install" ]; then
      if [ -L "$dest" ]; then
        rm "$dest"
      elif [ -e "$dest" ]; then
        echo "SKIP (non-symlink exists): $dest"
        continue
      fi
      ln -s "$skill_path" "$dest"
      echo "LINK $dest -> $skill_path"
    elif [ "$MODE" = "uninstall" ]; then
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$skill_path" ]; then
        rm "$dest"
        echo "UNLINK $dest"
      fi
    elif [ "$MODE" = "check" ]; then
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$skill_path" ]; then
        echo "OK   $dest"
      else
        echo "MISS $dest"
      fi
    fi
  done
done
