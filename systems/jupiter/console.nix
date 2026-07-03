{ lib, pkgs, ... }:

let
  # IFD :(
  importYAML =
    file:
    lib.importJSON (
      pkgs.runCommand "converted.json" { } ''${lib.getExe pkgs.yaml2json} < "${file}" > "$out"''
    );

  hexDigit =
    i:
    if i < 10 then
      toString i
    else
      builtins.elemAt [
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
      ] (i - 10);

  mkScheme = name: importYAML "${pkgs.base16-schemes}/share/themes/${name}.yaml";
  mkColors =
    name: map (i: lib.removePrefix "#" (mkScheme name).palette."base0${hexDigit i}") (lib.range 0 15);
in
{
  environment.systemPackages = with pkgs; [
    base16-schemes
    yaml2json
  ];

  console = {
    earlySetup = true;

    colors = mkColors "chalk";
    font = "cozette6x13";

    packages = with pkgs; [
      cozette
    ];
  };
}
