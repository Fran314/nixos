{
  lib,
  pkgs,
  inputs,
  machine,
  secrets,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    cifs-utils # needed for the storage box
  ];

  fileSystems."/mnt/storage-box" = {
    # This is necessary instead of simply using `secrets.samba.altaria."device"`
    # because that value has a new line and this breaks everything.
    # The `builtins.head` + `splitString` extracts the first line
    device = (builtins.head (lib.strings.splitString "\n" secrets.samba.altaria."device"));
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/secrets/samba/altaria/credentials,uid=1000,gid=100" ];
  };
  systemd.tmpfiles.rules = [
    "d /mnt/storage-box 0755 baldo users - -"
  ];
}
