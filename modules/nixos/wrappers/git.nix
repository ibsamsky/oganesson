{
  flake.wrappers.git =
    {
      wlib,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.git ];
      settings = {
        core = {
          compression = 8;
          pager = "${lib.getExe pkgs.bat} --plain --pager '${lib.getExe pkgs.less} -RF -+X'";
        };
        diff = {
          algorithm = "minimal";
          colorMoved = "dimmed-zebra";
          colorMovedWS = "allow-indentation-change";
        };
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;
      };
    };
}
