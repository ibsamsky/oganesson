# eww boilerplate
{ lib, ... }:

{
  flake.nixosModules.default =
    { config, ... }:
    let
      cfg = config.oganesson.test;
    in
    {
      options.oganesson.test = {
        enable = lib.mkEnableOption "test module";
      };

      config = lib.mkIf cfg.enable {
        time.timeZone = lib.mkForce "America/Chicago";
      };
    };
}
