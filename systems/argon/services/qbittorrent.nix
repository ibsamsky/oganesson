{ pkgs, config, ... }:

{
  users.groups.media.members = [ config.services.qbittorrent.user ];

  services.qbittorrent = {
    enable = true;

    # we DON'T need to open the firewall (UPnP works fine)

    serverConfig = {
      BitTorrent = {
        Session = {
          DefaultSavePath = "/mnt/media/download";
          DisableAutoTMMByDefault = false;
          DisableAutoTMMTriggers = {
            CategorySavePathChanged = false;
            DefaultSavePathChanged = false;
          };
          MaxConnections = -1;
          MaxConnectionsPerTorrent = 50;
          MaxUploads = 75;
          MaxUploadsPerTorrent = -1;
          QueueingSystemEnabled = false;
          SendBufferLowWatermark = 512;
          SendBufferWatermark = 4096;
          SendBufferWatermarkFactor = 150;
        };
      };

      LegalNotice.Accepted = true;

      Preferences = {
        Advanced.markOfTheWeb = false;
        WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";

          Username = "admin";
          Password_PBKDF2 = "r5K+xdm0azWaEpnsIzeIYw==:WL/949LD7ZlAzzVvLVK7KMVylm3J6MKllLAzYgOXQ3jAERmPeayH/TqId2G180DWjJpGBZhZVZimEZQ+HZiEGg==";
        };
      };
    };
  };

  # allow group write access to downloads (for hardlinking to library)
  systemd.services.qbittorrent.serviceConfig = {
    UMask = "0007";
  };

  # TODO: vpn config
}
