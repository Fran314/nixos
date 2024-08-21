{
	description = "my first flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		# nixpkgs.url = "nixpkgs/nixos-unstable";
		# home-manager = {
		# 	url = "github:nix-community/home-manager";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ...}:
	let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; };
		pkgs-unstable = import nixpkgs-unstable { inherit system; };
	in {
		nixosConfigurations = {
			latias = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./configuration.nix ];
                specialArgs = {
                    inherit pkgs-unstable;
                };
			};
		};

		homeConfigurations = {
			baldo = home-manager.lib.homeManagerConfiguration {
				inherit lib pkgs;
				# modules = [ ./home.nix ];
				modules = [ ./profiles/vm/home.nix ];
                extraSpecialArgs = {
                    inherit pkgs-unstable;
                };
			};
		};
	};
}
