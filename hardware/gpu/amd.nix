{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      rocm-runtime
      amdvlk
    ];
  };

  environment.systemPackages = with pkgs; [
    rocm-smi
    radeontop
    rocminfo
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];
}
