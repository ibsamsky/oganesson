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
        # HACK: refactor according to https://flake.parts/define-module-in-separate-file.html
        # or some other method (i.e., use options to pass configs)
        specialArgs = { inherit inputs; };
        modules = [
          (./. + "/${system}")
        ];
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
