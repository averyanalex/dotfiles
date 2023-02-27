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
}
