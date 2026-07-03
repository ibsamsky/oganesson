{ inputs, ... }:

let
  allSystems = [
    "jupiter"
  ]
  ++ anywhereSystems;

  anywhereSystems = [
    "neon"
  ];

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
    )
    // lib.genAttrs' anywhereSystems (
      system:
      lib.nameValuePair "${system}-install" (
        lib.nixosSystem {
          modules = [
            inputs.disko.nixosModules.disko
            (./. + "/${system}/install")
          ];
        }
      )
    );
}
