{ pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/Jellyfin

  # QSV is functionally deprecated for CPUs before Tiger Lake #fuuuuck
  # https://discourse.nixos.org/t/intel-media-sdk-has-become-deprecated/66998
  # ^ this is actually linked from the wiki page but i never saw it

  services.jellyfin = {
    enable = true;
    openFirewall = true;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
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
      intel-compute-runtime-legacy1
      libva-vdpau-driver # possibly not required
    ];
  };

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];
}
