{
  pkgs,
  config,
  lib,
  ...
}:

let
  qb-set-pw = pkgs.writers.writeNuBin "qb-set-pw" ''
    def main [conf: string, secret: string] {
      let pw = open $secret --raw | str trim
      let entry = $"WebUI\\Password_PBKDF2=($pw)"
      let text = open $conf --raw

      let key_pattern = '(?m)^WebUI\\Password_PBKDF2=.*$'

      let updated = if ($text =~ $key_pattern) {
        $text | str replace --regex $key_pattern $entry
      } else if ($text =~ '(?m)^\[Preferences\]$') {
        $text | str replace '[Preferences]' $"[Preferences]\n($entry)"
      } else {
        ($text | str trim) + $"\n\n[Preferences]\n($entry)\n"
      }

      $updated | save --force $conf
      chmod 600 $conf
    }
  '';
in
{
  users.groups.media.members = [ config.services.qbittorrent.user ];

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];

  # WebUI password hash via agenix-rekey. This must stay out of serverConfig
  # because serverConfig is rendered into a world-readable /nix/store file.
  age.secrets.qbittorrent-password = {
    rekeyFile = ../secrets/qbittorrent-password.age;
    # service user must own the file to read it
    owner = config.services.qbittorrent.user;
  };

  services.qbittorrent = {
    enable = true;
    torrentingPort = 6881;

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
        };
      };
    };
  };

  systemd.services.qbittorrent = {
    # restart when the rekeyed secret changes
    restartTriggers = [ config.age.secrets.qbittorrent-password.file ];

    serviceConfig = {
      # inject agenix secret into config
      ExecStartPre = lib.mkAfter [
        ''${lib.getExe qb-set-pw} "${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf" "${config.age.secrets.qbittorrent-password.path}"''
      ];

      # allow group write access to downloads (for hardlinking to library)
      UMask = "0007";
    };
  };

  # TODO: vpn config
}
