{ inputs, ... }: {
  imports = (with inputs.self.nixosModules.modules; [
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
      boot
      dns
      home
      locale
      nix
      nur
      persist
      ssh-server
      sudo
      unstable
      userdirs
      users
      xdg
      yggdrasil
    ]);
}
