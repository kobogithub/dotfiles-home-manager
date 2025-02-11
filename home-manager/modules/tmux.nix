{ config, pkgs, ... }: {
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
      {
        plugin = dracula;
        extraConfig = ''
          # Dracula Theme Configuration
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-show-left-icon session
          set -g @dracula-left-icon-padding 1
          set -g @dracula-border-contrast true
          set -g @dracula-show-timezone false
          set -g @dracula-military-time true
          set -g @dracula-show-flags true
          set -g @dracula-show-location false
          set -g @dracula-cpu-usage true
          set -g @dracula-ram-usage true
          set -g @dracula-day-month true
          set -g @dracula-show-fahrenheit false
        '';
      }
    ];
    extraConfig = ''
      # Basic Settings
      set -g mouse on
      set -g history-limit 50000
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      # Keybindings
      # Reload config
      bind r run-shell "tmux source-file ~/.config/tmux/tmux.conf" \; display "Config reloaded!"
      
      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Moving between panes with vim movement keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes with vim movement keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Copy mode settings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # Window navigation
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Enable vim mode keys
      setw -g mode-keys vi

      # Set title
      set -g set-titles on
      set -g set-titles-string "#T"

      # Pane border styling
      set -g pane-border-style fg=colour239
      set -g pane-active-border-style fg=colour39

      # Status bar position
      set -g status-position top

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on

      # Continuum settings
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'

      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"

      # Tmuxifier integration
      if-shell "test -f ~/.tmuxifier/init.sh" "run-shell ~/.tmuxifier/init.sh"
    '';
  };

  # Additional packages
  home.packages = with pkgs; [
    tmux
    xclip # For X11 clipboard support
    wl-clipboard # For Wayland clipboard support
    tmuxifier # Adding tmuxifier package
  ];

  # Environment variables for Tmuxifier
  home.sessionVariables = {
    TMUXIFIER = "${pkgs.tmuxifier}";
    TMUXIFIER_LAYOUT_PATH = "$HOME/.tmuxifier-layouts";
  };

  # Shell aliases for Tmuxifier
  programs.bash.shellAliases = {
    ts = "tmuxifier";
    tsl = "tmuxifier ls";
    tss = "tmuxifier s";
    tsw = "tmuxifier w";
    tse = "tmuxifier e";
    tsn = "tmuxifier n";
    tsd = "tmuxifier d";
  };

  # If you use zsh, add the same aliases
  programs.zsh.shellAliases = {
    ts = "tmuxifier";
    tsl = "tmuxifier ls";
    tss = "tmuxifier s";
    tsw = "tmuxifier w";
    tse = "tmuxifier e";
    tsn = "tmuxifier n";
    tsd = "tmuxifier d";
  };
}
