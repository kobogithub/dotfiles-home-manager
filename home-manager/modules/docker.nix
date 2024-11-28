# home-manager/modules/docker.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-compose
    docker-credential-helpers
    lazydocker    # TUI para Docker
  ];

  # Aliases útiles para ocker
  programs.zsh.shellAliases = {
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";
    dpa = "docker ps -a";
    di = "docker images";
    dex = "docker exec -it";
    dl = "docker logs";
    dlf = "docker logs -f";
    dcp = "docker-compose";
    dcup = "docker-compose up -d";
    dcdown = "docker-compose down";
    dcl = "docker-compose logs -f";
  };

  # Script de activación para configurar Docker
  home.activation.dockerSetup = config.lib.dag.entryAfter ["writeBoundary"] ''
    if ! groups | grep -q docker; then
      echo "Recuerda agregar tu usuario al grupo docker:"
      echo "sudo usermod -aG docker $USER"
    fi
  '';
}
