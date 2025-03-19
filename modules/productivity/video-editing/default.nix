{ config, pkgs, pkgs-unstable, ...}:

{
    environment.systemPackages = with pkgs; [
		pkgs-unstable.shotcut
		# davinci-resolve
		# openshot-qt
		# kdenlive

		handbrake
    ];
}
