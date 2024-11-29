# home-manager/modules/zsh.nix
{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    
    # Powerlevel10k
    initExtra = ''
      # Cargar configuración de p10k si existe
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Historial
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history
      
      # Opciones de ZSH
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_VERIFY
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY
      setopt AUTO_CD
      setopt EXTENDED_GLOB
      setopt NOTIFY
      setopt PROMPT_SUBST
      
      # Bindkeys
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      
      # Completado
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

     # Configuración para Powerlevel10k
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
	
     # Función p10k
  function p10k() {
    if [[ $# -gt 0 && $1 == configure ]]; then
      p10k_configure
    else
      echo "Uso: p10k configure"
    fi
  }

  function p10k_configure() {
    if [ -f ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/p10k-instant-prompt.zsh ]; then
      ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme configure
    else
      echo "Powerlevel10k no está instalado correctamente"
    fi
  }

  # Cargar Powerlevel10k
  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';

    # Plugins adicionales
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
    ];

    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "npm"
        "node"
        "python"
        "sudo"
        "command-not-found"
        "history-substring-search"
        "aliases"
      ];
    };

    # Aliases útiles
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      k = "kubectl";
      g = "git";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gst = "git status";
      d = "docker";
      dc = "docker compose";
      hms = "home-manager switch";
    };

    # Variables de entorno
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PATH = "$HOME/.local/bin:$PATH";
      LANG = "en_US.UTF-8";
    };
  };

  # Instalar paquetes relacionados
  home.packages = with pkgs; [
    fzf              # Búsqueda difusa
    bat              # Mejor alternativa a cat
    eza              # Mejor alternativa a ls
    ripgrep          # Mejor alternativa a grep
    fd               # Mejor alternativa a find
    thefuck          # Corrector de comandos
    zsh-powerlevel10k # Tema Powerlevel10k
    meslo-lgs-nf     # Fuente recomendada para p10k
  ];

  # Configuración base de Powerlevel10k
  home.file.".p10k.zsh".text = ''
    # Generated by Powerlevel10k configuration wizard
    typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$ "

    # Elementos del prompt izquierdo
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      dir                     # Directorio actual
      vcs                     # Estado de git
      aws                     # Perfil de AWS
      docker                  # Estado de Docker
      kubecontext            # Contexto de Kubernetes
    )

    # Elementos del prompt derecho
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # Estado del último comando
      command_execution_time  # Duración del comando
      background_jobs        # Trabajos en segundo plano
      time                   # Hora actual
    )

    # Configuración del directorio
    typeset -g POWERLEVEL9K_DIR_BACKGROUND='blue'
    typeset -g POWERLEVEL9K_DIR_FOREGROUND='black'
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

    # Configuración de Git
    typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
    typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='red'
  '';
}
