{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" ];
    };
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
    };
  };
}
