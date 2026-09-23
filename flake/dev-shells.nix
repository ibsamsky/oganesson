{
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        nil
        statix

        just
        nushell

        config.agenix-rekey.package
      ];
    };
  };
}
