{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModule
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.alex = {
      programs.home-manager.enable = true;

      home = {
        username = "alex";
        homeDirectory = "/home/alex";
        stateVersion = "22.05";
      };
    };
  };
}
