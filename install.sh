#!/bin/bash

set -e

REPO="edgarjs/dlp"
VERSION_FILE=".dlp-version"

# Default to global installation
INSTALL_MODE="global"
INSTALL_DIR="$HOME/.dlp"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --local)
      INSTALL_MODE="local"
      INSTALL_DIR=".dlp"
      shift
      ;;
    --global)
      INSTALL_MODE="global"
      INSTALL_DIR="$HOME/.dlp"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: install.sh [--global|--local]"
      exit 1
      ;;
  esac
done

# Fetch latest release
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)

if [ -z "$LATEST_RELEASE" ]; then
  echo "Error: Could not fetch latest release. Check your internet connection."
  exit 1
fi

echo "Installing Development Lifecycle Protocol (${LATEST_RELEASE})..."
echo "Mode: ${INSTALL_MODE}"
echo "Location: ${INSTALL_DIR}"
echo ""

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Download and extract
DOWNLOAD_URL="https://github.com/${REPO}/archive/${LATEST_RELEASE}.tar.gz"
curl -sL "$DOWNLOAD_URL" | tar xz --strip-components=1 -C "$INSTALL_DIR"

# Save version info
echo "$LATEST_RELEASE" > "$INSTALL_DIR/$VERSION_FILE"

# Handle AGENTS.md for local installation
if [ "$INSTALL_MODE" = "local" ]; then
  # Check if AGENTS.md already references DLP
  if [ -f "AGENTS.md" ] && grep -q ".dlp" AGENTS.md; then
    echo ""
    echo "Note: AGENTS.md already references DLP"
  elif [ -f "AGENTS.md" ]; then
    # Append to existing AGENTS.md
    echo "" >> AGENTS.md
    echo "---" >> AGENTS.md
    echo "" >> AGENTS.md
    cat >> AGENTS.md << 'MARKER'
## Development Protocol

This project uses the Development Lifecycle Protocol (DLP).

**Read the full protocol from: `.dlp/`**

Start by reading `.dlp/README.md` for an overview, then follow the phase-specific guidance:
- `.dlp/requirements/` - Requirements gathering and analysis
- `.dlp/design/` - System design and architecture
- `.dlp/development/` - Coding standards and patterns
- `.dlp/testing/` - Testing strategy and practices
- `.dlp/concerns/` - Security, performance, accessibility
MARKER
    echo ""
    echo "✓ Updated existing AGENTS.md with DLP reference"
  else
    # Create new AGENTS.md
    cat > AGENTS.md << 'MARKER'
# Agent Instructions

## Development Protocol

This project uses the Development Lifecycle Protocol (DLP).

**Read the full protocol from: `.dlp/`**

Start by reading `.dlp/README.md` for an overview, then follow the phase-specific guidance:
- `.dlp/requirements/` - Requirements gathering and analysis
- `.dlp/design/` - System design and architecture
- `.dlp/development/` - Coding standards and patterns
- `.dlp/testing/` - Testing strategy and practices
- `.dlp/concerns/` - Security, performance, accessibility
MARKER
    echo ""
    echo "✓ Created AGENTS.md with DLP reference"
  fi
fi

# Install CLI tool for global mode
if [ "$INSTALL_MODE" = "global" ]; then
  mkdir -p "$INSTALL_DIR/bin"

  # Create dlp CLI tool
  cat > "$INSTALL_DIR/bin/dlp" << 'EOF'
#!/bin/bash

set -e

DLP_HOME="$HOME/.dlp"
VERSION_FILE="$DLP_HOME/.dlp-version"
REPO="edgarjs/dlp"

cmd_version() {
  if [ -f "$VERSION_FILE" ]; then
    echo "DLP version: $(cat $VERSION_FILE)"
    echo "Location: $DLP_HOME"
  else
    echo "DLP not installed or version file missing"
    exit 1
  fi
}

