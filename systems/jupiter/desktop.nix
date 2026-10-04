{ pkgs, ... }:

{
  # configure keyboard layout (X and Wayland)
  services.xserver.xkb = {
    layout = "us";
    options = "";
  };

  xdg.portal = {
    enable = true;
  };

  # desktops/compositors
  services.desktopManager.gnome.enable = true;
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # fix niri-session environment setup from greetd
  systemd.user.services.niri.enableDefaultPath = false;

  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    fuzzel
    ghostty
    mako
    playerctl
    swayidle
    swaylock
    tuigreet
    waybar
    xwayland-satellite
  ];
}
