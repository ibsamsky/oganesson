{
  config,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disko.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.loader.systemd-boot = {
    enable = true;

    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs72T+gf+yjYirBSwnurLvxHJgo85RpftJU6ic/RVtn root@jupiter"
    ];
  };

  system.stateVersion = "26.05";
}
