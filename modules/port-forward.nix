{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.networking.portForwards;

  isIPv4Address =
    address:
    let
      octets = splitString "." address;
    in
    length octets == 4
    && all (octet: builtins.match "(0|[1-9][0-9]{0,2})" octet != null && toInt octet <= 255) octets;

  ipv4Address = types.addCheck types.str isIPv4Address;
  interfaceName = types.strMatching "[[:alnum:]_.:@+-]+";

  portRange = types.submodule {
    options = {
      from = mkOption {
        type = types.port;
        description = "First port in the inclusive range.";
      };
      to = mkOption {
        type = types.port;
        description = "Last port in the inclusive range.";
      };
    };
  };
  portSpec = types.either types.port portRange;

  forward = types.submodule {
    options = {
      inputInterface = mkOption {
        type = interfaceName;
        description = "Interface on which matching packets must arrive.";
        example = "nebula.averyan";
      };
      destinationAddress = mkOption {
        type = ipv4Address;
        description = "Host IPv4 address clients connect to.";
        example = "10.57.1.10";
      };
      targetAddress = mkOption {
        type = ipv4Address;
        description = "Internal IPv4 address to which matching packets are forwarded.";
        example = "10.90.102.2";
      };
      tcpPorts = mkOption {
        type = types.listOf portSpec;
        default = [ ];
        description = "TCP ports forwarded without port-number translation.";
        example = literalExpression ''
          [
            443
            { from = 50000; to = 50009; }
          ]
        '';
      };
      udpPorts = mkOption {
        type = types.listOf portSpec;
        default = [ ];
        description = "UDP ports forwarded without port-number translation.";
        example = [ 2021 ];
      };
    };
  };

  renderPort =
    port: if builtins.isInt port then toString port else "${toString port.from}-${toString port.to}";
  renderPorts = ports: concatStringsSep ", " (map renderPort ports);
  renderProtocol =
    rule: protocol: ports:
    optional (ports != [ ])
      "iifname \"${rule.inputInterface}\" ip daddr ${rule.destinationAddress} ${protocol} dport { ${renderPorts ports} } counter dnat to ${rule.targetAddress}";
  renderForward =
    _: rule: renderProtocol rule "tcp" rule.tcpPorts ++ renderProtocol rule "udp" rule.udpPorts;
  renderedRules = concatLists (mapAttrsToList renderForward cfg);

  rangeAssertions = concatLists (
    mapAttrsToList (
      name: rule:
      map (port: {
        assertion = builtins.isInt port || port.from <= port.to;
        message = "networking.portForwards.${name} contains a port range whose 'from' value exceeds its 'to' value";
      }) (rule.tcpPorts ++ rule.udpPorts)
    ) cfg
  );
in
{
  options.networking.portForwards = mkOption {
    type = types.attrsOf forward;
    default = { };
    example = literalExpression ''
      {
        bambuddy = {
          inputInterface = "nebula.averyan";
          destinationAddress = "10.57.1.10";
          targetAddress = "10.90.102.2";
          tcpPorts = [ 322 990 3000 3002 8883 { from = 50000; to = 50009; } ];
          udpPorts = [ 2021 ];
        };
      }
    '';
    description = ''
      Named, interface-scoped IPv4 DNAT rules. Source and target port numbers
      are identical. When the NixOS firewall filters forwarded traffic, its
      standard `ct status dnat` rule accepts matching connections.
    '';
  };

  config = mkIf (cfg != { }) {
    assertions =
      mapAttrsToList (name: rule: {
        assertion = rule.tcpPorts != [ ] || rule.udpPorts != [ ];
        message = "networking.portForwards.${name} must forward at least one TCP or UDP port";
      }) cfg
      ++ rangeAssertions;

    networking.nftables.enable = true;
    networking.nftables.tables."port-forwards" = {
      family = "ip";
      content = ''
        chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;
          ${concatStringsSep "\n          " renderedRules}
        }
      '';
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = mkDefault true;
  };
}
