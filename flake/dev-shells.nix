{
  perSystem = { pkgs, inputs', ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        nil
        statix

        just

        inputs'.agenix.packages.agenix
      ];
    };
  };
}
