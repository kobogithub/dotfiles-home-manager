{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    # Añadir más módulos según necesites
  ];

  home = {
    username = "tuusuario";  # Cambiar a tu usuario
    homeDirectory = "/home/tuusuario";  # Cambiar a tu directorio
    stateVersion = "23.11";
    
    packages = with pkgs; [
      # Paquetes básicos
      curl
      wget
      htop
      ripgrep
      fd
    ];
  };

  programs.home-manager.enable = true;
}
