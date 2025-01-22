{ config, pkgs, ... }:
let
  # Definición de clipboard
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
      battery
      online-status
      prefix-highlight
      {
        plugin = catppuccin;
        extraConfig = ''
          # Configuración de Catppuccin
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_window_status_style "none"
          set -g @catppuccin_pane_status_enabled "off"
          set -g @catppuccin_pane_border_status "off"
        '';
      }
    ];
    extraConfig = ''
      ######### TMUX CONFIG ############
      
      # Definición de colores Catppuccin Macchiato
      set -g @thm_base "#24273a"
      set -g @thm_mantle "#1e2030"
      set -g @thm_surface_0 "#363a4f"
      set -g @thm_surface_1 "#494d64"
      set -g @thm_surface_2 "#5b6078"
      set -g @thm_overlay_0 "#6e738d"
      set -g @thm_overlay_1 "#8087a2"
      set -g @thm_overlay_2 "#939ab7"
      set -g @thm_text "#cad3f5"
      set -g @thm_subtext_0 "#b8c0e0"
      set -g @thm_subtext_1 "#a5adcb"
      set -g @thm_rosewater "#f4dbd6"
      set -g @thm_flamingo "#f0c6c6"
      set -g @thm_pink "#f5bde6"
      set -g @thm_mauve "#c6a0f6"
      set -g @thm_red "#ed8796"
      set -g @thm_maroon "#ee99a0"
      set -g @thm_peach "#f5a97f"
      set -g @thm_yellow "#eed49f"
      set -g @thm_green "#a6da95"
      set -g @thm_teal "#8bd5ca"
      set -g @thm_sky "#91d7e3"
      set -g @thm_sapphire "#7dc4e4"
      set -g @thm_blue "#8aadf4"
      set -g @thm_lavender "#b7bdf8"
      
      # Configuración general
      set -g mouse on
      
      # Configuración de logs
      set -g history-file ~/.tmux_history
      set -g history-limit 50000
      
      # Habilitar logging
      bind P pipe-pane -o "cat >>~/.tmux/#W.log" \; display "Logging to ~/.tmux/#W.log"
      bind p pipe-pane \; display "Logging ended"
      set -g status-position bottom
      set -g status-style "bg=#{@thm_base}"
      
      # Configuración del status-left
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_mantle},bold]  #S },#{#[bg=#{@thm_mantle},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_mantle},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_mantle},fg=#{@thm_maroon}]  #{pane_current_command} "
      set -ga status-left "#[bg=#{@thm_mantle},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_mantle},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "

      # Configuración del status-right
      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_mantle}]},#{#[bg=#{@thm_mantle},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
      set -ga status-right "#[bg=#{@thm_mantle},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_mantle}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
      set -ga status-right "#[bg=#{@thm_mantle},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_mantle},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      # Configuración de ventanas
      set -g window-status-separator "|"
      set -g status-justify "absolute-centre"
      set -g @catppuccin_window_status_style "custom"
      set -g @catppuccin_window_flags ""
      set -g @catppuccin_window_number ""
      set -g @catppuccin_window_text "#[fg=#{@thm_rosewater},bg=#{@thm_mantle}] #I#{?#{!=:#{window_name},},: #W ,}"
      set -g @catppuccin_window_current_number ""
      set -g @catppuccin_window_current_text "#[fg=#{@thm_mantle},bg=#{@thm_peach}] #I#{?#{!=:#{window_name},},: #W ,}"
      set -wg automatic-rename on
      set -g automatic-rename-format ""

      # Configuración de Online Status
      set -g @online_icon "ok"
      set -g @offline_icon "nok"

      # Configuración de copiar/pegar
      set -g @yank_selection "clipboard"
      set -g @yank_selection_mouse "clipboard"
      set -g @yank_with_mouse on
      set -g @yank_action "copy-pipe-and-cancel 'cb copy'"
      
      # Keybindings
      bind r source-file ~/.tmux.conf \; display "¡Configuración Recargada!"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "cb copy"
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi r send-keys -X rectangle-toggle

      # Configuración de Continuum
      set -g @continuum-restore "on"
      set -g @continuum-save-interval "10"
    '';
  };

  # Paquetes adicionales
  home.packages = with pkgs; [
    tmuxifier
  ];

  # Configuración de ZSH para tmuxifier
  programs.zsh.initExtra = ''
    # Tmuxifier
    export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
    eval "$(tmuxifier init -)"
    # Crear directorio de layouts si no existe
    if [ ! -d "$TMUXIFIER_LAYOUT_PATH" ]; then
      mkdir -p "$TMUXIFIER_LAYOUT_PATH"
    fi
  '';

  # Alias de ZSH para tmux
  programs.zsh.shellAliases = {
    tx = "tmuxifier";
    tl = "tmuxifier load-window";
    tle = "tmuxifier edit-window";
    tln = "tmuxifier new-window";
    tls = "tmuxifier list-windows";
    tns = "tmuxifier ns";
    ts = "tmuxifier s";
    tes = "tmuxifier es";
  };

  # Layout de desarrollo
  home.file.".tmux-layouts/dev.window.sh".text = ''
    # Layout de desarrollo
    window_root "~/proyectos"
    split_v 30
    select_pane 0
    split_h 50
    run_cmd "neofetch" 0
    run_cmd "htop" 1
    run_cmd "ls -la" 2
    select_pane 2
  '';
}
