{
  description = "AveryanAlex's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/NUR";

    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.11";
      inputs.nixpkgs-22_11.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # TODO: unpin when xwayland build will be fixed
    hyprland = {
      url = "github:hyprwm/Hyprland/a43b18ae265e83cb2e5968b46e5bc2b9f666f81f";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    averyanalex-blog = {
      url = "github:averyanalex/blog";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    cpmbot = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:cpmbot/bot";
    };
    firesquare-servers = {
      url = "github:fire-square/servers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";

    # prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    # stylix.url = "github:danth/stylix/release-22.11";
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    agenix,
    deploy-rs,
    ...
  } @ inputs: let
    findModules = dir:
      builtins.concatLists (builtins.attrValues (builtins.mapAttrs
        (name: type:
          if type == "regular"
          then [
            {
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = dir + "/${name}";
            }
          ]
          else if
            (builtins.readDir (dir + "/${name}"))
            ? "default.nix"
          then [
            {
              inherit name;
              value = dir + "/${name}";
            }
          ]
          else [
            {
              inherit name;
              value = builtins.listToAttrs (findModules (dir + "/${name}"));
            }
          ])
        (builtins.readDir dir)));
  in
    {
      nixosModules.hardware = builtins.listToAttrs (findModules ./hardware);
      nixosModules.modules = builtins.listToAttrs (findModules ./modules);
      nixosModules.profiles = builtins.listToAttrs (findModules ./profiles);
      nixosModules.roles = builtins.listToAttrs (findModules ./roles);

      deploy = {
        remoteBuild = true;
        sshUser = "alex";
        user = "root";
        autoRollback = false;
        magicRollback = false;
        nodes = {
          whale = {
            hostname = "whale";
            profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.whale;
          };
          hawk = {
            hostname = "hawk";
            profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hawk;
          };
          # ferret = {
          #   hostname = "192.168.3.130";
          #   profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ferret;
          # };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      nixosConfigurations =
        (with nixpkgs.lib; let
          hosts = builtins.attrNames (builtins.readDir ./machines);

          mkHost = name: let
            system = builtins.readFile (./machines + "/${name}/system.txt");
          in
            nixosSystem {
              inherit system;
              modules = [
                (import (./machines + "/${name}"))
                {networking.hostName = name;}
              ];
              specialArgs = {inherit inputs;};
            };
        in
          genAttrs hosts mkHost)
        // {
          rpi-image = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
              ({...}: {
                config = {
                  sdImage.compressImage = false;
                  boot.kernelPackages = nixpkgs-unstable.legacyPackages.aarch64-linux.linuxKernel.packages.linux_6_1;
                };
              })
            ];
          };
        };
    }
    // flake-utils.lib.eachSystem (with flake-utils.lib.system; [x86_64-linux aarch64-linux])
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          agenix.packages.${system}.agenix
          deploy-rs.packages.${system}.deploy-rs
          pkgs.alejandra
          pkgs.nebula
          pkgs.wireguard-tools
        ];
      };
    });
}
