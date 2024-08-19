{
	description = "my first flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
		
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ...}:
	let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; };
	in {
		nixosConfigurations = {
			latias = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./configuration.nix ];
			};
		};

		homeConfigurations = {
			baldo = home-manager.lib.homeManagerConfiguration {
				inherit lib pkgs;
				modules = [ ./home.nix ];
			};
		};
	};
}
