{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./console.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./hjem
    # toggle vm-specific options, remove for bare metal
    ./vm.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  oganesson.activation-diff.enable = true;
  oganesson.profiles.graphical.enable = true;

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # btrfs mount options
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd:5"
      "noatime"
    ];
  };

  # btrfs deduplication daemon
  services.beesd.filesystems = {
    root = {
      # FIXME: hardware specific
      spec = "UUID=633f5dce-3364-47bb-b14d-3f7024955ab6";
      hashTableSizeMB = 128;
      verbosity = "crit";
    };
  };

  # enable zram swap and systemd-oomd
  zramSwap.enable = true;
  systemd.oomd = {
    enable = true;

    # from https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/system/boot/systemd/oomd.nix: fedora defaults
    enableRootSlice = true;
    enableUserSlices = true;
  };

  hardware.graphics.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;

    consoleMode = "auto";
    netbootxyz.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jupiter";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # allow unfree packages as needed
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];

  programs = {
    firefox = {
      enable = true;
      # don't pull in speechd
      wrapperConfig.speechSynthesisSupport = false;
    };

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

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
  };

  # display manager
  services.greetd = {
    enable = true;

    useTextGreeter = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.tuigreet} -t -r --remember-user-session --asterisks -g 'Welcome to NixOS!' -c $SHELL";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  services.gnome.gnome-keyring.enable = true;

  users.users.cark = {
    isNormalUser = true;
    # TODO: agenix + hashedPasswordFile
    initialHashedPassword = "$y$j9T$GOa6jtaMbTB.dmg1JCbk51$gsCZ1jTjhZzTCnIfTtEphlfJKp1i1rHCDpWXg4VDq61";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’
    packages = [ ];
  };

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # disable screen reader support
    orca.enable = false;
    speechd.enable = false;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bat
    broot
    btop
    direnv
    eza
    fd
    intel-media-driver
    nix-direnv
    ripgrep
    vpl-gpu-rt
    zoxide
  ];

  system.stateVersion = "26.05";
}
