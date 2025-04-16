{ config, pkgs, pkgs-unstable, ...}:

{
    environment.systemPackages = with pkgs; [
		ffmpeg-full

		pkgs-unstable.shotcut
		# davinci-resolve
		# openshot-qt
		pkgs-unstable.kdePackages.kdenlive

		tenacity

		handbrake
    ];
}
