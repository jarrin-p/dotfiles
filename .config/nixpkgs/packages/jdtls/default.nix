{
  stdenv,
  callPackage,
  fetchzip,
  jdk17,
  makeWrapper,
  python39
}:
let
  lombok = (callPackage ../lombok/default.nix {});
in
stdenv.mkDerivation {
  name = "jdtls";
  system = builtins.currentSystem;

  src = fetchzip {
    url = "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.28.0/jdt-language-server-1.28.0-202309281329.tar.gz";
    sha256 = "sha256-Kz8+e/VKc5DeG3SZAn7cuKA0XaAygEHhXN4SvbQTVxQ=";
    stripRoot = false; # zip contains tree
  };

  buildInputs = [
    jdk17
    makeWrapper
    python39
    lombok
  ];

  inherit lombok jdk17;

  # clean this up? why are there two cp -r $out?
  installPhase = ''
    mkdir $out
    cp -r * $out
    makeWrapper $out/bin/jdtls $out/bin/jdtlsw \
    --set "JAVA_HOME" "$jdk17" \
    --add-flags "--jvm-arg=-javaagent:$lombok/lombok.jar" \
    --add-flags "-configuration=/tmp/.cache/jdtls" \
    --add-flags "-data=/tmp/jdtls_workspace"

    cp -r * $out
  '';
}
