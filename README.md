# My NixOS configuration

This repo contains my multi-profile NixOS configuration.

This configuration is still a work in progress and I wouldn't consider it ready
for use, but it can be taken as an example on how to structure a NixOS
configuration.

## Usage

I'm not 100% sure that this is the correct way to install a NixOS configuration
from github, but it is what I am using. If you know of a better way (mainly, how
to handle the hardware-configuration and bootloader configurations) please let
me know.

### Installation

#### Install default NixOS image

First, install NixOS on the desired machine via a (installer
ISO)[https://nixos.org/download/#nixos-iso] (for your own sake, use the
Graphical ISO image, as this choice still allows you to use a
desktop-environment-less profile, and it's much easier to use).

For this installation, install with Swap (with Hibernate) and set Allow Unfree
Software to true.

(This installation might get stuck at 46%. It happens, and it takes A LOT to
finish. Just make the logs visible next to the progress bar to make sure that
something is actually happening)

#### Apply profile

With NixOS installed, you should have your own version of `configuration.nix`
and `hardware-configuration.nix` stored in `/etc/nixos`. These are created by
NixOS for you own hardware specifically, and will be used to fine tune the
profile of your choice from this configuration

Clone this repo to `~/.dotfiles` with

```bash
git clone git@github.com:Fran314/nixos.git ~/.dotfiles
```

Then, in the `~/.dotfiles/profiles` directory, copy the profile directory of
your choice, so to have a clone that you can edit to adapt to your hardware.

Add your version of `hardware-configuration.nix` (the one from `/etc/nixos`)
into your profile directory. Then, compare your version of `configuration.nix`
with the one from the cloned profile (and look at the imported modules too): it
is possible for some hardware configuration to end in this file (such as the
bootloader options), and they have to be adjusted for your hardware.

Finally, edit the `flake.nix` file in the repo to add your new profiles.

Then, update the system with

```bash
sudo nix flake update
sudo nix-build switch --flake ~/.dotfiles#YOUR_PROFILE_NAME
home-manager switch --flake ~/.dotfiles#YOUR_PROFILE_NAME
```

### Post-installation

Despite NixOS being an 100% declarative OS, a couple of finalization steps are
required. It's a bit of a bummer, but they're the last imperative configuration
you'll ever have to do.

These operation might be necessary:

-   change your user's password,
-   move the xdg-dirs (such as `~/Desktop` to `~/desktop`),
-   copy your secrets to this machine (such as SSH keys)

## Profiles

This configuration is structured around three profiles:

-   **latias**: this is the profile for my personal computer. It's supposed to
    be a full-featured environment intended for multiple possible uses, from
    simple daily browsing, to coding, 3D modeling and more,
-   **umbreon**: this is the profile for my homelab. It's supposed to be a
    CLI-only but comfortable environment, intended to be used for managing
    self-hosted applications via ssh,
-   **vm**: this is a testing profile intended to be used ONLY for developing
    this configuration. This profile should NOT be used on actual systems as it
    contains some possible security issues (eg sudo without password).
