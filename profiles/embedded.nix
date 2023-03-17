{ pkgs, ... }:
{
  # Allow access to /dev/ttyUSBx
  users.users.alex.extraGroups = [ "dialout" ];

  home-manager.users.alex = {
    home.packages = with pkgs; [
      arduino
      esptool
      picocom
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", \
      MODE:="0666", \
      SYMLINK+="stlinkv1_%n"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374a", \
      MODE:="0666", \
      SYMLINK+="stlinkv2-1_%n"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", \
      MODE:="0666", \
      SYMLINK+="stlinkv2-1_%n"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", \
      MODE:="0666", \
      SYMLINK+="stlinkv2-1_%n"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
      MODE:="0666", \
      SYMLINK+="stlinkv2_%n"

    # STLink V3SET in Dual CDC mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"

    # STLink V3SET in Dual CDC mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"

    # STLink V3SET MINIE
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"

    # STLink V3SET 
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"

    # STLink V3SET 
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"
    
    # STLink V3SET in normal mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", \
      MODE:="0666", \
      SYMLINK+="stlinkv3_%n"
  '';
}
