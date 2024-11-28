#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/nixpkgs"

# Crear backup si existe configuración previa
if [ -d "$CONFIG_DIR" ]; then
    echo "Backing up existing configuration..."
    mv "$CONFIG_DIR" "$CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Crear enlace simbólico
echo "Creating symlink to configuration..."
ln -sf "$DOTFILES_DIR/home-manager" "$CONFIG_DIR"

# Aplicar configuración
echo "Applying Home Manager configuration..."
home-manager switch

echo "Installation complete!"
