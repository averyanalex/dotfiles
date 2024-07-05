{inputs, ...}: {
  imports =
    (with inputs.self.nixosModules.modules; [
      nebula-averyan
      persist
    ])
    ++ (with inputs.self.nixosModules.profiles; [
      # mining
      # qemu
      agenix
      apparmor
      boot
      console
      dhcp
      dns
      filesystems
      home
      hosts
      locale
      logs
      misc-p
      monitoring
      nebula-averyan
      nftables
      nix
      nur
      persist
      polkit
      shell.zsh
      ssh-server
      stable
      sudo
      timezone
      unfree
      unsecure
      userdirs
      users
      vmvariant
      xdg
      yggdrasil
      zram
    ]);
}
