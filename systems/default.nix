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

            # FIXME: temporary workaround for eMudhra compromise; remove once fix appears in channel
            security.pki.caCertificateBlacklist = [
              # CVE-2026-111943
              "Comodo AAA Services root"
              # https://hg-edge.mozilla.org/projects/nss/rev/26d38a0c3fb81e7fb2acedbaf4c42dd21dce0517
              "emSign ECC Root CA - G3"
              # https://hg-edge.mozilla.org/projects/nss/rev/8159223c48ceeb1273a1915bca95a517294ab0e0
              "emSign Root CA - C1"
              "emSign ECC Root CA - C3"
            ];
          }

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
