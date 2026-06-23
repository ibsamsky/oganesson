# inspiration: github:getchoo/borealis
# TODO: script referencing this justfile in PATH or something

# invoke as `just nix=nom ...` to use nix-output-monitor, for example
nix := "nix"
rebuild := "nixos-rebuild"

hostname := shell("uname -n")

default:
    @just --choose

rebuild subcmd *args="":
    {{ rebuild }} {{ subcmd }} \
        --sudo \
        --flake "git+file://{{ justfile_directory() }}" \
        {{ args }}

# see https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html
# build a vm image for the current host, independent of nixos-rebuild (e.g. for use on another machine)
build-vm hostname=hostname:
    {{ nix }} build ".#nixosConfigurations.{{ hostname }}.config.system.build.vm"