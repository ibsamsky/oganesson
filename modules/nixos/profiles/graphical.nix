{ lib, moduleWithSystem, ... }:

{
  flake.nixosModules.default = moduleWithSystem (
    { pkgs, ... }:
    { config, ... }:
    let
      cfg = config.oganesson.profiles.graphical;
    in
    {
      options.oganesson.profiles.graphical = {
        enable = lib.mkEnableOption "common configurations for graphical systems";
      };

      config = lib.mkIf cfg.enable {
        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        # fonts
        fonts = {
          enableDefaultPackages = true;
          packages = with pkgs; [
            nerd-fonts.iosevka
            noto-fonts
          ];
        };
      };
    }
  );
}
