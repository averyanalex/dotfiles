{ pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [
      unstable.rocm-opencl-icd
      unstable.rocm-opencl-runtime
      unstable.rocm-runtime

      amdvlk
      # driversi686Linux.amdvlk
    ];
  };

  environment.systemPackages = with pkgs; [
    rocm-smi
    radeontop
    unstable.rocminfo
  ];
}
