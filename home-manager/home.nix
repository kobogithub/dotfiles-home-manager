{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/docker.nix
    # Añadir más módulos según necesites
  ];

  home = {
    username = "kobo";  # Cambiar a tu usuario
    homeDirectory = "/home/kobo";  # Cambiar a tu directorio
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
  programs.home-manager = {
    enable = true;
    path = "/home/kobo/.config/nixpkgs";
  };
}
