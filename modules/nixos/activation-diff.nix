# TODO: use `nh` instead
{ lib, moduleWithSystem, ... }:

{
  flake.nixosModules.default = moduleWithSystem (
    # perSystem args
    { pkgs, ... }:
    # normal module args
    { config, ... }:
    let
      cfg = config.oganesson.activation-diff;
    in
    {
      options.oganesson.activation-diff = {
        enable = lib.mkEnableOption "configuration diff on activation";
      };

      config = lib.mkIf cfg.enable {
        system.activationScripts.activation-diff = {
          supportsDryActivation = true;

          text = ''
            ${lib.getExe pkgs.dix} /run/current-system "$systemConfig"
          '';
        };
      };
    }
  );
}
