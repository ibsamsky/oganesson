{ lib, ... }:

{
  flake.nixosModules.default =
    { config, ... }:
    let
      cfg = config.oganesson.substituters;
    in
    {
      options.oganesson.substituters.enable = lib.mkEnableOption "extra substituters for nix" // {
        default = true;
      };

      config = lib.mkIf cfg.enable {
        # TODO: https://github.com/cjshearer/nixos-config/commit/74a4b050d5d1863417e690c9e7d9454d978a3477
        # https://github.com/manic-systems/ncro

        nix.settings = {
          substituters = [ "https://cark.cachix.org" ];
          trusted-public-keys = [ "cark.cachix.org-1:Ze1WxAMGwBLypgd0qLqM2JIVTGSBPtVyreJyUu4UqXk=" ];
        };
      };
    };
}
