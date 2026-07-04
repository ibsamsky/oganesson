{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd:5"
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

  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    broot
    btop
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

  networking = {
    hostName = "neon";
    defaultGateway = "10.0.0.1";

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.45";
          prefixLength = 24;
        }
      ];
      useDHCP = true;
    };

    firewall = {
      allowPing = true;
    };
  };

  services.fail2ban = {
    enable = true;
    bantime-increment.rndtime = "2m";
  };

  system.stateVersion = "26.05";
}
