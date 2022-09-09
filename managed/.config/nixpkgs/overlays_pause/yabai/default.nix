# placeholder for wip of learning overlays.
# this is currently working in nixpkgs with all-packages call as:

# yabai = callPackage ../os-specific/darwin/yabai {
#   inherit (darwin.apple_sdk.frameworks) Cocoa Carbon ScriptingBridge;
#   inherit (darwin.apple_sdk_11_0.frameworks) SkyLight;
# };

# @see https://github.com/IvarWithoutBones/dotfiles/blob/32787753182cd2f922358d468c0e446a3ff327eb/pkgs/yabai/default.nix
# (thank you for sharing this in the yabai discussion.)

{ lib
, stdenv
, fetchFromGitHub
, darwin
, xxd
, xcodebuild
, Carbon
, Cocoa
, ScriptingBridge
, SkyLight
}:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DXDdjI4kkLcRUNtMoSu7fJ0f3fUty88o5ZS6lJz0cGU=";
  };

  nativeBuildInputs = [
      xxd xcodebuild
  ];

  buildInputs =  [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

  postPatch = ''
    substituteInPlace makefile \
       --replace "-arch arm64e" "" \
       --replace "-arch arm64" ""

    substituteInPlace src/workspace.m \
       --replace 'return screen.safeAreaInsets.top;' 'return 0;'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      A tiling window manager for macOS based on binary space partitioning
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae shardy ];
    license = licenses.mit;
  };
}
