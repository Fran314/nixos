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

## Installation

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

To quickly import the secrets in all the correct places, use the script
`import-secrets`. This script should be present in the flash drive, but it can
be found (along with other scripts) in this repository inside the folder
`secrets-management`.

The script has some dependencies. To temporarily install them, run:

```bash
nix-shell -p coreutils gnupg
```

Then use the script as follows

```bash
sudo bash import-secrets YOUR_PROFILE_NAME /mountpoint/of/the/flash/drive
```

You will be prompted to insert the decryption passphrase, and then it should
correctly import all the secrets related to the profile you specified. You may
now exit the shell created to install the dependencies.

<details>
<summary>Here is a more detailed explanation of secrets and how they work (for example, if you want to manually import them instead of using the script)</summary>
TODO
</details>

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
