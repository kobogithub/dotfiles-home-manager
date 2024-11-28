# home-manager/modules/zsh.nix

{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "npm"
        "node"
        "python"
        "sudo"
        "command-not-found"
        "history-substring-search"
      ];
    };

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
    };

    # Variables de entorno
    sessionVariables = {
      EDITOR = "vim";
      PATH = "$HOME/.local/bin:$PATH";
      LANG = "en_US.UTF-8";
    };

    # Configuración adicional
    initExtra = ''
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
    '';
  };

  # Instalar paquetes relacionados
  home.packages = with pkgs; [
    fzf              # Búsqueda difusa
    bat              # Mejor alternativa a cat
    eza              # Mejor alternativa a ls
    ripgrep          # Mejor alternativa a grep
    fd               # Mejor alternativa a find
    thefuck          # Corrector de comandos
  ];
}
