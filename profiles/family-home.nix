{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModule
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.olga = {
      programs.home-manager.enable = true;

      home = {
        username = "olga";
        homeDirectory = "/home/olga";
        stateVersion = "22.11";
      };
    };
  };
}
