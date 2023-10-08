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
          eza
          fzf
          git
          zoxide
          neovim
          misc-s
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
          misc-p
          locale
          logs
          monitoring
          mining
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
