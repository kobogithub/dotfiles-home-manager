#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de utilidad
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

success() {
    echo -e "${GREEN}$1${NC}"
}

# Verificar si está corriendo como root
if [ "$EUID" -eq 0 ]; then
    error "No ejecutes este script como root"
fi

# Instalar Nix si no está instalado
if ! command -v nix &> /dev/null; then
    log "Instalando Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon || error "No se pudo instalar Nix"
    
    # Recargar el ambiente
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Instalar Home Manager si no está instalado
if ! command -v home-manager &> /dev/null; then
    log "Instalando Home Manager..."
    
    # Añadir canal de Home Manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager || error "No se pudo añadir el canal de Home Manager"
    nix-channel --update || error "No se pudo actualizar el canal"
    
    # Instalar Home Manager
    nix-shell '<home-manager>' -A install || error "No se pudo instalar Home Manager"
fi

# Directorio del repositorio
REPO_URL="https://github.com/TU_USUARIO/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Clonar o actualizar el repositorio
if [ ! -d "$DOTFILES_DIR" ]; then
    log "Clonando repositorio de dotfiles..."
    git clone $REPO_URL "$DOTFILES_DIR" || error "No se pudo clonar el repositorio"
else
    log "Actualizando repositorio existente..."
    cd "$DOTFILES_DIR" || error "No se pudo acceder al directorio de dotfiles"
    git pull || error "No se pudo actualizar el repositorio"
fi

# Configurar Home Manager
log "Configurando Home Manager..."

# Hacer backup de configuración existente si existe
if [ -d "$HOME/.config/home-manager" ]; then
    log "Haciendo backup de configuración existente..."
    mv "$HOME/.config/home-manager" "$HOME/.config/home-manager.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Crear enlace simbólico
log "Creando enlace simbólico..."
ln -sf "$DOTFILES_DIR/home-manager" "$HOME/.config/home-manager" || error "No se pudo crear el enlace simbólico"
ln -sf "$DOTFILES_DIR/home-manager" "$HOME/.config/nixpkgs" || error "No se pudo crear el enlace simbólico"

# Aplicar configuración
log "Aplicando configuración de Home Manager..."
home-manager switch || error "No se pudo aplicar la configuración"

success "¡Instalación completada!"
log "Tu ambiente está listo para usar. Reinicia tu terminal para aplicar todos los cambios."
