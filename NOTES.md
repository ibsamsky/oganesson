# <!-- meow -->

"design" decisions i am making:

1. avoid home-manager wherever possible, mostly for the reasons outlined in
   [nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/)
2. this is a single-user system, so programs without meaningful /home
   configuration should only be installed system-wide (if at all). should work
   well with (1)
3. not everything has to be done in nix or declaratively, but it should be
   _very_ easy to create a nearly identical system from git alone
4. coherent config "sections" should be separated and composable (i.e.,
   nixos/wlib/flake-parts modules) to make multi-machine setups easier

## other thoughts

### why NixOS?

for me, the most convincing reason to use NixOS is the centralization of all
system configuration, especially stuff under /etc. most solutions to having
portable dotfiles include making a "symlink farm",[^1] modulo some features like
templates, secrets, some other shit idk. [GNU Stow][gs], [chezmoi][cm], and
[yolk][yk] are in this category, among many others. for a while i used
[dotbare][db], which allows you to create a bare git repo in `~/` and avoid
linking (yay!) but is otherwise kinda barebones.

[^1]:
    this involves putting all of your configs in a specific folder and linking
    them to the correct locations, something that was scary to me when i was
    setting up my system with almost no linux knowledge.

[gs]: https://www.gnu.org/software/stow/
[cm]: https://www.chezmoi.io/
[yk]: https://github.com/elkowar/yolk
[db]: https://github.com/kazhala/dotbare

these dotfile managers can be enough, but (imo) it's still a lot of extra
thought to put into making sure that your system is accurately captured in its
entirety. there are surely some things that i forgot to include in my dotfiles
that would break my system if they went missing. this is less of an issue on
mainstream distros, but that's besides the point.

### to flake or not to flake

as i understand it, the main feature of flakes is that they can version their
inputs by pinning them to a specific git hash. this seems like an obviously
good idea coming from Rust and other programming languages with lockfiles,
since it allows _true_ reproducibility and avoids the issue of software rot.
there are a couple of ways to have the same thing without flakes (niv, tack,
`fetchTarball` if you feel like it, etc.) but they don't really achieve the
same UX that flakes have.
