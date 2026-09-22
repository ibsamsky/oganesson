{
  flake.wrappers.hyfetch = { wlib, ... }: {
    imports = [ wlib.wrapperModules.hyfetch ];
    settings = {
      preset = "rainbow";
      mode = "rgb";
      color_align.mode = "horizontal";
      backend = "fastfetch";
      pride_month_disable = true;
    };
  };
}
