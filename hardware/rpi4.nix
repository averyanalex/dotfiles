{inputs, ...}: {
  imports = with inputs.self.nixosModules.hardware; [
    physical
  ];

  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
  ];

  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
}
