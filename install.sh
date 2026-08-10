#!/usr/bin/env bash
#
# install.sh — Symlink dotfiles from this repo into $HOME.
#
# Every file under home/ is symlinked to the same relative path under $HOME,
# e.g. home/.zshrc -> ~/.zshrc, home/.ssh/config -> ~/.ssh/config.
#
# Any existing real file at the destination (i.e. not already a symlink into
# this repo) is backed up before being replaced.
#
# Usage: ./install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$DOTFILES_DIR/home"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: $SOURCE_DIR does not exist." >&2
  exit 1
fi

backed_up=0

link_file() {
  local src="$1"
  local rel="${src#"$SOURCE_DIR"/}"
  local dest="$HOME/$rel"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    local current_target
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      echo "OK      $rel (already linked)"
      return
    fi
    echo "RELINK  $rel"
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "BACKUP  $rel"
    mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
    mv "$dest" "$BACKUP_DIR/$rel"
    backed_up=1
  else
    echo "LINK    $rel"
  fi

  ln -s "$src" "$dest"
}

while IFS= read -r -d '' file; do
  link_file "$file"
done < <(find "$SOURCE_DIR" -type f -print0)

echo
if [ "$backed_up" -eq 1 ]; then
  echo "Existing files were backed up to: $BACKUP_DIR"
fi
echo "Done."
