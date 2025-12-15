{ config, pkgs, ... }:

{
  home-manager.users.baldo =
    { config, pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Fran314";
            email = "francesco.ghog@gmail.com";
          };
          init.defaultBranch = "main";
        };
      };
    };
}
