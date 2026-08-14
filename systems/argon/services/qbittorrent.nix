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
          QueueingSystemEnabled = false;
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
    Umask = "0007";
  };

  # TODO: vpn config
}