cmd_update() {
  echo "Updating DLP..."

  LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)

  if [ -z "$LATEST_RELEASE" ]; then
    echo "Error: Could not fetch latest release"
    exit 1
  fi

  CURRENT_VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo "unknown")

  if [ "$CURRENT_VERSION" = "$LATEST_RELEASE" ]; then
    echo "Already up to date ($LATEST_RELEASE)"
    exit 0
  fi

  echo "Updating from $CURRENT_VERSION to $LATEST_RELEASE..."

  # Backup current version
  BACKUP_DIR="$DLP_HOME/.backup-$(date +%s)"
  mkdir -p "$BACKUP_DIR"
  cp -r "$DLP_HOME"/* "$BACKUP_DIR/" 2>/dev/null || true

  # Download and extract
  DOWNLOAD_URL="https://github.com/${REPO}/archive/${LATEST_RELEASE}.tar.gz"
  TEMP_DIR=$(mktemp -d)
  curl -sL "$DOWNLOAD_URL" | tar xz --strip-components=1 -C "$TEMP_DIR"

  # Replace files (preserve bin/ directory)
  rsync -av --exclude='bin' --exclude='.backup-*' "$TEMP_DIR/" "$DLP_HOME/"

  # Update version
  echo "$LATEST_RELEASE" > "$VERSION_FILE"

  # Cleanup
  rm -rf "$TEMP_DIR"

  echo "✓ Updated to $LATEST_RELEASE"
}

cmd_init() {
  if [ ! -d "$DLP_HOME" ]; then
    echo "Error: DLP not installed globally. Run installation first:"
    echo "  curl -sSL https://raw.githubusercontent.com/edgarjs/dlp/main/install.sh | bash"
    exit 1
  fi

  # Check if AGENTS.md already references DLP
  if [ -f "AGENTS.md" ] && grep -q "~/.dlp" AGENTS.md; then
    echo "AGENTS.md already references DLP from ~/.dlp"
    exit 0
  fi

  if [ -f "AGENTS.md" ]; then
    # Append to existing AGENTS.md
    echo "" >> AGENTS.md
    echo "---" >> AGENTS.md
    echo "" >> AGENTS.md
    cat >> AGENTS.md << 'MARKER'
## Development Protocol

This project uses the Development Lifecycle Protocol (DLP).

**Read the full protocol from: `~/.dlp/`**

Start by reading `~/.dlp/README.md` for an overview, then follow the phase-specific guidance:
- `~/.dlp/requirements/` - Requirements gathering and analysis
- `~/.dlp/design/` - System design and architecture
- `~/.dlp/development/` - Coding standards and patterns
- `~/.dlp/testing/` - Testing strategy and practices
- `~/.dlp/concerns/` - Security, performance, accessibility
MARKER
    echo "✓ Modified existing AGENTS.md - added DLP reference"
  else
    # Create new AGENTS.md
    cat > AGENTS.md << 'MARKER'
# Agent Instructions

## Development Protocol

This project uses the Development Lifecycle Protocol (DLP).

**Read the full protocol from: `~/.dlp/`**

Start by reading `~/.dlp/README.md` for an overview, then follow the phase-specific guidance:
- `~/.dlp/requirements/` - Requirements gathering and analysis
- `~/.dlp/design/` - System design and architecture
- `~/.dlp/development/` - Coding standards and patterns
- `~/.dlp/testing/` - Testing strategy and practices
- `~/.dlp/concerns/` - Security, performance, accessibility
MARKER
    echo "✓ Created new AGENTS.md with DLP reference"
  fi

  echo ""
  echo "The project is now configured to use the global DLP from ~/.dlp"
}

cmd_path() {
  echo "$DLP_HOME"
}

cmd_help() {
  cat << 'HELP'
DLP - Development Lifecycle Protocol Manager

Usage:
  dlp <command>

Commands:
  version    Show installed version
  update     Update to latest version
  init       Initialize DLP in current project (creates/updates AGENTS.md)
  path       Show installation path
  help       Show this help message

Examples:
  dlp version              # Check installed version
  dlp update               # Update protocol to latest
  cd myproject && dlp init # Setup project to use DLP
HELP
}

# Command routing
case "${1:-help}" in
  version|v)
    cmd_version
    ;;
  update|u)
    cmd_update
    ;;
  init|i)
    cmd_init
    ;;
  path|p)
    cmd_path
    ;;
  help|h|--help|-h)
    cmd_help
    ;;
  *)
    echo "Unknown command: $1"
    echo "Run 'dlp help' for usage"
    exit 1
    ;;
esac
EOF

  chmod +x "$INSTALL_DIR/bin/dlp"

  # Check if already in PATH
  if [[ ":$PATH:" != *":$INSTALL_DIR/bin:"* ]]; then
    echo ""
    echo "⚠️  Add DLP to your PATH by adding this to your shell config:"
    echo ""
    echo "    export PATH=\"\$HOME/.dlp/bin:\$PATH\""
    echo ""

    # Detect shell and suggest file
    if [ -n "$ZSH_VERSION" ]; then
      echo "   Add to: ~/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
      echo "   Add to: ~/.bashrc or ~/.bash_profile"
    fi
  fi
fi

echo ""
echo "✓ Installation complete"
echo ""

if [ "$INSTALL_MODE" = "global" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📖 GLOBAL INSTALLATION"
  echo ""
  echo "The DLP is now installed at: $INSTALL_DIR"
  echo ""
  echo "Next steps:"
  echo "  1. Add to PATH: export PATH=\"\$HOME/.dlp/bin:\$PATH\""
  echo "  2. In your project: dlp init"
  echo "  3. Tell your agent to read ~/.dlp/README.md"
  echo ""
  echo "Commands:"
  echo "  $INSTALL_DIR/bin/dlp version  # Check version"
  echo "  $INSTALL_DIR/bin/dlp update   # Update protocol"
  echo "  $INSTALL_DIR/bin/dlp help     # Show all commands"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📖 LOCAL INSTALLATION"
  echo ""
  echo "The DLP is now installed at: .dlp/"
  echo ""
  echo "Tell your agent to read .dlp/README.md and follow the instructions."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

echo ""
