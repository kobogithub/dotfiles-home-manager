# home-manager/modules/tmux.nix
{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;    # Empezar a numerar ventanas desde 1
    escapeTime = 0;   # Elimina el delay al presionar escape
    terminal = "screen-256color";

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible       # Configuraciones sensibles por defecto
      yank          # Copiar al portapapeles
      resurrect     # Guardar/restaurar sesiones
      continuum     # Auto-guardar sesiones
      vim-tmux-navigator  # Navegación entre vim y tmux
      cpu           # Mostrar uso de CPU
      prefix-highlight   # Resaltar cuando se presiona el prefix
    ];

    extraConfig = ''
      # Habilitar el mouse
      set -g mouse on

      # Recargar configuración
      bind r source-file ~/.tmux.conf \; display "Configuración Recargada!"

      # Split panes usando | y -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Movimiento entre panes con Alt+arrow
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Estilo de la barra de estado
      set -g status-style bg=black,fg=white
      set -g status-left-length 32
      set -g status-right-length 150

      # Formato de la barra de estado
      set -g status-left "#[fg=green](#S) "
      set -g status-right "#{prefix_highlight} #[fg=yellow]#(cut -d ' ' -f 1-3 /proc/loadavg) #[fg=white]%H:%M #[fg=green]%d-%b-%y"

      # Ventana activa
      set-window-option -g window-status-current-style fg=white,bg=blue,bright

      # Notificaciones
      set -g visual-activity on
      set -g visual-bell off
      set -g visual-silence off
      set-window-option -g monitor-activity on
      set -g bell-action none

      # Auto restaurar sesiones
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'

      # Configuración de navegación vim-tmux
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
    '';
  };

  # Asegurarse de que xclip esté disponible para el plugin yank
  home.packages = with pkgs; [
    xclip    # Para copiar al portapapeles
  ];
}
