{
  description = "NixOS configuration of Fran314";

  outputs =
    inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      user = "baldo";
      machines = {
        latias = {
          primary-monitor-output = "eDP-1";
          secondary-monitor-output = "HDMI-1";
        };
        kyogre = {
          primary-monitor-output = "HDMI-1";
        };
        umbreon = { };
      };

      lib = inputs.nixpkgs.lib;
      # pkgs = import inputs.nixpkgs { inherit system; };
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };

      mkConfiguration =
        machine:
        let
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit machine;
            inherit user;
            my-utils = (import ./meta/utils.nix machine);
          };
        in
        lib.nixosSystem {
          inherit system;
          inherit specialArgs;
          modules = [
            # general default stuff
            {
              networking.hostName = machine.name;
            }

            # nixvim
            {
              environment.systemPackages = [ inputs.nixvim.packages.${system}.default ];
              environment.variables.EDITOR = "nvim";
            }

            # home manager
            inputs.home-manager.nixosModules.default
            {
              home-manager.extraSpecialArgs = specialArgs;
            }

            # configuration
            ./profiles/${machine.name}/configuration.nix
          ];
        };
      mkConfigurations =
        machines: builtins.mapAttrs (name: value: mkConfiguration (value // { inherit name; })) machines;
    in
    {
      nixosConfigurations = mkConfigurations machines;
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-data = {
      url = "git+ssh://git@github.com/Fran314/nixos-private.git?ref=main&shallow=1";
      flake = false;
    };

    nixvim.url = "github:Fran314/nixvim";
  };
}
