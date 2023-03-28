{
  description = "AveryanAlex's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/NUR";

    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.11";
      inputs.nixpkgs-22_11.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    averyanalex-blog.url = "github:averyanalex/blog";
    cpmbot.url = "github:averyanalex/cpmbot";
    firesquare-servers.url = "github:fire-square/servers";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, ... }@inputs:
    let
      findModules = dir:
        builtins.concatLists (builtins.attrValues (builtins.mapAttrs
          (name: type:
            if type == "regular" then [{
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = dir + "/${name}";
            }] else if (builtins.readDir (dir + "/${name}"))
              ? "default.nix" then [{
              inherit name;
              value = dir + "/${name}";
            }] else
              [{
                inherit name;
                value = builtins.listToAttrs (findModules (dir + "/${name}"));
              }])
          (builtins.readDir dir)));
    in
    {
      nixosModules.modules = builtins.listToAttrs (findModules ./modules);
      nixosModules.profiles = builtins.listToAttrs (findModules ./profiles);
      nixosModules.hardware = builtins.listToAttrs (findModules ./hardware);
      nixosModules.roles = import ./roles;

      nixosConfigurations = with nixpkgs.lib;
        let
          hosts = builtins.attrNames (builtins.readDir ./machines);

          mkHost = name:
            let
              system = builtins.readFile (./machines + "/${name}/system.txt");
            in
            nixosSystem {
              inherit system;
              modules = [
                (import (./machines + "/${name}"))
                { networking.hostName = name; }
              ];
              specialArgs = { inherit inputs; };
            };
        in
        genAttrs hosts mkHost;
    } // flake-utils.lib.eachSystem (with flake-utils.lib.system; [ x86_64-linux aarch64-linux ])
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              agenix.packages.${system}.agenix
              pkgs.nebula
              pkgs.wireguard-tools
            ];
          };
        });
}
