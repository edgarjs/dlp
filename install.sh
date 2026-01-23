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

if [ -f "AGENTS.md" ]; then
  if grep -q "$INSTALL_DIR" AGENTS.md 2>/dev/null; then
    echo "Note: AGENTS.md already references $INSTALL_DIR"
  else
    printf '\n---\n\n' >> AGENTS.md
    cat >> AGENTS.md << EOF
## Development Lifecycle Protocol (DLP)

This project uses DLP. Read the protocol from: \`$INSTALL_DIR\`

Start with \`README.md\`, then follow phase-specific guidance:
- \`requirements/\` - Requirements gathering and analysis
- \`design/\` - System design and architecture
- \`development/\` - Coding standards and patterns
- \`testing/\` - Testing strategy and practices
- \`concerns/\` - Security, performance, accessibility
EOF
    echo "✓ Updated AGENTS.md"
  fi
elif $LOCAL; then
  cat > AGENTS.md << EOF
## Development Lifecycle Protocol (DLP)

This project uses DLP. Read the protocol from: \`$INSTALL_DIR\`

Start with \`README.md\`, then follow phase-specific guidance:
- \`requirements/\` - Requirements gathering and analysis
- \`design/\` - System design and architecture
- \`development/\` - Coding standards and patterns
- \`testing/\` - Testing strategy and practices
- \`concerns/\` - Security, performance, accessibility
EOF
  echo "✓ Created AGENTS.md"
else
  echo ""
  echo "Add this to your project's AGENTS.md:"
  echo ""
  echo "  Read the Development Lifecycle Protocol from: ~/.dlp"
fi

echo "✓ Installed to $INSTALL_DIR"
