{ inputs, config, ... }:

{
  environment.systemPackages = [
    # FIXME: module system guhhhhhh
    inputs.mcdl.packages.${config.nixpkgs.hostPlatform.system}.mcdl
  ];

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];

  programs.nix-ld.enable = true;

  age.secrets.mcdl-restic-password.rekeyFile = ./secrets/mcdl-restic-password.age;

  services.restic.backups.mcdl = {
    initialize = true;
    paths = [ "/root/.local/share/mcdl/instance" ];
    repository = "sftp:neon-backup@pve.cloudforest-alewife.ts.net:/mnt/data/mc/neon-mcdl";
    passwordFile = config.age.secrets.mcdl-restic-password.path;
    timerConfig.OnCalendar = "daily";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
}
