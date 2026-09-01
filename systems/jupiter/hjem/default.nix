{ ... }:

{
  hjem.users.cark = {
    user = "cark";
    directory = "/home/cark";

    xdg.config.files = {
      "niri/config.kdl".source = ./files/niri.kdl;
    };

    files = {
      ".bashrc".text = /* bash */ ''
        # If not running interactively, don't do anything
        [[ $- != *i* ]] && return

        export HISTCONTROL=ignoreboth:erasedups
        export HISTFILESIZE=100000
        export HISTSIZE=100000

        eval "$(zoxide init bash)"
        eval "$(direnv hook bash)"
      '';

      ".gitconfig".source = ./files/gitconfig;
    };
  };
}
