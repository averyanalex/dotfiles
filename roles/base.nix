{ inputs, ... }: {
  imports = (with inputs.self.nixosModules.modules; [
    nebula-averyan
    persist
    yggdrasil
  ]) ++ (with inputs.self.nixosModules.profiles;
    with shell; [
      gpg
      zsh

      direnv
      exa
      fzf
      git
      micro
      utils
      zoxide
    ] ++ [
      agenix
      apparmor
      boot
      console
      dhcp
      dns
      enloc
      home
      nebula-averyan
      nix
      nur
      persist
      polkit
      ssh-server
      sudo
      timezone
      unsecure
      unstable
      userdirs
      users
      xdg
      yggdrasil
    ]);
}
