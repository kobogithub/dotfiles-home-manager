{ config, pkgs, ... }:
let
  # Tu definición actual de clipboard
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
      # Añadimos el plugin de Catppuccin
      {
        plugin = catppuccin;
        extraConfig = ''
          # Configure Catppuccin
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

      # Configure Online
      set -g @online_icon "ok"
      set -g @offline_icon "nok"

      # status left look and feel
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

      # status right look and feel
      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      # bootstrap tpm
      if "test ! -d ~/.tmux/plugins/tpm" \
        "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'

      # Configure Tmux
      set -g status-position top
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "absolute-centre"

      # pane border look and feel
      setw -g pane-border-status top
      setw -g pane-border-format ""
      setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
      setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"
      setw -g pane-border-lines single

      # window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "Window"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"
    
      # Tu configuración actual de yank
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'
      set -g @yank_with_mouse on
      set -g @yank_action 'copy-pipe-and-cancel "cb copy"'
      
      # Tu configuración básica
      set -g mouse on
      bind r source-file ~/.tmux.conf \; display "Configuración Recargada!"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Tu configuración de copiar/pegar
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "cb copy"
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi r send-keys -X rectangle-toggle
      
      # Configuración de continuum
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
    '';
  };

  # El resto de tu configuración permanece igual...
  home.packages = with pkgs; [
    tmuxifier
  ];

  programs.zsh.initExtra = ''
    # Tmuxifier
    export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
    eval "$(tmuxifier init -)"
    # Crear directorio de layouts si no existe
    if [ ! -d "$TMUXIFIER_LAYOUT_PATH" ]; then
      mkdir -p "$TMUXIFIER_LAYOUT_PATH"
    fi
  '';

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
