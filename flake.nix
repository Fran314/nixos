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
          wifi-device = "wlp4s0";
        };
        kyogre = {
          primary-monitor-output = "HDMI-1";
          wifi-device = "wlp35s0";
          ethernet-device = "enp33s0";
        };
        umbreon = {
          external-interface = "eno1";
        };
        altaria = {
          external-interface = "enp1s0";
        };
      };

      lib = inputs.nixpkgs.lib;
      # pkgs = import inputs.nixpkgs { inherit system; };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkConfiguration =
        machine:
        let
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit machine;
            inherit user;
            my-utils = (import ./meta/utils.nix machine);
            secrets = (import ./meta/secrets/${machine.name}.nix);
            private-data = builtins.fetchGit {
              url = "ssh://git@github.com/Fran314/nixos-private.git";
              ref = "main";
              rev = "5dd093c1ec0f46a8dab15d7aeec533fe5185136b";
            };
          };
        in
        lib.nixosSystem {
          inherit system;
          inherit specialArgs;
          modules = [
            ./profiles/${machine.name}/configuration.nix

            # home manager
            inputs.home-manager.nixosModules.default
            {
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      mkConfigurations =
        machines: builtins.mapAttrs (name: value: mkConfiguration (value // { inherit name; })) machines;
    in
    {
      nixosConfigurations = (mkConfigurations machines);
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:Fran314/nixvim";
  };
}
