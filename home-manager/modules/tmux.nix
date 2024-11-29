# home-manager/modules/tmux.nix
{ config, pkgs, ... }:

let
  # Definir Clipboard como un paquete personalizado
  clipboard = pkgs.stdenv.mkDerivation {
    name = "clipboard";
    version = "0.8.1";

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      wayland
      wayland-protocols
      libxkbcommon
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp cb $out/bin/
    '';
  };
in
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
      # Configuración para usar cb con tmux-yank
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'
      set -g @yank_with_mouse on
      set -g @yank_action 'copy-pipe-and-cancel "cb copy"'
      
      # Configuración básica
      set -g mouse on
      
      bind r source-file ~/.tmux.conf \; display "Configuración Recargada!"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Configuración de copiar/pegar con cb
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "cb copy"
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi r send-keys -X rectangle-toggle

      # Estilo de la barra de estado
      set -g status-style bg=black,fg=white
      set -g status-left-length 32
      set -g status-right-length 150

      # Formato de la barra de estado
      set -g status-left "#[fg=green](#S) "
      set -g status-right "#{prefix_highlight} #[fg=yellow]#(cut -d ' ' -f 1-3 /proc/loadavg) #[fg=white]%H:%M #[fg=green]%d-%b-%y"

      # Ventana activa
      set-window-option -g window-status-current-style fg=white,bg=blue,bright

      # Auto restaurar sesiones
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
    '';
  };

  # Paquetes necesarios
  home.packages = with pkgs; [
    tmuxifier
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
    tx = "tmuxifier"; # Tmuxifier
    tl = "tmuxifier load-window";    # Cargar layout
    tle = "tmuxifier edit-window";   # Editar layout
    tln = "tmuxifier new-window";    # Nuevo layout
    tls = "tmuxifier list-windows";  # Listar layouts
  };

  # Layout de ejemplo
  home.file.".tmux-layouts/dev.window.sh".text = ''
    # Layout de desarrollo
    window_root "~/proyectos"

    # Split vertical principal
    split_v 30

    # Split horizontal en panel superior
    select_pane 0
    split_h 50

    # Configurar comandos para cada panel
    run_cmd "neofetch" 0    # Panel superior izquierdo
    run_cmd "htop" 1        # Panel superior derecho
    run_cmd "ls -la" 2      # Panel inferior

    # Seleccionar panel principal
    select_pane 2
  '';
}
