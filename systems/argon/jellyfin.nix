{ pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    hardwareAcceleration = {
      enable = true;
      type = "qsv";
      device = "/dev/dri/renderD128";
    };
  };

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-ocl
      intel-media-driver
      intel-compute-runtime-legacy1 # ?
    ];
  };

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];
}
