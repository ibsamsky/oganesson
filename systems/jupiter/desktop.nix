{ lib, pkgs, ... }:

{
  # configure keyboard layout (X and Wayland)
  services.xserver.xkb = {
    layout = "us";
    options = "";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  # desktops/compositors
  services.desktopManager.gnome.enable = true;
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # fix niri-session environment setup from greetd
  systemd.user.services.niri.enableDefaultPath = false;

  # idle lock and monitor poweroff
  systemd.user.services.swayidle = {
    description = "idle lock and monitor power-off for niri";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.swayidle} -w timeout 300 '${lib.getExe pkgs.swaylock} -f' timeout 600 'niri msg action power-off-monitors' before-sleep '${lib.getExe pkgs.swaylock} -f'";
      Restart = "on-failure";
    };
  };

  # night light
  systemd.user.services.wlsunset = {
    description = "night light for wayland";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.wlsunset} -l 35.9 -L -79.0 -t 3000 -T 6500";
      Restart = "on-failure";
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    fuzzel
    ghostty
    mako
    networkmanagerapplet
    pavucontrol
    playerctl
    quickshell
    swayidle
    swaylock
    tuigreet
    waybar
    wl-clipboard
    wlsunset
    xwayland-satellite
  ];
}
