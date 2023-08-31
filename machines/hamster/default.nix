{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.desktop

    inputs.self.nixosModules.profiles.bluetooth
    inputs.self.nixosModules.profiles.netman
    # inputs.self.nixosModules.profiles.remote-builder-client

    inputs.self.nixosModules.hardware.thinkbook

    ./mounts.nix
  ];

  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 1;
      # START_CHARGE_THRESH_BAT0 = 50;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitch=suspend-then-hibernate
    HandleLidSwitchExternalPower=ignore
  '';
  # TODO: setup suspend-then-hibernate after systemd regression will be fixed
  # HandleLidSwitch=suspend-then-hibernate

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendEstimationSec=15m
  '';

  # boot.initrd.systemd.enable = true;

  system.stateVersion = "22.05";

  services.klipper = {
    enable = true;
    configFile = ./4max.cfg;
    firmwares = {
      mcu = {
        enable = true;
        enableKlipperFlash = true;
        configFile = ./mcu.cfg;
        serial = "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0";
      };
    };
  };

  services.moonraker = {
    user = "root";
    enable = true;
    address = "0.0.0.0";
    settings = {
      octoprint_compat = {};
      history = {};
      authorization = {
        force_logins = true;
        cors_domains = ["localhost" "*.local" "*.lan" "*://app.fluidd.xyz" "*://my.mainsail.xyz"];
        trusted_clients = ["10.0.0.0/8" "127.0.0.0/8" "169.254.0.0/16" "172.16.0.0/12" "192.168.1.0/24" "FE80::/10" "::1/128"];
      };
    };
  };
  services.mainsail.enable = true;
}
