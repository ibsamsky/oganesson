# eww boilerplate
{ lib, ... }:

{
  flake.nixosModules.default =
    { config, ... }:
    let
      cfg = config.bikeshed.test;
    in
    {
      options.bikeshed.test = {
        enable = lib.mkEnableOption "test module";
      };

      config = lib.mkIf cfg.enable {
        time.timeZone = lib.mkForce "America/Chicago";
      };
    };
}
