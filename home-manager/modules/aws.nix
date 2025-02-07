# home-manager/modules/aws.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli2 # AWS CLI v2
    aws-vault # Manejo seguro de credenciales AWS
    ssm-session-manager-plugin # Para AWS Systems Manager
    aws-sam-cli # Para desarrollo serverless
  ];

  # Configuración de ambiente para AWS
  programs.zsh.initExtra = ''
    # AWS CLI completion
    complete -C aws_completer aws

    # AWS Profile en el prompt
    function aws_prompt_info() {
      if [[ -n "$AWS_PROFILE" ]]; then
        echo "[AWS: $AWS_PROFILE]"
      fi
    }
    PROMPT=''${PROMPT/'$(aws_prompt_info)'/}'$(aws_prompt_info)'$PROMPT
  '';

  # Aliases útiles para AWS
  programs.zsh.shellAliases = {
    # AWS CLI
    awsid = "aws sts get-caller-identity";
    awswho = "aws sts get-caller-identity";
    awsregions = "aws ec2 describe-regions --output table";

    # AWS Vault
    avadd = "aws-vault --backend=pass add";
    avlist = "aws-vault --backend=pass list";

    ## AWS Vault Profile Exec
    alarti = "aws-vault --backend=pass exec larti -- aws";
    ataba = "aws-vault --backend=pass exec taba -- aws";
  };
}
