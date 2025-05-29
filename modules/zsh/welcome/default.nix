{
  config,
  pkgs,
  lib,
  machine,
  my-utils,
  ...
}:

with lib;
{
  options.my.options.zsh.welcome = {
    enable = mkEnableOption "";
    variant = mkEnableOption "";
    textColor = mkOption {
      type =
        with types;
        submodule {
          options = {
            r = mkOption { type = ints.u8; };
            g = mkOption { type = ints.u8; };
            b = mkOption { type = ints.u8; };
          };
        };
      description = "Color for the hostname in the welcome message";
    };

  };

  config =
    let
      cfg = config.my.options.zsh.welcome;
    in
    mkIf cfg.enable (
      let
        r = builtins.toString cfg.textColor.r;
        g = builtins.toString cfg.textColor.g;
        b = builtins.toString cfg.textColor.b;
        color = "${r};${g};${b}";
        image = builtins.toString ./${machine.name};
        variant = builtins.toString (if cfg.variant then ./${machine.name}-variant else ./${machine.name});

      in
      {
        programs.zsh.interactiveShellInit = my-utils.readInterpolateWith {
          welcome-image = image;
          variant-image = variant;
          host-color = color;
        } ./display-welcome.sh;
      }
    );
}
