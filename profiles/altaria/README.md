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

### Step 1: mount the ISO

Mount the NixOS minimal ISO onto the VPS (you can find it already available in
the ISO Images section). Power off and on the VPS.

Open the Hetzner Console, which should boot you into the the NixOS ISO as the
`nixos` user.

The Hetzner Console is terrible, so you would like to access the VPS via SSH. To
do so, create a password for the `root` user with the following command. It is
strongly recommended to use only alphanumeric characters because the Hetzner
Console has issue with non alphanumeric characters. This password is only
temporary and will be used only for installing the system. The `root` account in
the resulting system will not have this password.

```bash
sudo passwd
```

You may now close the Hetzner Console forever.

You should now be able to connect via SSH to `root` with password
authentication. The rest of the installation process will be done via SSH.

### Step 2: create partitions

Run the following commands to create the partitions for boot, SWAP and the root
partition.

```bash
# to create a partition table
parted /dev/sda --script mklabel msdos

# to create a boot partition
parted /dev/sda --script mkpart primary ext4 1MiB 513MiB
parted /dev/sda --script set 1 boot on
mkfs.ext4 -L boot /dev/sda1

# to create a swap partition of 8GB
parted /dev/sda --script mkpart primary linux-swap 513MiB 8577MiB
mkswap -L swap /dev/sda2
swapon /dev/sda2

# to create the root partition
parted /dev/sda --script mkpart primary ext4 8577MiB 100%
mkfs.ext4 -L nixos /dev/sda3

mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### Step 3: import secrets

Import the secrets to `/mnt/secrets`. To do so, execute the following commands
as `root` from a local machine with access to the secrets-flash-drive

```bash
TEMPD=$(mktemp -d)
cd /path/to/export/mountpoint
./secrets-manager import . --target "$TEMPD" --profile altaria
rsync -r "$TEMPD/" root@XX.YY.ZZ.WW:/mnt/secrets/
rsync -r "$TEMPD/" root@XX.YY.ZZ.WW:/secrets/
rm -r "$TEMPD"
```

where `XX.YY.ZZ.WW` is the IP address of the VPS.

### Step 4: install the configuration

Install the configuration with

```bash
nixos-install --no-root-passwd --flake github:Fran314/nixos#altaria
```

Then set the password for the `baldo` account with

```bash
nixos-enter --root /mnt -c 'passwd baldo'
```

You can now turn off the VPS, unmount the ISO and turn on again the VPS.

### Step 5: finalization

You should be able to access the VPS via SSH on `baldo` with public key
authentication, without password.

Confirm this, and once in clone locally the configuration repo with

```bash
git clone https://github.com/Fran314/nixos.git ~/.dotfiles/nixos
```

(Note that the link is an `https://` and not a `git@` because the VPS doesn't
have, and shouldn't have, credentials)

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
