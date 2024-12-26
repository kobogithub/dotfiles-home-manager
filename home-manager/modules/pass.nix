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

  programs.gpg = {
    enable = true;
    settings = {
      # Configuración de algoritmos y preferencias
      "cert-digest-algo" = "SHA512";
      "charset" = "utf-8";
      "default-preference-list" = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      "fixed-list-mode" = true;
      "keyid-format" = "0xlong";
      "list-options" = "show-uid-validity";
      "no-comments" = true;
      "no-emit-version" = true;
      "no-symkey-cache" = true;
      "personal-cipher-preferences" = "AES256 AES192 AES";
      "personal-compress-preferences" = "ZLIB BZIP2 ZIP Uncompressed";
      "personal-digest-preferences" = "SHA512 SHA384 SHA256";
      "require-cross-certification" = true;
      "s2k-cipher-algo" = "AES256";
      "s2k-digest-algo" = "SHA512";
      "use-agent" = true;
      "verify-options" = "show-uid-validity";
      "with-fingerprint" = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
    pinentryPackage = pkgs.pinentry-curses;
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-curses
  ];
}
