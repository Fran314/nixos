{ lib, config, ...}:

lib.mkIf config.my.options.xdg.symlink-data {
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        # For reasons unclear to me, home manager will create these files only if
        # the content of these rules change, and not whenever they are missing.
        # To force the creation of these files (via command line) you can run
        # the following command `systemd-tmpfiles --user --create`
        systemd.user.tmpfiles.rules = [
            "d ${config.home.homeDirectory}/archivio     - - - - -"
            "d ${config.home.homeDirectory}/desktop      - - - - -"
            "d ${config.home.homeDirectory}/documents    - - - - -"
            "d ${config.home.homeDirectory}/downloads    - - - - -"
            "d ${config.home.homeDirectory}/music        - - - - -"
            "d ${config.home.homeDirectory}/pictures     - - - - -"
            "d ${config.home.homeDirectory}/public       - - - - -"
            "d ${config.home.homeDirectory}/templates    - - - - -"
            "d ${config.home.homeDirectory}/universita   - - - - -"
            "d ${config.home.homeDirectory}/videos       - - - - -"
        ];
    };
}
