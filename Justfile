# inspiration: github:getchoo/borealis
# TODO: script referencing this justfile in PATH or something

rebuild := "nixos-rebuild"

default:
    @just --choose

rebuild subcmd *args="":
    {{ rebuild }} {{ subcmd }} \
        --sudo \
        --flake "git+file://{{ justfile_directory() }}" \
        {{ args }}