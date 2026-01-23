#!/bin/bash
#
# Development Lifecycle Protocol (DLP) Installer
# https://github.com/edgarjs/dlp
#
# Options:
#   -l, --local       Install to .dlp/ in current directory
#   -r, --ref <ref>   Install specific commit SHA, branch, or tag
#

set -e

REPO="edgarjs/dlp"
INSTALL_DIR="$HOME/.dlp"
LOCAL=false
REF=""

while [ $# -gt 0 ]; do
  case "$1" in
    -l|--local) LOCAL=true; INSTALL_DIR=".dlp" ;;
    -r|--ref)
      shift
      [ -z "$1" ] && { echo "Error: --ref requires a value"; exit 1; }
      REF="$1"
      ;;
    -h|--help)
      echo "Usage: install.sh [-l|--local] [-r|--ref <ref>]"
      echo "  -l, --local       Install to .dlp/ in current directory"
      echo "  -r, --ref <ref>   Install specific commit SHA, branch, or tag"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

command -v curl >/dev/null || { echo "Error: curl is required"; exit 1; }

# Use provided ref or fetch latest release
if [ -n "$REF" ]; then
  VERSION="$REF"
else
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
  [ -z "$VERSION" ] && { echo "Error: Could not fetch latest release"; exit 1; }
fi

echo "Installing DLP ${VERSION} to ${INSTALL_DIR}..."
mkdir -p "$INSTALL_DIR"
curl -fsSL "https://github.com/${REPO}/archive/${VERSION}.tar.gz" | tar xz --strip-components=1 -C "$INSTALL_DIR"
echo "$VERSION" > "$INSTALL_DIR/.dlp-version"

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
