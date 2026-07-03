# neon

> Oracle Cloud Ampere A1 instance (aarch64)

## Testing

Use `--vm-test` to build a VM and test the config:

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#neon-install --vm-test
```

Supposedly, using `--system aarch64-linux` on a non-aarch64 host should
work, but binfmt_misc is ass (just run it on the same ISA).

## Installation

```bash
nix run github:nix-community/nixos-anywhere -- \
    --flake .#neon-install \
    --target-host root@<HOST>
```

After installing, switch to config from main flake.

## Reference

* [NixOS Wiki article](https://wiki.nixos.org/wiki/Install_NixOS_on_Oracle_Cloud)
* [nixos-anywhere book](https://nix-community.github.io/nixos-anywhere/)
