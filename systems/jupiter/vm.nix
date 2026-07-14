{
  virtualisation = {
    vmware.guest.enable = true;

    # `build-vm` options
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/qemu-vm.nix#L435
    vmVariant = {
      virtualisation = {
        memorySize = 3 * 1024;
        cores = 4;
      };
    };
  };
}
