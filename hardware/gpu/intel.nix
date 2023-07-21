{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    package = pkgs.unstable.mesa.drivers;
    # driSupport32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
