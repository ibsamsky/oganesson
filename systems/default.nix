{ inputs, ... }:

{
  flake.nixosConfigurations = {
    # TODO: factor system builder function (doesn't matter right now bc only one system)
    jupiter = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ./jupiter ];
    };
  };
}
