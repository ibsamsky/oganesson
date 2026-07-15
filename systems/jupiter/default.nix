{ inputs, lib, pkgs, ... }:

{
  imports = [
    ./console.nix
    ./hardware-configuration.nix
    # toggle vm-specific options, remove for bare metal
    ./vm.nix
    
    inputs.self.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  bikeshed.activation-diff.enable = true;
  bikeshed.test.enable = true;

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

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

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
      # TODO: really, this should be home-manager'd (or equivalent)
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      options = "";
    };
  };

  xdg.portal = {
    enable = true;
  };

  # display manager
  services.greetd = {
    enable = true;

    useTextGreeter = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.tuigreet} -t -r --remember-user-session --asterisks -g 'Welcome to NixOS!' -c $SHELL";
    };
  };

  # desktops/compositors
  services.desktopManager.gnome.enable = true;
  programs = {
    sway.enable = true;

    niri = {
      enable = true;
      useNautilus = false;
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    broot
    btop
    compsize
    fzf
    ghostty
    hyfetch
    just
    nil
    nixfmt
    tuigreet
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "26.05";
}
