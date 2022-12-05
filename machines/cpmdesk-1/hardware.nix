{ inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ] ++ (with inputs.self.nixosModules.hardware; [
    physical
    sdboot
    cpu.intel
    gpu.intel
  ]);

  # Storage
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  boot.loader.systemd-boot.consoleMode = "max";
  hardware.video.hidpi.enable = true;
}
