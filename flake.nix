{
	description = "Flake of Fran314";

    outputs = inputs@{ self, ...}:
    let
        system = "x86_64-linux";
        lib = inputs.nixpkgs.lib;
        pkgs = import inputs.nixpkgs { inherit system; };
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
    in {
        nixosConfigurations = {
            latias = lib.nixosSystem {
                inherit system;
                modules = [ ./profiles/latias/configuration.nix ];
                specialArgs = {
                    # inherit pkgs-unstable;
                };
            };
            vm = lib.nixosSystem {
                inherit system;
                modules = [ ./profiles/vm/configuration.nix ];
                specialArgs = {
                    # inherit pkgs-unstable;
                };
            };
        };

        homeConfigurations = {
            latias = inputs.home-manager.lib.homeManagerConfiguration {
                inherit lib pkgs;
                modules = [ ./profiles/latias/home.nix ];
                extraSpecialArgs = {
                    inherit pkgs-unstable;
                };
            };
            vm = inputs.home-manager.lib.homeManagerConfiguration {
                inherit lib pkgs;
                modules = [ ./profiles/vm/home.nix ];
                extraSpecialArgs = {
                    inherit pkgs-unstable;
                };
            };
        };
    };

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
}
