{ inputs, ... }: {
  imports = (with inputs.self.nixosModules.modules; [
    nebula-averyan
    persist
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
      autoupgrade
      boot
      dhcp
      dns
      home
      locale
      nebula-averyan
      nix
      nur
      persist
      polkit
      ssh-server
      sudo
      unsecure
      unstable
      userdirs
      users
      xdg
    ]);
}
