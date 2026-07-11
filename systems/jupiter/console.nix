{
  inputs,
  lib,
  pkgs,
  ...
}:

let
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

  mkColors =
    name:
    map (i: lib.removePrefix "#" inputs.self.scheme.${name}.palette."base0${hexDigit i}") (lib.range 0 15);
in
{
  console = {
    earlySetup = true;

    colors = mkColors "chalk";
    font = "cozette6x13";

    packages = with pkgs; [
      cozette
    ];
  };
}
