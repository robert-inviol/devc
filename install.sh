#!/usr/bin/env bash
# Installs the devc script + shell completions.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/robert-inviol/devc/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- /custom/install/dir
#
# Env vars:
#   DEVC_BASE_URL          override the source repo (default: GitHub main branch)
#   DEVC_NO_COMPLETIONS=1  skip installing shell completions
set -euo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"
BASE_URL="${DEVC_BASE_URL:-https://raw.githubusercontent.com/robert-inviol/devc/main}"

# --- main script ---------------------------------------------------------
mkdir -p "$INSTALL_DIR"
curl -fsSL "$BASE_URL/devc" -o "$INSTALL_DIR/devc"
chmod +x "$INSTALL_DIR/devc"
echo "✓ devc installed → $INSTALL_DIR/devc"

# --- completions ---------------------------------------------------------
if [ "${DEVC_NO_COMPLETIONS:-0}" != "1" ]; then
  bash_dir="$HOME/.local/share/bash-completion/completions"
  fish_dir="$HOME/.config/fish/completions"

  mkdir -p "$bash_dir"
  curl -fsSL "$BASE_URL/completions/devc.bash" -o "$bash_dir/devc"
  echo "✓ bash completion → $bash_dir/devc"

  if [ -d "$HOME/.config/fish" ] || command -v fish >/dev/null 2>&1; then
    mkdir -p "$fish_dir"
    curl -fsSL "$BASE_URL/completions/devc.fish" -o "$fish_dir/devc.fish"
    echo "✓ fish completion → $fish_dir/devc.fish"
  fi

  if command -v zsh >/dev/null 2>&1; then
    echo
    echo "ℹ  zsh detected. To enable zsh completion, add a directory to your fpath"
    echo "   and drop the completion file there. For example:"
    echo "     mkdir -p ~/.zsh/completions"
    echo "     curl -fsSL $BASE_URL/completions/devc.zsh -o ~/.zsh/completions/_devc"
    echo "   then in ~/.zshrc:"
    echo "     fpath=(~/.zsh/completions \$fpath)"
    echo "     autoload -U compinit && compinit"
  fi
fi

# --- PATH check ----------------------------------------------------------
if ! printf '%s' ":$PATH:" | grep -q ":$INSTALL_DIR:"; then
  echo
  echo "⚠  $INSTALL_DIR is not on your PATH."
  echo "   Add this to your shell rc:"
  echo "     export PATH=\"$INSTALL_DIR:\$PATH\""
fi

# --- fzf hint ------------------------------------------------------------
if ! command -v fzf >/dev/null 2>&1; then
  echo
  echo "ℹ  Tip: install fzf for the arrow-key fuzzy picker."
  echo "   https://github.com/junegunn/fzf"
fi

echo
echo "Open a new shell, then run 'devc --help' to get started."
