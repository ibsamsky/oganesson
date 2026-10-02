{ pkgs, ... }: {
  # `build-vm` options
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/virtualisation/qemu-vm.nix#L435
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 3 * 1024;
      cores = 8;

      qemu = {
        forceAccel = true;

        package = pkgs.qemu;

        # fix niri EGL rendering
        options = [
          "-vga none"
          "-device virtio-vga-gl,hostmem=4G"
          "-display gtk,gl=on"
        ];
      };
    };
  };
}
