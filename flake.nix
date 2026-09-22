{
  description = "flakey flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-26.05-small";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcdl = {
      url = "github:ibsamsky/mcdl";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.agenix-rekey.flakeModule
        inputs.wrappers.flakeModules.default

        ./flake
        ./systems
        # TODO: importTree
        ./modules/nixos
      ];

      perSystem = { pkgs, ... }: {
        # TODO: move to GH workflow to run on a schedule (and be less stupid)
        apps.update-schemes.program = pkgs.writers.writeNuBin "update-schemes" (
          pkgs.replaceVars ./scripts/update-schemes.nu { base16_schemes = "${pkgs.base16-schemes}"; }
        );
      };
    };
}
