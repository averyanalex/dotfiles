{inputs, ...}: {
  imports =
    [./minimal.nix]
    ++ (with inputs.self.nixosModules.profiles;
      with shell;
        [
          direnv
          eza
          fzf
          git
          gpg
          misc-s
          neovim
          zoxide
        ]
        ++ [
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
