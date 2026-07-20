{ lib, pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/Jellyfin

  # QSV is functionally deprecated for CPUs before Tiger Lake #fuuuuck
  # https://discourse.nixos.org/t/intel-media-sdk-has-become-deprecated/66998
  # ^ this is actually linked from the wiki page but i never saw it

  services.jellyfin = {
    enable = true;
    openFirewall = true; # TODO: reverse proxy

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
      libva-vdpau-driver # possibly not required
    ];
  };

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];
}
