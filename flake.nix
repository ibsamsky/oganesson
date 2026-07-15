{
  description = "flakey flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-26.05-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # TODO: look at agenix-rekey for more features
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    mcdl = {
      url = "github:ibsamsky/mcdl";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./flake
        ./systems
        # TODO: importTree
        ./modules/nixos/activation-diff.nix
        ./modules/nixos/test.nix
      ];

      perSystem = { pkgs, ... }: {
        # TODO: move to GH workflow to run on a schedule (and be less stupid)
        apps.update-schemes.program = pkgs.writeShellApplication {
          name = "update-schemes";
          runtimeInputs = [
            pkgs.yaml2json
            pkgs.jq
          ];
          text = ''
            outdir="$(git rev-parse --show-toplevel)/data"
            mkdir -p "$outdir"
            tmpdir="$(mktemp -d)"
            trap 'rm -rf "$tmpdir"' EXIT

            for f in ${pkgs.base16-schemes}/share/themes/*.yaml; do
              name="$(basename "$f" .yaml)"
              yaml2json < "$f" > "$tmpdir/$name.json"
            done

            jq -n -S '
              [inputs | {(input_filename | split("/") | last | rtrimstr(".json")): .}] | add
            ' "$tmpdir"/*.json > "$outdir/schemes.json"
          '';
        };
      };

      flake.scheme = inputs.nixpkgs.lib.importJSON ./data/schemes.json;
    };
}
