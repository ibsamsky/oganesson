{ inputs, ... }:

let
  allSystems = [ "jupiter" ];
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosConfigurations =
    # surely there's a better way... :)
    lib.genAttrs allSystems (
      system:
      lib.nixosSystem {
        modules = [ (./. + "/${system}") ];
      }
    );
}
