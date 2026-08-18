# argon

> Proxmox LXC

media server/selfhost stuff

## Installation

Bootstrap by grabbing a proxmox LXC template from [hydra][h] ([latest download link][l] or use
"_Reproduce locally_" on chosen build) and upload it using the web UI.

[h]: https://hydra.nixos.org/job/nixos/release-26.05/nixos.proxmoxLXC.x86_64-linux
[l]: https://hydra.nixos.org/job/nixos/release-26.05/nixos.proxmoxLXC.x86_64-linux/latest/download/1

Install normally from the web UI (you may want to set a static IP). The password you set here won't
get applied -- you have to set it manually from the host:

```sh
$ pct enter <CTID>
$ source /etc/set-environment
$ passwd
New password:
Retype new password:
passwd: password updated successfully
```

Afterwards, you should be able to use the CT console with the password you set, but not SSH.
By default, sshd disallows password login for root, so add a public key to
`/root/.ssh/authorized_keys` and make sure you can connect. Then proceed with configuration.

## Host Configuration

Most guides make a point to set up user/group ID (re)mapping inside the container, but with recent
versions of Proxmox this doesn't seem to be necessary. Setting up GPU passthrough devices with a GID
matching the guest `render`/`video` groups was sufficient to show up in `vainfo` and `clinfo`.

`/etc/pve/lxc/<CTID>.conf`:

```text
arch: amd64
cores: 5
dev0: /dev/dri/renderD128,gid=303
dev1: /dev/dri/card0,gid=26
dev2: /dev/net/tun
features: nesting=1
hostname: argon
memory: 4096
mp0: /mnt/data/argon-media,mp=/mnt/media
net0: name=eth0,bridge=vmbr0,firewall=1,gw=10.0.0.1,hwaddr=<MAC>,ip=10.100.0.1/8,ip6=dhcp,type=veth
onboot: 1
ostype: nixos
rootfs: local-lvm:vm-100-disk-0,size=64G
swap: 2048
unprivileged: 1
```

## Discussion/Caveats

Our security posture is somewhat weakened by including every service in one container, in that it
makes lateral movement[^1] easier compared to, say, individual Docker containers. I have convinced
myself that this doesn't really matter for a number of reasons:

- NixOS is fairly hardened by default, using systemd security options and dedicated service
  accounts.
- Services are behind a reverse proxy or VPN, as well as a firewall with sane configuration.
  Barring phishing, attackers would need a serious vulnerability like web-app RCE or sophisticated
  XSS (not unheard of, but quite rare).
- The system configuration can be restored easily.
- Using an unprivileged container makes it harder to compromise the host.
- On mounted directories, major data loss is prevented with daily backups.
- My threat model is very basic. :)

I'm not familiar enough with Nix(OS) to effectively split each service into its own container, so
this is a reasonable compromise for me.

[^1]: the process of pivoting to other services or programs from an initial entrypoint
