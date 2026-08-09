{ lib, ... }:

{
  flake.nixosModules.default =
    { config, ... }:
    let
      cfg = config.oganesson.profiles.server;
    in
    {
      options.oganesson.profiles.server = {
        enable = lib.mkEnableOption "common configurations for server systems";
        systemUser = lib.mkOption {
          type = lib.types.str;
          default = config.networking.hostName;
          defaultText = "config.networking.hostName";
          description = "The unprivileged user to be used for most operations on the server.";
        };
      };

      config = lib.mkIf cfg.enable {
        documentation.enable = false;

        nix.gc = {
          automatic = lib.mkDefault config.nix.enable;
          dates = lib.mkDefault "*/6:00"; # every 6 hours
          options = lib.mkDefault "--delete-older-than 5d";
        };

        system.autoUpgrade = {
          enable = true;

          dates = "hourly";
          flake = "github:ibsamsky/oganesson";
        };

        # unprivileged user for most operations
        users.users.${cfg.systemUser} = {
          isNormalUser = true;

          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNPBrq6mhWKWuz3M+417DeZ9LEbkQNrmCSa4bWUNFX jupiter"
          ];
        };
      };
    };
}
