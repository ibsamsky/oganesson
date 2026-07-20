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

          inputs'.agenix.packages.agenix
        ];
      };
    };
}
