{ inputs, config, ... }:

{
  environment.systemPackages = [
    # FIXME: module system guhhhhhh
    inputs.mcdl.packages.${config.nixpkgs.hostPlatform.system}.mcdl
  ];

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
