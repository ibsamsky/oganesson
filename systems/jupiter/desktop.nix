{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
  };

  # desktops/compositors
  services.desktopManager = {
    cosmic.enable = true;
    gnome.enable = true;
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
