# TODO: use `nh` instead
{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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
    };
}
