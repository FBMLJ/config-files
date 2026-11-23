#!/usr/bin/env bash
# Só cria os links simbólicos. Depois rode: sudo nixos-rebuild switch
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo ln -sfn "$REPO_DIR/nixos/configuration.nix" /etc/nixos/configuration.nix

mkdir -p "$HOME/.config"
for d in nvim niri noctalia kitty fish; do
  ln -sfn "$REPO_DIR/$d" "$HOME/.config/$d"
done

echo "Links criados. Rode: sudo nixos-rebuild switch"
