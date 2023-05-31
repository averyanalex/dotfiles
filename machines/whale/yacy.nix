{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "yacy/yacy_search_server";
    finalImageTag = "latest";
    imageDigest = "sha256:678ed9b2702c9f20349417d766ec6d2286e40742edc4f0fb683af6c0d7bd8a83";
    sha256 = "QhM0wyuVRye61137FhcOka8gP0NcfuPkwN4unBy6SEE=";
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

  containers.yacy = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostBridge = "yggbr0";

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
      networking = {
        firewall.enable = false;
        interfaces.eth0.ipv6 = {
          addresses = [
            {
              address = "317:7b20:ee43:21d3::5";
              prefixLength = 64;
            }
          ];
          routes = [
            {
              address = "200::";
              prefixLength = 7;
              via = "317:7b20:ee43:21d3::1";
            }
          ];
        };
      };

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
