{ lib, ... }:

{
  # btrfs deduplication daemon
  services.beesd.filesystems.root = {
    spec = lib.mkDefault "/";
    hashTableSizeMB = lib.mkDefault 128;
    verbosity = lib.mkDefault "crit";
  };

  # useless because of bees
  nix.settings.auto-optimise-store = lib.mkForce false;
  nix.optimise.automatic = lib.mkForce false;
}
