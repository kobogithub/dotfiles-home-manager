{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.astrovim;
in
{
  options.modules.astrovim = {
    enable = mkEnableOption "astrovim configuration";
    withNodeJs = mkOption {
      type = types.bool;
      default = true;
      description = "Include NodeJS in dependencies";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    home.packages = with pkgs; [
      git
      ripgrep
      lazygit
      gcc
      unzip
      wget
      curl
    ] ++ lib.optional cfg.withNodeJs pkgs.nodejs;

    home.activation = {
      installAstroVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Clone AstroNvim
        if [ ! -d "$HOME/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/AstroNvim/template "$HOME/.config/nvim"
        fi
      '';
    };
  };
}
