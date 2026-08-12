#!/bin/sh

set -e

PLUGIN_DIR="$HOME/.zsh/plugin"

mkdir -p "$PLUGIN_DIR"

if [ ! -d "$PLUGIN_DIR/powerlevel10k" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$PLUGIN_DIR/powerlevel10k"
fi

if [ ! -d "$PLUGIN_DIR/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git "$PLUGIN_DIR/fzf-tab"
fi

if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
fi

if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
fi

echo "Zsh plugins installed successfully."