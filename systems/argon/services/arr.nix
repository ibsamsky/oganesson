{ config, ... }:

let
  svc = config.services;
in
{
  users.groups.media.members = [
    svc.radarr.user
    svc.sonarr.user
  ];

  users.users.profilarr = {
    isSystemUser = true;
    group = "profilarr";
  };
  users.groups.profilarr = { };

  virtualisation.oci-containers.containers.profilarr = {
    image = "ghcr.io/dictionarry-hub/profilarr:2.2.0";
    autoStart = true;
    ports = [ "6868:6868" ];
    volumes = [ "/var/lib/profilarr/config:/config" ];
    environment = {
      PUID = toString config.users.users.profilarr.uid;
      PGID = toString config.users.groups.profilarr.gid;
      TZ = "America/New_York";
    };
    extraOptions = [ "--network=pasta:--map-host-loopback=10.0.0.1" ];
  };

  # create the config dir for profilarr and set ownership to the container user
  systemd.services.podman-profilarr.preStart = ''
    mkdir -p /var/lib/profilarr/config
    chown -R profilarr:profilarr /var/lib/profilarr/config
  '';

  services.seerr.enable = true;

  services.caddy.virtualHosts."request.cark.moe".extraConfig = ''
    reverse_proxy http://127.0.0.1:${toString config.services.seerr.port}
  '';

  services.flaresolverr.enable = true;
  services.prowlarr.enable = true;
  services.radarr.enable = true;
  services.sonarr.enable = true;

  age.secrets.arr-restic-password = {
    rekeyFile = ../secrets/arr-restic-password.age;
    generator.script = "alnum";
  };

  age.secrets.b2-restic-env.rekeyFile = ../../../secrets/b2-restic-env.age;

  services.restic.backups.arr = {
    initialize = true;
    paths = [
      "/var/lib/profilarr/config"
      svc.prowlarr.dataDir
      svc.radarr.dataDir
      svc.sonarr.dataDir
      # seerr uses DynamicUser, so systemd stores its state under /var/lib/private
      "/var/lib/private/seerr"
    ];
    repository = "s3:s3.us-east-005.backblazeb2.com/cark-mxsxppghej/argon-arr";
    environmentFile = config.age.secrets.b2-restic-env.path;
    passwordFile = config.age.secrets.arr-restic-password.path;
    timerConfig.OnCalendar = "daily";
    pruneOpts = [
      "--max-unused 5%"
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
}
