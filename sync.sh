#!/usr/bin/env bash
# B-PROMPT skill 同步：源 → 各 agent 的 skill 目录（只增改，不删除任何文件）
# 用法：bash sync.sh    （Windows 用 git-bash；路径按需修改）
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
echo "源: $SRC"

DESTS=(
  "$LOCALAPPDATA/hermes/skills/autonomous-ai-agents/b-prompt"
  "$HOME/.claude/skills/b-prompt"
  "$HOME/.pi/agent/skills/b-prompt"
  "$HOME/.cursor/skills/b-prompt"
)

for d in "${DESTS[@]}"; do
  mkdir -p "$d/references"
  cp "$SRC/SKILL.md" "$d/SKILL.md"
  cp "$SRC/references/"*.md "$d/references/"
  if diff -r -q "$SRC" "$d" >/dev/null 2>&1; then
    echo "OK   $d"
  else
    echo "SYNC $d  (源里有 INSTALL.md/sync.sh 等非 skill 文件，differ 属正常)"
  fi
done

echo
echo "校验：diff -r \"$SRC\" <副本目录>  逐个比对（INSTALL.md / sync.sh 不会同步，属预期）"
