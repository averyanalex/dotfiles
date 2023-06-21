{
  inputs,
  lib,
  ...
}: {
  imports = with inputs.self.nixosModules.hardware;
    [
      physical
    ]
    ++ [inputs.nixos-hardware.nixosModules.raspberry-pi-4];

  # hardware.raspberry-pi."4".fkms-3d.enable = true;
  services.xserver.videoDrivers = lib.mkBefore [
    "modesetting" # Prefer the modesetting driver in X11
    "fbdev" # Fallback to fbdev
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_1;

  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];
}
