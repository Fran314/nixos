{
	description = "Flake of Fran314";

    outputs = inputs@{ self, ... }:
    let
        system = "x86_64-linux";
        lib = inputs.nixpkgs.lib;
        pkgs = import inputs.nixpkgs { inherit system; };
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
        pkgs-nvim = import inputs.nvim { inherit system; };
        pkgs-gnome = import inputs.gnome { inherit system; };
    in {
        nixosConfigurations = {
            latias = lib.nixosSystem {
                inherit system;
                modules = [
                    ./profiles/latias/configuration.nix
                    inputs.home-manager.nixosModules.default {
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            inherit pkgs-unstable;
                            inherit pkgs-nvim;
                            inherit pkgs-gnome;
                        };
                    }
                ];
                specialArgs = {
                    inherit pkgs-unstable;
                    inherit pkgs-nvim;
                    inherit pkgs-gnome;
                };
            };
			umbreon = lib.nixosSystem {
                inherit system;
                modules = [
                    ./profiles/umbreon/configuration.nix
                    inputs.home-manager.nixosModules.default {
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            inherit pkgs-unstable;
                            inherit pkgs-nvim;
                        };
                    }
                ];
                specialArgs = {
                    inherit pkgs-unstable;
                    inherit pkgs-nvim;
                };
            };
        };
    };

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

        # Separated for granular updates
		nvim.url = "nixpkgs/nixos-24.11";
		gnome.url = "nixpkgs/nixos-24.11";
	};
}
