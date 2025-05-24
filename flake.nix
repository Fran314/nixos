{
	description = "Flake of Fran314";

    outputs = inputs@{ self, ... }:
    let
        system = "x86_64-linux";
		user = "baldo";
		machines = [ "latias" "kyogre" "umbreon" ];

        lib = inputs.nixpkgs.lib;
        pkgs = import inputs.nixpkgs { inherit system; };
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
        pkgs-nvim = import inputs.nvim { inherit system; };
        pkgs-gnome = import inputs.gnome { inherit system; };

		mkConfiguration = name: lib.nixosSystem {
                inherit system;
                modules = [
                    ./profiles/${name}/configuration.nix

					{ networking.hostName = name; }

                    inputs.home-manager.nixosModules.default {
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            inherit pkgs-unstable;
                            inherit pkgs-nvim;
                            inherit pkgs-gnome;
							machine = name;
							inherit user;
                        };
                    }
                ];
                specialArgs = {
					inherit inputs;
                    inherit pkgs-unstable;
                    inherit pkgs-nvim;
                    inherit pkgs-gnome;
					machine = name;
					inherit user;
                };
            };
    in {
		nixosConfigurations = builtins.listToAttrs (
				builtins.map
					(name: { name = name; value = mkConfiguration name; })
					machines
			);
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

        # Separated for granular updates
		nvim.url = "nixpkgs/nixos-24.11";
		gnome.url = "nixpkgs/nixos-24.11";
	};
}
