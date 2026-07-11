{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.statix

          pkgs.just
          pkgs.jq
          pkgs.yaml2json

          inputs'.agenix.packages.agenix
        ];
      };
    };
}
