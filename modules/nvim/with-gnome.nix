{ lib, config, pkgs, inputs, ...}:

lib.mkIf (config.my.options.wm.gnome.enable or false) {
    home-manager.users.baldo = { config, pkgs-nvim, ... }:
    {
        dconf.settings = {
            "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nvimMemo/"
                ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nvimMemo" = {
                binding = "<Super>F1";
                command = "alacritty --class 'nvim-memo' --working-directory '${config.xdg.userDirs.desktop}/.nvim-memo' -e nvim";
                name = "Launch Memo";
            };
        };
    };
}
