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
        nix.settings = {
          substituters = [ "https://cark.cachix.org" ];
          trusted-public-keys = [ "cark.cachix.org-1:Ze1WxAMGwBLypgd0qLqM2JIVTGSBPtVyreJyUu4UqXk=" ];
        };
      };
    };
}
