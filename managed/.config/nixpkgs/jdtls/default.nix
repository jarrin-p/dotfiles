let
  pkgs = import <nixpkgs> {};
in
with pkgs; stdenv.mkDerivation {
  name = "jdtls";
  system = builtins.currentSystem;

  src = fetchzip {
    url = "https://download.eclipse.org/jdtls/milestones/1.19.0/jdt-language-server-1.19.0-202301171536.tar.gz";
    sha256 = "sha256-PmS7DpjTf5YUT5EYiIUME1k/prN/2lXnTjpCxQUmoeI=";
    stripRoot = false;
  };

  buildInputs = [
    jdk17
    makeWrapper
    python39
  ];

  installPhase = ''
    mkdir $out
    cp -r * $out
    makeWrapper $out/bin/jdtls $out/bin/jdtlsw \
    --add-flags "--jvm-arg=\$JAVA_OPTS" \
    --add-flags "-configuration=/tmp/.cache/jdtls" \
    --add-flags "-data=/tmp/jdtls_workspace"

    cp -r * $out
  '';
}
