{
  bat,
  writeShellScriptBin,
  symlinkJoin,
}:
let
      wrapped = (import ./util.nix).wrapcmd "${bat}/bin/bat";
      script = (writeShellScriptBin "bat" ''
        export BAT_THEME=TwoDark
        ${wrapped}
      '');
    in
      symlinkJoin { name = "bat-join"; paths = [ (bat + /share) script ]; }
