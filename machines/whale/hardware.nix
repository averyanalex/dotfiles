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
    "dm-cache-default"
    "dm-cache-smq"
    "dm-cache-mq"
    "dm-cache-cleaner"
    "dm-mirror"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "dm-cache"
    "dm-cache-smq"
    "dm-persistent-data"
    "dm-bio-prison"
    "dm-clone"
    "dm-crypt"
    "dm-writecache"
    "dm-mirror"
    "dm-snapshot"
  ];

  services.lvm.boot.thin.enable = true;
}
