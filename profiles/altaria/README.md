# Altaria profile

This README is specific to the `altaria` profile.

## Installation

> [!CAUTION]  
> This installation assumes that you have access to your secrets-flash-drive.
> This installation will fail if it doesn't find the secrets in the correct
> places, so make sure you have your flash drive and make sure to install the
> secrets (see below for how to install the secrets)

The following installation process is a readaptation of these two guides
([\[1\]](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud#Traditional_ISO_installation),
[\[2\]](https://nixos.org/manual/nixos/stable/#sec-installation-manual)) adapted
to my specific configuration. It will be assumed that you already own an Hetzner
VPS (with any distro installed, it doesn't matter).

For this installation you will need:

- an Hetzner server (`server`)
- your laptop (`local`)
- the secrets-flash-drive

### Step 1: Bootstrap throug Hetzner Console

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

Open the Hetzner Console, which should boot into the ISO. Once in, download the
following script:

```bash
curl -O https://raw.githubusercontent.com/Fran314/nixos/refs/heads/main/profiles/altaria/bootstrap/install
```

Note that when you paste this in the Hetzner Console (you can do it by
right-clicking), some characters might be swapped for others, in particular `:`
will become `;` (you can type `:` by pressing `ç`).

**INSPECT THE SCRIPT** and make sure to understand it, then run

```bash
sudo bash install
```

In this order, you will be asked to:

- press `y` twice for creating the ext4 filesystems
- create (and confirm) a password for the account `baldo`

Once you have done this, the system should shut off automatically. You can now
close the console forever, unmount the ISO and power on again the VPS.

You should now be able to connect through ssh to the account `baldo` with the
password you just set. Note that when the system will be fully installed,
password authentication for SSH will be disabled.

### Step 2: install the secrets

The actual `altaria` profile requires secrets to be succesfully installed.

Install the secrets on the machine as described in
[this section](#importing-the-secrets)

### Step 2: through SSH

Confirm that you succesfully logged in.

Clone the repository on the VPS with

```bash
git clone https://github.com/Fran314/nixos.git ~/.dotfiles/nixos
```

(Note that the link is an `https://` and not a `git@` because the VPS doesn't
have, and shouldn't have, credentials)

### Step 3: setup

Some services require manual setup after the install. See the
[services setup](#services-setup) chapter.

## Secrets management

### Importing the secrets

Open a root shell on the server and on the local machine

#### Import the secrets to the local machine

Run the following commands on the local machine, as root:

```bash
# on local machine, as root
TEMPD=$(mktemp -d)
cd /path/to/export/mountpoint
./secrets-manager import . --target "$TEMPD" --profile altaria
```

#### Move the imported secrets to the server

Run the following commands, as root, on the specified machines, in the given
order.

```bash
# on server, as root
mkdir /secrets
chown -R baldo:users /secrets
```

```bash
# on local machine, as root
rsync -r "$TEMPD/" baldo@XX.YY.ZZ.WW:/secrets/
rm -r "$TEMPD"
```

```bash
# on server, as root
chown -R root:root /secrets
```

### Exporting the secrets

Open a root shell on the server and on the local machine

#### Move the secrets to the local machine

Run the following commands, as root, on the specified machines, in the given
order.

```bash
# on server, as root
chown -R baldo:users /secrets
```

```bash
# on local machine, as root
TEMPD=$(mktemp -d)
rsync -r baldo@XX.YY.ZZ.WW:/secrets/ "$TEMPD/"
```

```bash
# on server, as root
chown -R root:root /secrets
```

#### Export from the local machine

Run the following commands on the local machine, as root:

```bash
# on local machine, as root
cd /path/to/export/mountpoint
secrets-manager export . --source "$TEMPD" --profile altaria
rm -r "$TEMPD"
```

## Services Setup

### Domain

The VPS should have a static domain, so you might want to point your domain
(both `*` and `@` records) to the VPS ip address

### Navidrome

Navidrome requires you to create an admin account, which has to be done through
the webui from localhost. To access the webui as if it was from localhost, you
can create an ssh tunnel from your local machine to the VPS with

```bash
ssh -N -L 4533:localhost:4533 XX.YY.ZZ.WW
```

Now you can access `https://localhost:4533` and create the admin account.

If once you've created the admin account, the tracks don't show up, it is
possible that the scan for the tracks happened before the admin account
creation, which prevents the tracks from being detected for some reason. A
possible fix should be to re-`touch` all the track files (and playlists) so that
the next scan will recognise them as new and add them.
