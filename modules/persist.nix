{ lib, config, inputs, ... }:

let
  inherit (builtins) concatMap;
  inherit (lib) mkIf;

  cfg = config.persist;

  persists = with cfg; [ state derivative cache ];
  takeAll = what: concatMap (x: x.${what});

  allHomeFiles = takeAll "homeFiles" persists;
  allHomeDirs = takeAll "homeDirs" persists;

  allSystemFiles = takeAll "files" persists;
  allSystemDirs = takeAll "dirs" persists;
in
{
  options =
    let
      inherit (lib) mkOption mkEnableOption;
      inherit (lib.types) path listOf either str attrs;

      common = {
        dirs = mkOption {
          type = listOf (either str attrs);
          default = [ ];
        };
        files = mkOption {
          type = listOf (either str attrs);
          default = [ ];
        };
        homeDirs = mkOption {
          type = listOf (either str attrs);
          default = [ ];
        };
        homeFiles = mkOption {
          type = listOf (either str attrs);
          default = [ ];
        };
      };

    in
    {
      persist = {
        enable = mkEnableOption "tmpfs root with opt-in state";

        persistRoot = mkOption {
          type = path;
          default = "/persist";
        };

        username = mkOption {
          type = str;
          default = "user";
        };

        state = common;
        derivative = common;
        cache = common;
      };
    };

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = mkIf cfg.enable {
    environment.persistence.${cfg.persistRoot} = {
      directories = allSystemDirs;
      files = allSystemFiles;

      users."${cfg.username}" = {
        directories = allHomeDirs;
        files = allHomeFiles;
      };
    };

    fileSystems."/" = {
      device = "none";
      options = [ "defaults" "size=4G" "mode=755" ];
      fsType = "tmpfs";
    };

    fileSystems."${cfg.persistRoot}" = {
      neededForBoot = true;
    };

    boot.initrd.postMountCommands = ''
      mkdir -p /mnt-root/nix
      mount --bind /mnt-root${cfg.persistRoot}/nix /mnt-root/nix
      chmod 755 /mnt-root
    '';
  };
}
