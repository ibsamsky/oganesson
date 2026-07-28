{ pkgs, ... }:

{
  services.qbittorrent = {
    enable = true;

    extraArgs = [ "--confirm-legal-notice" ];

    serverConfig = {
      Preferences = {
        WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        };
      };
    };
  };

  # TODO: vpn config
}
