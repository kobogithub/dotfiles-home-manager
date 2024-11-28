{ config, pkgs, ... }:

{
  # Paquetes relacionados con git
  home.packages = with pkgs; [
    lazygit       # TUI para git
    git-lfs      # Para archivos grandes
  ];

  programs.git = {
    enable = true;
    userName = "Kevin Barroso";
    userEmail = "kobogithub@gmail.com";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      lg = "lazygit";
    };
   extraConfig = {
      core = {
        editor = "vim";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
      };
    };
  };
}
