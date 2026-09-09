{ lib, self, ... }:

let
  # looks confusing because point-free style
  # reduces { a = { b = { ... }; }; } to { a-b = { ... }; }
  flattenOneLevel = lib.concatMapAttrs (
    outerName: lib.mapAttrs' (innerName: lib.nameValuePair "${outerName}-${innerName}")
  );

  # map a set of NixOS configurations to a set of derivations that build the system's toplevel configuration
  cfgsToDrvs = lib.mapAttrs (_: c: c.config.system.build.toplevel);

  # filter configurations that are compatible with a given system
  filterCompatibleCfgs = system: lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
in
{
  perSystem =
    { self', system, ... }:
    let
      # map each set of configurations to a set of derivations
      # flattened to e.g. `nixosConfigurations-<name>`
      configs = lib.mapAttrs (_: cs: cfgsToDrvs (filterCompatibleCfgs system cs)) {
        inherit (self) nixosConfigurations;
      };
    in
    {
      checks = flattenOneLevel (configs // { inherit (self') devShells; });
    };
}
