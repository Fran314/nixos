{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.options.virtualization.virtualbox;
in
{
  options.my.options.virtualization.virtualbox = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    # virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "baldo" ];
  };
}
