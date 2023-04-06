{
  inputs,
  modulesPath,
  ...
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ]
    ++ (with inputs.self.nixosModules.hardware; [
      physical
      sdboot
      cpu.intel
    ]);

  # Storage
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-cache"
    "dm-mirror"
  ];
  services.lvm.boot.thin.enable = true;
}
