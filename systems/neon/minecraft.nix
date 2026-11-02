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
  age.secrets.b2-restic-env.rekeyFile = ../../secrets/b2-restic-env.age;

  services.restic.backups.mcdl = {
    initialize = true;
    paths = [ "/root/.local/share/mcdl/instance" ];
    repository = "s3:s3.us-east-005.backblazeb2.com/cark-mxsxppghej/neon-mcdl";
    environmentFile = config.age.secrets.b2-restic-env.path;
    passwordFile = config.age.secrets.mcdl-restic-password.path;
    timerConfig.OnCalendar = "daily";
    pruneOpts = [
      "--max-unused 5%"
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
}
