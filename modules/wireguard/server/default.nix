{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.my.options.wireguard.server;
in
{
  options.my.options.wireguard.server = {
    privateKeyFile = mkOption {
      type = types.str;
    };
    externalInterface = mkOption {
      type = types.str;
    };
    peers = mkOption {
      description = "Peers that can connect to the wireguard server";
      default = [ ];
      type = types.listOf (
        types.submodule {
          options = {
            publicKey = mkOption {
              type = types.str;
            };
            allowedIPs = mkOption {
              type = with types; listOf str;
            };
          };
        }
      );
    };
  };

  config = {
    # Enable NAT
    networking.nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = cfg.externalInterface;
      internalInterfaces = [ "wg0" ];
    };
    # Open ports in the firewall
    networking.firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [
        53
        51820
      ];
    };

    networking.wg-quick.interfaces = {
      wg0 = {
        # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
        address = [
          "10.0.0.1/24"
          "fdc9:281f:04d7:9ee9::1/64"
        ];
        # The port that WireGuard listens to - recommended that this be changed from default
        listenPort = 51820;
        # Path to the server's private key
        privateKeyFile = cfg.privateKeyFile;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        postUp = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o ${cfg.externalInterface} -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        # Undo the above
        preDown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o ${cfg.externalInterface} -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        peers = cfg.peers;
      };
    };
  };
}
