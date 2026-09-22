{ lib, pkgs, ... }:

let
  hexDigit = i: if i < 10 then toString i else builtins.elemAt [ "A" "B" "C" "D" "E" "F" ] (i - 10);

  themes = import ../../data/themes.nix;

  mkColors = name: map (i: themes.${name}.palette."base0${hexDigit i}") (lib.range 0 15);
in
{
  console = {
    earlySetup = true;

    colors = mkColors "chalk";
    font = "cozette6x13";

    packages = with pkgs; [ cozette ];
  };
}
