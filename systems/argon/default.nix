{
  modulesPath,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ./hardware-configuration.nix
    ./jellyfin.nix

    inputs.self.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  bikeshed.activation-diff.enable = true;
  bikeshed.profiles.server = {
    enable = true;
    systemUser = "argon";
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;

    authorizedKeysInHomedir = false;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      # "github.com/caddyserver/cache-handler@v0.16.0"
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
    };
  };

  environment.systemPackages = with pkgs; [
    broot
    btop
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
