{ lib, ... }:

{
  # btrfs deduplication daemon
  services.beesd.filesystems.root = {
    spec = lib.mkDefault "/";
    hashTableSizeMB = lib.mkDefault 128;
    verbosity = lib.mkDefault "crit";
  };

  services.btrfs.autoScrub.enable = lib.mkDefault true;
}
