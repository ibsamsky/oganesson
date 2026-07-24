{
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ./hardware-configuration.nix
    ./jellyfin.nix
    ./network.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  bikeshed.profiles.server = {
    enable = true;
    systemUser = "argon";
  };

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

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNPBrq6mhWKWuz3M+417DeZ9LEbkQNrmCSa4bWUNFX jupiter"
    ];
  };

  system.stateVersion = "26.05";
}
