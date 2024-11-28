{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Tu Nombre";
    userEmail = "tu@email.com";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
    };
  };
}
