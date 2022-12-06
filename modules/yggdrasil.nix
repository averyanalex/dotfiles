{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.av-yggdrasil;
  settingsProvided = cfg.settings != { };
  configFileProvided = cfg.configFile != null;

  format = pkgs.formats.json { };
in
{
  options = with types; {
    services.av-yggdrasil = {
      enable = mkEnableOption (lib.mdDoc "the yggdrasil system service");

      settings = mkOption {
        type = format.type;
        default = { };
        example = {
          Peers = [
            "tcp://aa.bb.cc.dd:eeeee"
            "tcp://[aaaa:bbbb:cccc:dddd::eeee]:fffff"
          ];
          Listen = [
            "tcp://0.0.0.0:xxxxx"
          ];
        };
        description = lib.mdDoc ''
          Configuration for yggdrasil, as a Nix attribute set.

          Warning: this is stored in the WORLD-READABLE Nix store!
          Therefore, it is not appropriate for private keys. If you
          wish to specify the keys, use {option}`configFile`.

          If the {option}`persistentKeys` is enabled then the
          keys that are generated during activation will override
          those in {option}`settings` or
          {option}`configFile`.

          If no keys are specified then ephemeral keys are generated
          and the Yggdrasil interface will have a random IPv6 address
          each time the service is started, this is the default.

          If both {option}`configFile` and {option}`settings`
          are supplied, they will be combined, with values from
          {option}`configFile` taking precedence.

          You can use the command `nix-shell -p yggdrasil --run "yggdrasil -genconf"`
          to generate default configuration values with documentation.
        '';
      };

      configFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/yggdrasil.conf";
        description = lib.mdDoc ''
          A file which contains JSON configuration for yggdrasil.
          See the {option}`settings` option for more information.
        '';
      };

      openMulticastPort = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open the UDP port used for multicast peer
          discovery. The NixOS firewall blocks link-local
          communication, so in order to make local peering work you
          will also need to set `LinkLocalTCPPort` in your
          yggdrasil configuration ({option}`settings` or
          {option}`configFile`) to a port number other than 0,
          and then add that port to
          {option}`networking.firewall.allowedTCPPorts`.
        '';
      };

      denyDhcpcdInterfaces = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "tap*" ];
        description = lib.mdDoc ''
          Disable the DHCP client for any interface whose name matches
          any of the shell glob patterns in this list.  Use this
          option to prevent the DHCP client from broadcasting requests
          on the yggdrasil network.  It is only necessary to do so
          when yggdrasil is running in TAP mode, because TUN
          interfaces do not support broadcasting.
        '';
      };

      package = mkOption {
        type = package;
        default = pkgs.yggdrasil;
        defaultText = literalExpression "pkgs.yggdrasil";
        description = lib.mdDoc "Yggdrasil package to use.";
      };

      persistentKeys = mkEnableOption (lib.mdDoc ''
        If enabled then keys will be generated once and Yggdrasil
        will retain the same IPv6 address when the service is
        restarted. Keys are stored at ${keysPath}.
      '');

      keysPath = mkOption {
        type = str;
        default = "/var/lib/yggdrasil/keys.json";
        description = lib.mdDoc "Where persistent keys are stored.";
      };
    };
  };

  config = mkIf cfg.enable (
    let binYggdrasil = cfg.package + "/bin/yggdrasil";
    in
    {
      assertions = [{
        assertion = config.networking.enableIPv6;
        message = "networking.enableIPv6 must be true for yggdrasil to work";
      }];

      system.activationScripts.yggdrasil = mkIf cfg.persistentKeys ''
        if [ ! -e ${cfg.keysPath} ]
        then
          mkdir --mode=700 -p ${builtins.dirOf cfg.keysPath}
          ${binYggdrasil} -genconf -json \
            | ${pkgs.jq}/bin/jq \
                'to_entries|map(select(.key|endswith("Key")))|from_entries' \
            > ${cfg.keysPath}
        fi
      '';

      systemd.services.yggdrasil = {
        description = "Yggdrasil Network Service";
        after = [ "network-pre.target" ];
        wants = [ "network.target" ];
        before = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart =
          (if settingsProvided || configFileProvided || cfg.persistentKeys then
            ''mkdir --mode=700 -p /run/yggdrasil
            echo ''

            + (lib.optionalString settingsProvided
              "'${builtins.toJSON cfg.settings}'")
            + (lib.optionalString configFileProvided "$(cat ${cfg.configFile})")
            + (lib.optionalString cfg.persistentKeys "$(cat ${cfg.keysPath})")
            + " | ${pkgs.jq}/bin/jq -s add | ${binYggdrasil} -normaliseconf -useconf"
          else
            "${binYggdrasil} -genconf") + " > /run/yggdrasil/yggdrasil.conf";

        serviceConfig = {
          ExecStart =
            "${binYggdrasil} -useconffile /run/yggdrasil/yggdrasil.conf";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "always";
        };
      };

      networking.dhcpcd.denyInterfaces = cfg.denyDhcpcdInterfaces;
      networking.firewall.allowedUDPPorts = mkIf cfg.openMulticastPort [ 9001 ];

      # Make yggdrasilctl available on the command line.
      environment.systemPackages = [ cfg.package ];
    }
  );
}
