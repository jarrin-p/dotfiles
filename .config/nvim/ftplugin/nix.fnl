(set vim.o.tabstop 2)

(let [{: text : add-language-snippets : ins : text-array} (require :utils.snippets)]
  (add-language-snippets :nix
                         [[:__nixpkgsPin
                           (text "import (builtins.fetchTarball { url = \"https://api.github.com/repos/nixos/nixpkgs/tarball/24.05\"; }) {}")]
                          [:__ghcWithPkgs
                           (text "(haskellPackages.ghcWithPackages (hpkgs: [hpkgs.aeson]))")]
                          [:__luajitWithPkgs
                           (text "(luajit.withPackages (lpkgs: [lpkgs.fennel]))")]
                          [:__gradleWithVersion
                           (text "pkgs.gradle_7.override{ java = pkgs.jdk11; }")]
                          [:__sbtWithJdkOverride
                           (text "(pkgs.sbt.override { jre = pkgs.jdk20; })")]
                          [:__buildEnv
                           (text-array ["pkgs.buildEnv {"
                                        "\tname = \"\";"
                                        "\tpaths = [];"
                                        "};"])]
                          [:__fetchTar
                           (text-array ["builtins.fetchTarball {"
                                        "\turl = \"\";"
                                        "\tsha256 = \"\";"
                                        "};"])]
                          [:__mkShell
                           [(ins 1 :variableName)
                            (text-array [" = pkgs.mkShell {"
                                         "\tname = \"\";"
                                         "\tpaths = [];"
                                         "\tshellHook = ''"
                                         "\t'';"
                                         "};"])]]
                          [:__mkDerivation
                           [(ins 1 :variableName)
                            (text-array [" = pkgs.stdenv.mkDerivation {"
                                         "\t# escape hatch allowing for some impurity."
                                         "\t__noChroot = false;"
                                         ""
                                         "\tpname = \"\";"
                                         "\tversion = \"0.0.1\";"
                                         ""
                                         "\tsrc = ./.;"
                                         ""
                                         "\t# see https://github.com/NixOS/nixpkgs/issues/23099#issuecomment-964024407"
                                         "\tdontUnpack = false;"
                                         ""
                                         "\t# inputs unavailable at runtime, due to these inputs being specific to the native host platform."
                                         "\t# nativeBuildInputs = [];"
                                         ""
                                         "\tbuildInputs = with pkgs; [];"
                                         ""
                                         "\tbuildPhase = ''"
                                         "\t'';"
                                         ""
                                         "\tinstallPhase = ''"
                                         "\t\tmkdir -p $out"
                                         "\t'';"
                                         "};"])]]
                          [:__writeShellScriptBin
                           [(text "writeShellScriptBin \"")
                            (ins 1 :bin_name)
                            (text "\" ''" "")
                            (ins 2 "# your script")
                            (text "" "''")]]]))

{}
