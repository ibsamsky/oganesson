{ inputs, lib, ... }:

{
  flake.nixosModules.default =
    { config, ... }:
    let
      cfg = config.oganesson.secrets;
    in
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
      ];

      options.oganesson.secrets = {
        enable = lib.mkEnableOption "secrets management via agenix and agenix-rekey" // {
          default = true;
        };

        hostPubkey = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI[...]4T13nSGe neon";
          description = "the host's SSH public key";
        };

        storageName = lib.mkOption {
          type = lib.types.str;
          default = config.networking.hostName;
          defaultText = lib.literalExpression "config.networking.hostName";
          description = ''
            directory name under secrets/rekeyed/ for storing rekeyed secrets. must be stable and
            unique per host.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        age.rekey = {
          storageMode = "local";
          masterIdentities = [
            {
              identity = inputs.self + "/secrets/master-key.age";
              pubkey = "age1kj8s5c0ryynpqqn77fh7aakg3hxmtvy8ex8kvjyhgywj9eqnuumsm05mz4";
            }
          ];
        }
        // (lib.optionalAttrs (cfg.hostPubkey != "") {
          hostPubkey = cfg.hostPubkey;
          localStorageDir = inputs.self + "/secrets/rekeyed/${cfg.storageName}";
        });

        assertions = [
          {
            assertion = cfg.hostPubkey != "" -> cfg.storageName != "";
            message = "oganesson.secrets.storageName must be non-empty when hostPubkey is set.";
          }
        ];
      };

      # age.secrets.neon-root-password = {
      #   rekeyFile = inputs.self + "/secrets/neon-root-password.age";
      #   generator.script = "alnum";
      # };
    };
}
