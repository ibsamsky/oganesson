{ lib, pkgs, ... }:

{
  networking.firewall.enable = true;

  services.openssh = {
    enable = true;

    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.caddy = {
    enable = true;
    openFirewall = true;

    package = pkgs.caddy.withPlugins {
      # "github.com/caddyserver/cache-handler@v0.16.0"
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
    };
  };

  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "100.0.0.0/8"
      "10.0.0.0/8"
    ];

    # TODO: `banaction = "iptables-allports";` ?

    bantime-increment = {
      enable = true;
      rndtime = "2m";
      factor = "1.5";
      formula = "ban.Time * (banFactor ** ban.Count)";
    };
  };
}
