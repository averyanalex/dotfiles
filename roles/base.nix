{inputs, ...}: {
  imports =
    (with inputs.self.nixosModules.modules; [
      nebula-averyan
      persist
    ])
    ++ (with inputs.self.nixosModules.profiles;
      with shell;
        [
          gpg
          zsh

          direnv
          exa
          fzf
          git
          zoxide
          misc
        ]
        ++ [
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
          monitoring
          nebula-averyan
          nftables
          nix
          nur
          persist
          polkit
          qemu
          ssh-server
          sudo
          timezone
          unfree
          unsecure
          stable
          userdirs
          users
          vmvariant
          xdg
          yggdrasil
          zram
        ]);
}
