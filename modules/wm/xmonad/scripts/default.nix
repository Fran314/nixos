{ lib, pkgs, config, machine, ... }:

with lib; let
	read = p: builtins.readFile p;
	readInterpolate = from: to: p:
		builtins.replaceStrings
			# Scripts that need variable interpolation must NOT be run before
			# interpolation as this would produce potentially harmful undefined
			# behaviour. To prevent this each script starts with a flag that
			# prevents the script to be ran if set to 1. This interpolation,
			# besides interpolating the correct values to the variables, also
			# sets this flag to 0
			(["STOP_EXECUTION_BEFORE_INTERPOLATION=1"] ++ from)
			(["STOP_EXECUTION_BEFORE_INTERPOLATION=0"] ++ to)
			(read p);
    
in mkIf config.my.options.wm.xmonad.enable {
    environment.systemPackages = mkMerge [
		[
			(pkgs.writeShellApplication {
				name = "duplicate-alacritty";
				runtimeInputs = with pkgs; [
					xdotool
					procps              # pgrep
				];
				text = read ./duplicate-alacritty;
			})
			(pkgs.writeShellApplication {
				name = "screenshot";
				runtimeInputs = with pkgs; [
					maim
					imagemagick         # convert
					xclip
					xdg-user-dirs
				];
				text = read ./screenshot;
			})
			(pkgs.writeShellApplication {
				name = "screencast";
				runtimeInputs = with pkgs; [
					xdg-user-dirs
					procps              # pkill
					xorg.xprop
					libnotify
					slop
					xorg.xwininfo
					# (ffmpeg.override { withXcb = true; })
					ffmpeg-full
					(pkgs.callPackage ./shadowbox {})
				];
				text = read ./screencast;
			})
			(pkgs.writeShellApplication {
				name = "smart-playerctl";
				runtimeInputs = with pkgs; [
					playerctl
				];
				text = read ./smart-playerctl;
			})
			(pkgs.writeShellApplication {
				name = "bluetooth-manager";
				runtimeInputs = with pkgs; [
					bluez-experimental      # bluetoothctl
				];
				text = read ./bluetooth-manager;
			})
			(pkgs.writeShellApplication {
				name = "lockscreen";
				runtimeInputs = with pkgs; [
					lightdm
				];
				text = ''dm-tool lock'';
			})
		]

		(mkIf (machine == "latias") [
			(pkgs.writeShellApplication {
				name = "set-brightness";
				runtimeInputs = with pkgs; [
					xorg.xrandr
				];
				text = readInterpolate
					["<<primary-output-name>>"]
					["eDP-1"]
					./set-brightness;
			})
			(pkgs.writeShellApplication {
				name = "monitor-manager";
				runtimeInputs = with pkgs; [
					xorg.xrandr
				];
				text = readInterpolate
						["<<primary-output-name>>" "<<secondary-output-name>>"]
						["eDP-1" "HDMI-1"]
						./monitor-manager;
			})
			(pkgs.writeShellApplication {
				name = "reconnect-wifi";
				runtimeInputs = with pkgs; [
					networkmanager
				];
				text = ''
					nmcli c up "$(nmcli -t -f device,active,uuid con | grep '^wlp4s0:yes' | cut -d: -f3)"
				'';
			})
		])
	];

    # home-manager.users.baldo = { config, pkgs, ... }:
    # {
    #     home.file = {
    #         ".config/slop" = {
    #             source = ./slop-config;
    #             recursive = true;
    #         };
    #     };
    # };
}
