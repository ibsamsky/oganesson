# argon

> Proxmox LXC

media server/selfhost stuff

## Installation

Bootstrap by grabbing a proxmox LXC template from [hydra][h] ([latest download link][l] or use
"_Reproduce locally_" on chosen build) and upload it using the web UI.

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

[h]: https://hydra.nixos.org/job/nixos/release-26.05/nixos.proxmoxLXC.x86_64-linux
[l]: https://hydra.nixos.org/job/nixos/release-26.05/nixos.proxmoxLXC.x86_64-linux/latest/download/1