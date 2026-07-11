{ lib, ... }:

let
  # looks confusing because point-free style
  # reduces { a = { b = { ... }; }; } to { a-b = { ... }; }
  flattenOneLevel = lib.concatMapAttrs (
    outerName: lib.mapAttrs' (innerName: lib.nameValuePair "${outerName}-${innerName}")
  );
in
{
  perSystem =
    { self', ... }:
    {
      checks = flattenOneLevel {
        inherit (self') devShells;
      };
    };
}
