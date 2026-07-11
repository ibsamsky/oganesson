{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    ./network.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
    "/".options = [
      "compress=zstd"
      "compress-force=zstd"
    ];
    "/home".options = [
      "compress=zstd"
      "compress-force=zstd"
    ];
    "/nix".options = [
      "compress=zstd:5"
      "compress-force=zstd:5"
      "noatime"
    ];
  };

  services.beesd.filesystems = {
    root = {
      # FIXME: hardware specific
      spec = "UUID=45f2741f-fde8-458c-8b5a-1c6246998fc7";
      hashTableSizeMB = 128;
      verbosity = "crit";
    };
  };

  zramSwap.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    broot
    btop
    nh
    tmux
  ];

  time.timeZone = "America/New_York";

  programs = {
    git = {
      enable = true;
      # system-level git config
      config = {
        core.compression = 8;
        diff.algorithm = "minimal";
        init.defaultBranch = "main";
      };
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      # .ssh/keys/oci-ampere-fki5na.pub
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLEZAUiOVKUPLkmK5grutbZVKUtTsUIEPPVFjMJMnlA8r6e7eUKuXefVCZ04A/F0yCNHZDHWbGEXPHjjSaoAl5/MFi8yp2ruCXBLa+XsvSYv1cy+cwVhpZxW8rC4qrTRjVqbTdhW2feCNCfgSMrSfOmfIuUJ/YCMKmj/c0gKzIdY6WQwWoJR7tSVykYj5UlPyb8Yn6Zw1UTQad+Pn6y7V/B9o79Xg9On5HyaTs1np5PTeVWHYqKlpG8VQTgA5p9jNE4e5Lgm5A4eEJakIk4WabU5gs7yPYaQmLxdteHmmCupZrBQmS/FhBB7b0+oEHJXhYqnUWeV9dUcNQl4XLoNsh root@jupiter"
    ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "26.05";
}
