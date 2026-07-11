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
    ./hardware-configuration.nix
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEZAUiOVKUPLkmK5grutbZVKUtTsUIEPPVFjMJMnlA8r6e7eUKuXefVCZ04A/F0yCNHZDHWbGEXPHjjSaoAl5/MFi8yp2ruCXBLa+XsvSYv1cy+cwVhpZxW8rC4qrTRjVqbTdhW2feCNCfgSMrSfOmfIuUJ/YCMKmj/c0gKzIdY6WQwWoJR7tSVykYj5UlPyb8Yn6Zw1UTQad+Pn6y7V/B9o79Xg9On5HyaTs1np5PTeVWHYqKlpG8VQTgA5p9jNE4e5Lgm5A4eEJakIk4WabU5gs7yPYaQmLxdteHmmCupZrBQmS/FhBB7b0+oEHJXhYqnUWeV9dUcNQl4XLoNsh root@jupiter"
    ];
  };

  system.stateVersion = "26.05";
}
