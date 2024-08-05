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
          boot
          filesystems
          hosts
          locale
          logs
          misc-p
          monitoring
          nebula-averyan
          nftables
          nix
          persist
          proxy
          ssh-server
          sudo
          unfree
          unsecure
          userdirs
          users
          vmvariant
          xdg
          yggdrasil
        ]);
}
