{
  disko.devices = {
    disk.sda = {
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
                "compress-force=zstd"
              ];

              subvolumes = {
                home = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "compress-force=zstd"
                  ];
                };
                nix = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:5"
                    "compress-force=zstd:5"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
