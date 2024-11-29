{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix # Modulo de Git
    ./modules/zsh.nix # Modulo de Zsh Shell
    ./modules/docker.nix # Modulo de Docker
    ./modules/aws.nix # Modulo de AWS
    ./modules/tmux.nix # Modulo de Tmux
    ./modules/astro.nix # Modulo de AstroNvim
    # Añadir más módulos según necesites
  ];

  home = {
    username = "kobo";  # Cambiar a tu usuario
    homeDirectory = "/home/kobo";  # Cambiar a tu directorio
    stateVersion = "23.11";
    packages = with pkgs; [
      # Paquetes básicos
      curl      # Transferencia de datos con URLs (HTTP, FTP, etc.)
      wget      # Descarga de archivos desde la web, soporta recursión
      btop      # Monitor de sistema interactivo, versión mejorada de top/htop
      ripgrep   # Búsqueda recursiva de texto, alternativa rápida a grep
      neofetch  # Muestra información del sistema de forma visualmente atractiva
      fd        # Alternativa simple y rápida a 'find', con mejor sintaxis
      tree               # Visualización de directorios en árbol
      ncdu               # Análisis de uso de disco
      duf                # Mejor df
      tldr              # Ejemplos prácticos de comandos
      jq                # Procesamiento de JSON
      pyenv
      gcc
      gnumake
      libsecret
      cargo  # Gestor de Paquetes
      rustc  # Compilador de Rust
      rust-analyzer # LSP para Rust
    ];
  };
  programs.home-manager = {
    enable = true;
    path = "/home/kobo/.config/nixpkgs";
  };

  modules.astrovim = {
	enable = true;
 };
}
