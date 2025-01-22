# modules/packages/fabric.nix
{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "fabric";
  version = "1.4.130";

  src = fetchurl {
    url = "https://github.com/danielmiessler/fabric/releases/download/v${version}/fabric-linux-amd64";
    hash = "sha256-hB/DDP+oOwyO1rse4pc/CFLK2fptAwM67pL3T6kprIQ=";
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/bin/fabric
    chmod +x $out/bin/fabric
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fabric - Security Content and Workflow Management";
    homepage = "https://github.com/danielmiessler/fabric";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "fabric";
  };
}
