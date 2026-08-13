{ pkgs, config, ... }:

{
  users.groups.media.members = [ config.services.qbittorrent.user ];

  services.qbittorrent = {
    enable = true;

    # we DON'T need to open the firewall (UPnP works fine)

    serverConfig = {
      BitTorrent = {
        Session = {
          AddTrackersFromURLEnabled = true;
          AnonymousModeEnabled = true;
          AdditionalTrackersURL = "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt";
          GlobalMaxRatio = 2;
          GlobalMaxSeedingMinutes = 4320; # 72 hours
          QueueingSystemEnabled = false;
          ShareLimitAction = "Remove";
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

  # TODO: vpn config
}
