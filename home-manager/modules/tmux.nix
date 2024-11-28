# home-manager/modules/tmux.nix
{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      vim-tmux-navigator
      cpu
      prefix-highlight
    ];

    extraConfig = ''
      # Configuración existente de tmux...
      set -g mouse on
      
      bind r source-file ~/.tmux.conf \; display "Configuración Recargada!"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
    '';
  };

  # Instalar y configurar tmuxifier
  home.packages = with pkgs; [
    tmuxifier    # Gestor de layouts para tmux
    xclip        # Para el portapapeles
  ];

  # Configuración de tmuxifier
  programs.zsh.initExtra = ''
    # Tmuxifier
    export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
    eval "$(tmuxifier init -)"

    # Crear directorio de layouts si no existe
    if [ ! -d "$TMUXIFIER_LAYOUT_PATH" ]; then
      mkdir -p "$TMUXIFIER_LAYOUT_PATH"
    fi
  '';

  # Aliases para tmuxifier
  programs.zsh.shellAliases = {
    # Aliases existentes...
    tl = "tmuxifier load-window";    # Cargar layout
    tle = "tmuxifier edit-window";   # Editar layout
    tln = "tmuxifier new-window";    # Nuevo layout
    tls = "tmuxifier list-windows";  # Listar layouts
  };

  # Crear un layout de ejemplo
  home.file.".tmux-layouts/dev.window.sh".text = ''
    # Crear un layout de desarrollo
    window_root "~/proyectos"

    # Split vertical principal
    split_v 30

    # En el panel superior, split horizontal
    select_pane 0
    split_h 50

    # Configurar los comandos para cada panel
    run_cmd "neofetch" 0    # Panel superior izquierdo
    run_cmd "htop" 1        # Panel superior derecho
    run_cmd "ls -la" 2      # Panel inferior

    # Seleccionar el panel principal
    select_pane 2
  '';
}
