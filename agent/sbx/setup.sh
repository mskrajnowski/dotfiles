#!/usr/bin/env bash
set -euo pipefail

echo "installing system packages"
sudo apt-get update && sudo apt-get install -y \
  libatomic1 \
  ca-certificates \
  curl \
  wget \
  tree \
  htop \
  git \
  tig \
  fish \
  vim \
  stow

echo "installing dotfiles"
mkdir -p \
  ~/.config \
  ~/.local/bin \
  ~/.local/share

stow --dir "$PWD/dotfiles" --target ~ --adopt \
  agent-home \
  codestyle \
  fish \
  starship

echo "installing mise"
curl https://mise.run | sh

echo "installing mise completions"
mkdir -p ~/.config/fish/completions/
mise completion fish >~/.config/fish/completions/mise.fish

echo "installing mise tools"
mise install
