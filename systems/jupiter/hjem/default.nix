{ ... }:

{
  hjem.users.cark = {
    user = "cark";
    directory = "/home/cark";

    xdg.config.files = {
      "niri/config.kdl".source = ./files/niri.kdl;
      "waybar/config".source = ./files/waybar-config.jsonc;
      "waybar/style.css".source = ./files/waybar-style.css;
    };

    files = {
      ".bashrc".text = /* bash */ ''
        # If not running interactively, don't do anything
        [[ $- != *i* ]] && return

        export HISTCONTROL=ignoreboth:erasedups
        export HISTFILESIZE=100000
        export HISTSIZE=100000
        shopt -s histappend

        eval "$(zoxide init bash)"
        eval "$(direnv hook bash)"
      '';
    };
  };
}
