{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../hardware/physical.nix
    ../../hardware/intelgpu.nix
    ../../hardware/sdboot.nix
  ];

  # Storage
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # Laptop
  hardware.sensor.iio.enable = true;
  hardware.bluetooth.enable = true;
  services.upower.enable = true;

  # Intel
  boot.kernelModules = [ "kvm-intel" ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "powersave";
}
