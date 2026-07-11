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
there are a couple of ways to have the same thing without flakes (npins, tack,
`fetchTarball` if you feel like it, etc.) but they don't really achieve the
same UX that flakes have.

### rough edges

by far the worst part of trying to get started with this whole thing was the
documentation. for some reason, search engines boost random wiki articles and
forum threads that are many years out of date. the official manual is massive
and, infamously, not super noob-friendly. all told, there are at least 4(!)
separate official documentation venues.

i found that the most helpful thing to do was to jump into the REPL or an editor
and just start trying shit. it helped me get comfortable with the language very
quickly compared to reading alone.

i will give credit where credit is due: once you have the Nix language basics
down, it's great to be able to go into the source of every package and option
and see plainly what they do. it's also nice to have a big ass manual that tells
you everything (almost everything?) that can be configured. in particular, this
revealed many options belonging to Linux and common userland programs that i
otherwise had no knowledge of. i don't know of any traditional distro that has
something equivalent.

### further reading

* [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/introduction/) -
  nice, fairly "gentle" introduction to NixOS, especially compared to the
  manual, and up to date too. walks through configuring a system and also covers
  some other important topics (e.g., the NixOS module system)
* <https://jade.fyi/blog/flakes-arent-real/>
* <https://edolstra.github.io/pubs/phd-thesis.pdf> :)
