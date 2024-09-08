{ lib, config, pkgs, inputs, ...}:

{
    dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nvimMemo/"
            ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nvimMemo" = {
            binding = "<Super>F1";
            # Use custom defined command SessionsLoadCwd (see remaps.lua)
            command = "alacritty --class 'nvim-memo' --working-directory '${config.xdg.userDirs.desktop}/.nvim-memo' -e nvim -c 'SessionsLoadCwd'";
            name = "Launch Memo";
        };
    };
}
