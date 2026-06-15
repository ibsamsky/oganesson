{ lib, pkgs, ... }:

let
  # IFD :(
  importYAML =
    file:
    lib.importJSON (
      pkgs.runCommand "converted.json" { } ''${lib.getExe pkgs.yaml2json} < "${file}" > "$out"''
    );

  scheme = importYAML "${pkgs.base16-schemes}/share/themes/chalk.yaml";

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

  colors = map (i: lib.removePrefix "#" scheme.palette."base0${hexDigit i}") (lib.range 0 15);
in
{
  environment.systemPackages = with pkgs; [
    base16-schemes
    yaml2json
  ];

  console = {
    earlySetup = true;

    inherit colors;
    font = "cozette6x13";

    packages = with pkgs; [
      cozette
    ];
  };
}
