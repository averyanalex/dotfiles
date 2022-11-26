{ inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ] ++ (with inputs.self.nixosModules.hardware; [
    physical
    sdboot
    cpu.amd
    gpu.amd
  ]);

  # Storage
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # Screen
  boot.kernelParams = [
    "video=DP-1:3440x1440@144"
  ];
  home-manager.users.alex = {
    wayland.windowManager.sway.config.output.DP-1 = {
      mode = "3440x1440@144Hz";
      adaptive_sync = "off";
    };
  };
  boot.loader.systemd-boot.consoleMode = "max";
  hardware.video.hidpi.enable = true;
}
