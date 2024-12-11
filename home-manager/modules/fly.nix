{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.fly;
in
{
  options.programs.fly = {
    enable = mkEnableOption "Concourse fly CLI";
    package = mkOption {
      type = types.package;
      default = pkgs.fly;
      description = "The fly package to use.";
    };
    settings = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          api = mkOption {
            type = types.str;
            description = "The API endpoint URL for the Concourse instance.";
            example = "http://172.19.1.35:10000";
          };
          team = mkOption {
            type = types.str;
            default = "main";
            description = "The team name to use.";
          };
        };
      });
      default = { };
      description = "Concourse target configurations.";
    };
    enableZshIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Zsh integration (aliases and completions).";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.zsh = mkIf cfg.enableZshIntegration {
      shellAliases = mapAttrs'
        (name: target: {
          name = "fly-login-${name}";
          value = "fly -t ${name} login -c ${target.api}";
        })
        cfg.settings // {
        "fly-pipelines" = "fly -t main pipelines";
        "fly-builds" = "fly -t main builds";
        "fly-workers" = "fly -t main workers";
        "fly-abort-build" = "fly -t main abort-build -b";
        "fly-hijack" = "fly -t main hijack";
        "fly-watch" = "fly -t main watch";
        "fly-execute" = "fly -t main execute";
        "fly-targets" = "fly targets";
      };

      initExtra = ''
        if [ $commands[fly] ]; then
          source <(fly completion --shell zsh)
        fi
      '';
    };
  };
}
