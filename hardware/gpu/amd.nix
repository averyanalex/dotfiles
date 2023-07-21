{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # TODO: normal mesa
    package = pkgs.unstable.mesa.drivers;

    extraPackages = with pkgs.unstable; [
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
