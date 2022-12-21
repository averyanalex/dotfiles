{ inputs, config, pkgs, ... }:
let
  firesquare-module = inputs.firesquare-servers.nixosModules.default;
in
{
  age.secrets.wg-key-firesquare.file = ../../secrets/wireguard/firesquare.age;
  networking.wireguard.interfaces = {
    wg-firesquare = {
      allowedIPsAsRoutes = false;
      privateKeyFile = config.age.secrets.wg-key-firesquare.path;
      peers = [
        {
          publicKey = "h+76esMcmPLakUN/1vDlvGGf2Ovmw/IDKKxFtqXCdm8=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "hawk.averyan.ru:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services."container@firesquare" = {
    wants = [ "wireguard-wg-firesquare.target" ];
    after = [ "wireguard-wg-firesquare.target" ];
  };

  containers.firesquare = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    interfaces = [ "wg-firesquare" ];

    config = {
      imports = [ firesquare-module ];
      system.stateVersion = "22.11";

      networking = {
        interfaces.wg-firesquare.ipv4.addresses = [{
          address = "10.8.7.81";
          prefixLength = 32;
        }];
        defaultGateway = {
          address = "10.8.7.1";
          interface = "wg-firesquare";
        };
        firewall.enable = false;
      };
    };
  };
}
