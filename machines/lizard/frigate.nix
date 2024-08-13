{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "ghcr.io/blakeblackshear/frigate";
    finalImageTag = "0.14.0";
    imageDigest = "sha256:15ab24306f49389382f01d0e9b82b7d4a32f93d207202f518564753015216818";
    sha256 = "0ONrcyeF+dtKgrFa2vXKWMSRg+j/0ngFX91o7oA4IAU=";
  };
in {
  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [8971];

  virtualisation.oci-containers = {
    containers = {
      frigate = {
        image = "ghcr.io/blakeblackshear/frigate:0.14.0";
        imageFile = dockerImage;
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/var/lib/frigate/config:/config"
          "/var/lib/frigate/storage:/media/frigate"
        ];
        ports = [
          "8971:8971"
          "8554:8554"
          "8555:8555"
        ];
        extraOptions = [
          "--network=slirp4netns"
          "--privileged"
          "--device=/dev/video11:/dev/video11"
          "--shm-size=256m"
        ];
      };
    };
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/frigate";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];
}
