# Modulo de ntfy
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gotify-cli
  ];

  # Crear el directorio y archivo de configuración
  xdg.configFile."gotify/client.yml" = {
    text = ''
      server: "http://192.168.0.13:8087"  # URL de tu servidor Gotify
      token: "AjLKSy.Ueede55G"     # Token obtenido de la interfaz web
      timeout: 30                         # Timeout en segundos
      format:
        template: "{{.title}} - {{.message}}"  # Formato de los mensajes
    '';
  };
}
