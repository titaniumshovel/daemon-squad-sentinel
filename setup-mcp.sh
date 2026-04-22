#!/usr/bin/env bash
# Merge daemon-squad MCP config into ~/.claude/mcp.json
set -euo pipefail

SRC="$(dirname "$0")/mcp-config.json"
DEST="$HOME/.claude/mcp.json"

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq required. Install with: brew install jq (Mac) or apt install jq (Linux)"
  exit 1
fi

if [ -f "$DEST" ]; then
  merged=$(jq -s '.[0].mcpServers * .[1].mcpServers | {mcpServers: .}' "$DEST" "$SRC")
  echo "$merged" > "$DEST"
  echo "✅ Merged into existing $DEST"
else
  mkdir -p "$(dirname "$DEST")"
  cp "$SRC" "$DEST"
  echo "✅ Created $DEST"
fi

echo "Active MCP servers:"
jq -r '.mcpServers | keys[]' "$DEST"
