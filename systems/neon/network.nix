{
  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh = {
    enable = true;

    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
      # apply penalties to the entire /64 network block for IPv6, instead of the individual IP address
      PerSourceNetBlockSize = "32:64";
    };
  };

  networking = {
    hostName = "neon";
    defaultGateway = "10.0.0.1";

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    interfaces.eth0 = {
      ipv4.addresses = [
        {
          # configured in OCI console
          address = "10.0.0.45";
          prefixLength = 24;
        }
      ];
      useDHCP = true;
    };
  };

  services.fail2ban = {
    enable = true;

    bantime-increment = {
      enable = true;
      rndtime = "2m";
      factor = "1.5";
      formula = "ban.Time * (banFactor ** ban.Count)";
    };
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
