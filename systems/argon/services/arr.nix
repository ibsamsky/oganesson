{ config, ... }:

{
  services.seerr.enable = true;

  services.caddy.virtualHosts."request.cark.moe".extraConfig = ''
    reverse_proxy http://localhost:${toString config.services.seerr.port}
  '';

  services.prowlarr.enable = true;
  services.radarr.enable = true;
  services.sonarr.enable = true;
}
