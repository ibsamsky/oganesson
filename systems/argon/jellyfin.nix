{
  config,
  lib,
  pkgs,
  ...
}:

{
  # https://wiki.nixos.org/wiki/Jellyfin

  # QSV is functionally deprecated for CPUs before Tiger Lake #fuuuuck
  # https://discourse.nixos.org/t/intel-media-sdk-has-become-deprecated/66998
  # ^ this is actually linked from the wiki page but i never saw it

  services.jellyfin = {
    enable = true;
    openFirewall = true; # even though it's proxied, this is useful for LAN access

    # apply the configuration here over what has been set in the web UI
    forceEncodingConfig = true;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      # codecs supported for decoding by the Kaby Lake family of Intel CPUs ("Gen9.5" graphics)
      hardwareDecodingCodecs = lib.genAttrs [
        "h264"
        "hevc"
        "mpeg2"
        "vc1"
        "vp8"
        "vp9"
        "hevc10bit"
      ] (lib.const true);

      # as above, but for encoding
      enableHardwareEncoding = true;
      hardwareEncodingCodecs.hevc = true;
    };
  };

  # enable the use of Low-Power encoding (Skylake and newer)
  # containers don't have a kernel... so this does nothing (TODO: set on the host)
  # boot.kernelParams = [ "i915.enable_guc=3" ];

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-ocl
      intel-media-driver
      intel-compute-runtime-legacy1
    ];
  };

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  # caddy reverse proxy definition
  services.caddy.virtualHosts."jf.direct.cark.moe".extraConfig = ''
    reverse_proxy http://localhost:8096
  '';

  # fail2ban (https://jellyfin.org/docs/general/post-install/networking/advanced/fail2ban/)
  environment.etc."fail2ban/filter.d/jellyfin.conf".text = ''
    [Definition]
    failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.$
  '';

  services.fail2ban.jails.jellyfin.settings = {
    enabled = true;
    backend = "auto";
    port = "http,https";
    protocol = "tcp";
    filter = "jellyfin";
    logpath = config.services.jellyfin.logDir + "/log_*.log";
    maxretry = 3;
    bantime = "1h";
    findtime = "30m";
  };

  systemd.timers."fail2ban-jellyfin-reload" = {
    description = "Reload Fail2Ban jellyfin jail";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "00:05";
      Persistent = true;
    };
  };

  systemd.services."fail2ban-jellyfin-reload" = {
    description = "Reload Fail2Ban jellyfin jail";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe' pkgs.fail2ban "fail2ban-client"} reload jellyfin";
    };
  };
}
