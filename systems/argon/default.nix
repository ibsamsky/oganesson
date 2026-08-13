{
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ./hardware-configuration.nix
    ./network.nix

    ./services
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  oganesson.profiles.server = {
    enable = true;
    systemUser = "argon";
  };

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    broot
    gitMinimal
    nh
    tmux
  ];

  programs = {
    vim.enable = true;
  };

  users.users.argon.extraGroups = [
    "media"
    "wheel"
  ];

  users.groups.media.gid = 2000;

  system.stateVersion = "26.05";
}
