{ pkgs }:
let
  jar_file = "groovy-language-server-all.jar";
in
with pkgs; stdenv.mkDerivation rec {
  name = "groovyls";
  system = builtins.currentSystem;

  dontUnpack = true;
  src = fetchurl {
    # url = ("https://github.com/jarrin-p/groovy-language-server/releases/download/release-1/groovy-language-server-all.jar");
    # https://objects.githubusercontent.com/github-production-release-asset-2e65be/670581381/0a35dff4-a939-44e5-b6bd-b07df340a046?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230725%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230725T122132Z&X-Amz-Expires=300&X-Amz-Signature=2d923e1bba64d9db7d87d41478a7e173f1f294d9328ff49bc3652618c9f11265&X-Amz-SignedHeaders=host&actor_id=44330192&key_id=0&repo_id=670581381&response-content-disposition=attachment%3B%20filename%3Dgroovy-language-server-all.jar&response-content-type=application%2Foctet-stream
    url = "https://github.com/jarrin-p/groovy-language-server/releases/download/release-1/groovy-language-server-all.jar";
    sha256 = "sha256-fNIoxaThmwnCqVJ4GDuyRK8ILVsqvBCgAt2J5Qm7UwA=";
  };

  buildInputs = [
    jdk17
    makeWrapper
  ];

  inherit jdk17;

  # installPhase has access to what's included from `src`.
  # i.e., current directory has access to `groovy-language-server-all.jar`
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/groovy-language-server-all.jar
    echo ""
    ls -al ${src}
    ls -al $out/bin
    echo ""
    makeWrapper $jdk17/bin/java $out/bin/groovyls \
    --set "JAVA_HOME" "$jdk17" \
    --add-flags "-jar $out/bin/groovy-language-server-all.jar"
  '';
}
