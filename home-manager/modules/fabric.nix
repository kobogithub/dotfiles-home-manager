# ~/.config/nixpkgs/modules/fabric.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.fabric;
in
{
  options.programs.fabric = {
    enable = mkEnableOption "fabric procesador de videos";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./packages/fabric.nix { };
      description = "The fabric package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
