{
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        nil
        statix

        just

        config.agenix-rekey.package
      ];
    };
  };
}
