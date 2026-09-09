{ inputs, ... }:

{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      programs = {
        actionlint.enable = true;
        deadnix.enable = true;
        just.enable = true;
        nixfmt = {
          enable = true;
          strict = true;
        };
        oxfmt = {
          enable = true;
          includes = [ "*.md" ];
        };
      };
    };
  };
}
