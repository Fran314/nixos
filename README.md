![Showcase of the desktop environment of latias](showcase/img.png)

# Fran314's NixOS configuration

This repo contains my multi-profile NixOS configuration.

> [!NOTE]  
> This is not meant to be a general purpose configuration. You're free to take
> inspiration from it and use it as you like, but don't expect it to work on
> your machine out of the box without some serious tweaking

## Profiles

This configuration is structured around three profiles:

- **latias**: this is the profile for my laptop. It's supposed to be a
  full-featured environment intended for multiple possible uses, from simple
  daily browsing, to coding, 3D modeling and more,
- **kyogre**: this is the profile for my desktop. Its main use is gaming with
  games that wouldn't run on the laptop. It inherits much of its configuration
  from _latias_, mainly for convenience of having the same setup
- **umbreon**: this is the profile for my homelab. It's supposed to be a
  CLI-only but comfortable environment, intended to be used for managing
  self-hosted applications via ssh.
- **altaria**: this is the profile for an Hetzner VPS. It's meant to be as
  lightweight as possible (given the 40GB disk limit), and has no access to any
  secret since it's considered untrusted. Its installation differs from the
  other profiles.

## Installation (latias/kyogre/umbreon)

> [!CAUTION]  
> This installation assumes that you have access to your secrets-flash-drive.
> This installation will fail if it doesn't find the secrets in the correct
> places, so make sure you have your flash drive and make sure to install the
> secrets (see below for how to install the secrets)

### Install default NixOS image

First, install NixOS on the desired machine via a
[installer ISO](https://nixos.org/download/#nixos-iso) (use the graphical
installation, even if you want to install to a desktop-environment-less
configuration. The profile installation will make it desktop-environment-less,
but while setting things up it is much more convenient to be able to easily
access a browser).

For this installation, install with Swap (with Hibernate) and set Allow Unfree
Software to true.

(This installation might get stuck at 46%. It happens, and it takes A LOT to
finish. Just make the logs visible next to the progress bar to make sure that
something is actually happening)

### Install the secrets

Assuming that you have access to secrets-flash-drive, you should be able to
import the secrets using the executable bundled with the secret's export, as

```bash
cd /path/to/usb/mountpoint
sudo ./secrets-manager import .
```

If for some reason the executable is not bundled together with the secrets, you
can find it at the
[secrets manager repository](https://github.com/Fran314/secrets-manager-rs),
which you can either manually compile or run with (though you need experimental
features to use `nix run` so if this is a fresh install, it probably is a bit
pointless)

```bash
sudo nix run github:Fran314/secrets-manager-rs -- import /path/to/usb/mountpoint
```

Alternatively, `secrets-manager` is meant to be interoperable, as in you are
able to import its exports without using `secrets-manager`. See
[secrets manager's Interoperability section](https://github.com/Fran314/secrets-manager-rs?tab=readme-ov-file#interoperability)
to see how to manually import the secrets without `secrets-manager`, using only
coreutils and [age](https://github.com/FiloSottile/age)

### Install configuration

Start a shell with `git` and `neovim` using

```bash
nix-shell -p git neovim
```

Using this shell, clone this repo to `~/.dotfiles/nixos` with

```bash
mkdir -p ~/.dotfiles/nixos
git clone git@github.com:Fran314/nixos.git ~/.dotfiles/nixos
```

<details>
<summary>Additionally, you might want to clone repos related to this configuration:</summary>

```bash
# repo for the custom nvim flake
mkdir -p ~/.dotfiles/nixvim
git clone git@github.com:Fran314/nixvim.git ~/.dotfiles/nixvim

# repo for the private (but not top-secret) data
mkdir -p ~/.dotfiles/nixos-private
git clone git@github.com:Fran314/nixos-private.git ~/.dotfiles/nixos-private
```

Note that these repos are not needed to fully install the configuration, you
only need to install them locally if you intend to edit them.

</details>

Then, build the system with

```bash
sudo nixos-rebuild boot --flake ~/.dotfiles/nixos#YOUR_PROFILE_NAME
```

The changes will be available on reboot

### Post-installation

Despite NixOS being an 100% declarative OS, a couple of finalization steps are
required. It's a bit of a bummer, but they're the last imperative configuration
you'll ever have to do.

If you're running the **latias** or **kyogre** profile you might want to

- remove the unused version of the xdg-dirs (see `remove-old-xdg.sh`),
- (if you're using GNOME) add the nvim-memo window to the floating exceptions
  for pop-shell

## Installation (altaria)

The installation for **altaria** differs from the other profiles since it has to
be done through the Hetzner console.

The following installation process is a readaptation of these two guides
([\[1\]](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud#Traditional_ISO_installation),
[\[2\]](https://nixos.org/manual/nixos/stable/#sec-installation-manual)) adapted
to my specific configuration. It will be assumed that you already own an Hetzner
VPS (with any distro installed, it doesn't matter).

### Step 1: Hetzner Console

> [!CAUTION]  
> The first step is to download and run a script from this repository. You
> should NEVER blindly download and run a script from the internet, so take your
> time to inspect it and make sure that you understand every command.
>
> The reason behind this step is that it is incredibly tedious to do the steps
> done by the script manually, as the Hetzner console is incredibly slow and
> doesn't map correctly with the italian keyboard.

Mount the NixOS minimal ISO onto the VPS (you can find it already available in
the ISO Images section). Power off and on the VPS.

Open the Hetzner Console, you should boot into the ISO. Once in, download the
following script:

```bash
curl -O https://raw.githubusercontent.com/Fran314/nixos/refs/heads/main/altaria-install
```

Note that when you paste this in the Hetzner Console (you can do it by
right-clicking), some characters might be swapped for others, in particular `:`
will become `;` (you can type `:` by pressing `ç`).

**INSPECT THE SCRIPT** and make sure to understand it, then run

```bash
sudo bash altaria-install
```

In this order, you will be asked to:

- press `y` twice for creating the ext4 filesystems
- create (and confirm) a password for the account `baldo`
- enter your ssh public key through `nano` into `~/.ssh/authorized_keys`

Once you have done this, the system should shut off automatically. You can now
close the console forever, unmount the ISO and power on again the VPS. You
should now be able to connect through ssh.

### Step 2: through SSH

Confirm that you succesfully logged in.

Clone the repository on the VPS with

```bash
git clone https://github.com/Fran314/nixos.git .dotfiles/nixos
```

(Note that the link is an `https://` and not a `git@` because the VPS doesn't
have, and shouldn't have, credentials)
