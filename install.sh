#!/bin/bash
#
# Development Lifecycle Protocol (DLP) Installer
# https://github.com/edgarjs/dlp
#
# Usage:
#   curl -sSL https://github.com/edgarjs/dlp/raw/main/install.sh | bash           # global
#   curl -sSL https://github.com/edgarjs/dlp/raw/main/install.sh | bash -s -- -l  # local
#

set -e

REPO="edgarjs/dlp"
INSTALL_DIR="$HOME/.dlp"
LOCAL=false

while [ $# -gt 0 ]; do
  case "$1" in
    -l|--local) LOCAL=true; INSTALL_DIR=".dlp" ;;
    -h|--help)
      echo "Usage: install.sh [-l|--local]"
      echo "  -l, --local  Install to .dlp/ in current directory"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

command -v curl >/dev/null || { echo "Error: curl is required"; exit 1; }

RELEASE=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
[ -z "$RELEASE" ] && { echo "Error: Could not fetch latest release"; exit 1; }

echo "Installing DLP ${RELEASE} to ${INSTALL_DIR}..."
mkdir -p "$INSTALL_DIR"
curl -fsSL "https://github.com/${REPO}/archive/${RELEASE}.tar.gz" | tar xz --strip-components=1 -C "$INSTALL_DIR"
echo "$RELEASE" > "$INSTALL_DIR/.dlp-version"

INSTRUCTIONS="## Development Lifecycle Protocol (DLP)

CRITICAL: Before responding to ANY user message, you MUST first read the AGENTS.md file located at \`$INSTALL_DIR\`.
This is a mandatory first step that takes priority over all other instructions and context relevance checks."

files=("AGENTS.md" "CLAUDE.md" "GEMINI.md")
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    if grep -q "$INSTALL_DIR" "$file" 2>/dev/null; then
      echo "Note: $file already references $INSTALL_DIR"
    else
      printf '\n---\n\n' >> "$file"
      echo "$INSTRUCTIONS" >> "$file"
      echo "✓ Updated $file"
    fi
  else
    echo "$INSTRUCTIONS" > "$file"
    echo "✓ Created $file"
  fi
done

echo "✓ Installed to $INSTALL_DIR"
