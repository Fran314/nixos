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
            command = "alacritty --working-directory '${config.xdg.userDirs.desktop}/.nvim-memo' -e nvim -c 'SessionsLoadCwd'";
            name = "Launch Memo";
        };
    };

    home.activation = {
        ensureNvimMemo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p ${config.xdg.userDirs.desktop}/.nvim-memo
        '';
    };
}
