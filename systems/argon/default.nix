{
  modulesPath,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  zramSwap.enable = true;

  services.openssh = {
    enable = true;

    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    broot
    btop
    nh
    tmux
  ];

  programs = {
    git.enable = true;
    vim.enable = true;
    nix-ld.enable = true;
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNPBrq6mhWKWuz3M+417DeZ9LEbkQNrmCSa4bWUNFX jupiter"
    ];

    cark = {
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$wJJV3tG/i9jFW2MMcb/Ju1$ZAwAYr2xFoJ9CTruw0XBaa6bXR5LU.HShyRa5R6xoV2";
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNPBrq6mhWKWuz3M+417DeZ9LEbkQNrmCSa4bWUNFX jupiter"
      ];
    };
  };

  system.stateVersion = "26.05";
}
