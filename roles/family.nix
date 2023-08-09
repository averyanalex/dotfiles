{inputs, ...}: {
  imports = with inputs.self.nixosModules.modules;
    [persist]
    ++ (with inputs.self.nixosModules.profiles; [
      # home
      # nebula-averyan
      # persist
      # qemu
      # unsecure
      # userdirs
      # users
      # vmvariant
      # xdg
      # yggdrasil
      agenix
      boot
      console
      dhcp
      dns
      family-home
      family-users
      filesystems
      gui.gnome
      hosts
      locale
      logs
      monitoring
      nftables
      nix
      nur
      polkit
      ssh-server
      sudo
      timezone
      unfree
      stable
      zram
    ]);
}
