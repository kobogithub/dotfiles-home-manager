{ config, pkgs, ... }:
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };

  # Configuración de GPG
  programs.gpg = {
    enable = true;
  };

  # Configuración del agente GPG
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800; # 30 minutos
    maxCacheTtl = 7200; # 2 horas
  };

  # Paquetes relacionados
  home.packages = with pkgs; [
    gnupg
  ];
}
