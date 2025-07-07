# Altaria profile

This README is specific to stuff related to the `altaria` profile.

## Installation

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
curl -O https://raw.githubusercontent.com/Fran314/nixos/refs/heads/main/profiles/altaria/install
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
- enter your ssh public key through `nano` into `~/.ssh/authorized_keys` (once
  again being careful of characters swaps, such as `+` for `=` or `@` for `2`)

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

### Step 3: setup

Some services require manual setup after the install. See the
[services setup](#services-setup) chapter.

## Services Setup

### Domain

The VPS should have a static domain, so you might want to point your domain
(both `*` and `@` records) to the VPS ip address

### Navidrome

Navidrome requires you to create an admin account, which has to be done through
the webui from localhost. To access the webui as if it was from localhost, you
can create an ssh tunnel from your local machine to the VPS with

```bash
ssh -N -L 4533:localhost:4533 <VPS's ip or domain>
```

Now you can access `https://localhost:4533` and create the admin account.

If once you've created the admin account, the tracks don't show up, it is
possible that the scan for the tracks happened before the admin account
creation, which prevents the tracks from being detected for some reason. A
possible fix should be to re-`touch` all the track files (and playlists) so that
the next scan will recognise them as new and add them.
