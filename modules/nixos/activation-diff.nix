{ lib, moduleWithSystem, ... }:

{
  flake.nixosModules.default = moduleWithSystem (
    # perSystem args
    # FIXME?: pkgs not configurable...?
    { pkgs, ... }:
    # normal module args
    { config, ... }:
    let
      cfg = config.bikeshed.activation-diff;
    in
    {
      options.bikeshed.activation-diff = {
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
