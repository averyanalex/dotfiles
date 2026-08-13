{
  inputs,
  modulesPath,
  ...
}:
let
  disableDiscardOnBrokenNvme = ''
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="nvme*n1", ATTRS{serial}=="9I50412053641", ATTR{queue/discard_max_bytes}="0"
  '';
in
{
  imports = [
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
    "dm-raid"
    "raid1"
  ];
  boot.initrd.services.udev.rules = disableDiscardOnBrokenNvme;

  boot.kernelParams = [
    # Disable NVMe APST; the MAXIO MAP1202 controller does not recover from hangs.
    "nvme_core.default_ps_max_latency_us=0"
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
    "dm-raid"
    "raid1"
  ];

  # The NX-1TB/MAXIO MAP1202 controller hangs on DISCARD requests of any size.
  services.udev.extraRules = disableDiscardOnBrokenNvme;

  services.lvm = {
    boot.thin.enable = true;
    dmeventd.enable = true;
  };
}
