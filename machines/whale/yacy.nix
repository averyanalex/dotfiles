{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "yacy/yacy_search_server";
    finalImageTag = "latest";
    imageDigest = "sha256:73519c8ac903129a6fb80b509df897b02bfdee0a5db1b178fde8729bf579b202";
    sha256 = "eVi4JegDdnMcSws7hVRNOROlr4R/gQ7R7H0WYR7Pb9Y=";
  };
in {
  systemd.tmpfiles.rules = [
    "d /hdd/yacy-ygg 755 115 121 - -"
    "d /hdd/yacy-olymp 755 115 121 - -"
    "d /hdd/yacy-freeworld 755 115 121 - -"
  ];

  virtualisation.oci-containers = {
    containers = {
      yacy-olymp = {
        image = "yacy/yacy_search_server";
        imageFile = dockerImage;
        volumes = [
          "/hdd/yacy-olymp/:/opt/yacy_search_server/DATA/"
        ];
        extraOptions = ["--network=host"];
      };
      yacy-freeworld = {
        image = "yacy/yacy_search_server";
        imageFile = dockerImage;
        volumes = [
          "/hdd/yacy-freeworld/:/opt/yacy_search_server/DATA/"
        ];
        extraOptions = ["--network=host"];
      };
    };
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [8739 8627];

  containers.yacy-ygg = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostBridge = "yggbr";

    extraFlags = ["--system-call-filter=@keyring" "--system-call-filter=bpf"];

    bindMounts = {
      "/var/lib/yacy/" = {
        hostPath = "/hdd/yacy-ygg";
        isReadOnly = false;
      };
    };

    config = {
      config,
      pkgs,
      ...
    }: {
      system.stateVersion = "23.05";
      networking = {
        firewall.enable = false;
        interfaces.eth0.ipv6 = {
          addresses = [
            {
              address = "30a:5fad::e";
              prefixLength = 64;
            }
          ];
          routes = [
            {
              address = "200::";
              prefixLength = 7;
              via = "30a:5fad::1";
            }
          ];
        };
      };

      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1;

      virtualisation.oci-containers = {
        containers = {
          yacy-ygg = {
            image = "yacy/yacy_search_server";
            imageFile = dockerImage;
            volumes = [
              "/var/lib/yacy/:/opt/yacy_search_server/DATA/"
            ];
            extraOptions = ["--network=host"];
          };
        };
      };
    };
  };
}
