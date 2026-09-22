{ self, lib, ... }:

let
  inherit (lib.fileset) toList fileFilter;
  importTree = path: toList (fileFilter (f: f.hasExt "nix" && f.name != "default.nix") path);
in
{
  imports = importTree ./.;
  flake.nixosModules = builtins.mapAttrs (_: m: m.install) self.wrappers;
}
