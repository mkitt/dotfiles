#!/bin/bash

file_path=$(jq -r '.tool_input.file_path' 2>/dev/null)

if [ -z "$file_path" ] || [ "$file_path" = "null" ]; then
  exit 0
fi

case "$file_path" in
  *.json|*.md|*.yaml|*.yml)
    npx --yes oxfmt -c .claude/hooks/oxfmtrc.json "$file_path" 2>/dev/null || true
    ;;
esac

exit 0
