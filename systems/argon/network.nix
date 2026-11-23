{
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;

    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.caddy = {
    enable = true;
    openFirewall = true;
  };

  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "100.64.0.0/10"
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
