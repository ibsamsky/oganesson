{
  lib,
  self,
  inputs,
  ...
}:

let

  defaultBuilder = inputs.nixpkgs.lib.nixosSystem;
  serverBuilder = inputs.nixpkgs-small.lib.nixosSystem;

  allHosts = lib.attrNames (lib.filterAttrs (_: ty: ty == "directory") (builtins.readDir ./.));

  configurations = lib.genAttrs allHosts (lib.const { }) // {
    argon.builder = serverBuilder;
    neon = {
      anywhere = true;
      builder = serverBuilder;
    };
  };
in
{
  flake.nixosConfigurations = lib.concatMapAttrs (
    host: config:
    {
      ${host} = config.builder or defaultBuilder {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }

          inputs.hjem.nixosModules.default

          (./. + "/${host}")
        ]
        ++ builtins.attrValues self.nixosModules;
      };
    }
    // lib.optionalAttrs (config.anywhere or false) {
      "${host}-install" = config.builder or defaultBuilder {
        modules = [
          inputs.disko.nixosModules.disko
          (./. + "/${host}/install")
        ];
      };
    }
  ) configurations;
}
