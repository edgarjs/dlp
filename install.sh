#!/bin/bash

set -e

REPO="edgarjs/dlp"
INSTALL_DIR=".dlp"
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)

if [ -z "$LATEST_RELEASE" ]; then
  echo "Error: Could not fetch latest release. Check your internet connection."
  exit 1
fi

echo "Installing Development Standard Protocol (${LATEST_RELEASE})..."

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

DOWNLOAD_URL="https://github.com/${REPO}/archive/${LATEST_RELEASE}.tar.gz"
curl -sL "$DOWNLOAD_URL" | tar xz --strip-components=1

echo ""
echo "✓ Installation complete"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📖 CODING AGENT QUICK START"
echo ""
echo "Tell your agent to read .dlp/README.md and follow the instructions."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
