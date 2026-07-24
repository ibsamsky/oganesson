{ config, ... }:

{
  services.seerr.enable = true;

  services.caddy.virtualHosts."request.cark.moe".extraConfig = ''
    reverse_proxy http://localhost:${builtins.toString config.services.seerr.port}
  '';
}
