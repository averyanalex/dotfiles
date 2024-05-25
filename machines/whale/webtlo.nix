{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "berkut174/webtlo";
    finalImageTag = "latest";
    imageDigest = "sha256:85b3fb3927072249b81ce0690247d1db0b7e8975ab06e8a2122a554c55c0de87";
    sha256 = "cVglaqNAsNRNOPrwMRjfLUc0D5Dtf5jw6KrDaEjSUcc=";
  };
in {
  virtualisation.oci-containers = {
    containers = {
      webtlo = {
        image = "berkut174/webtlo";
        imageFile = dockerImage;
        volumes = [
          "/var/lib/webtlo:/data"
        ];
        ports = ["1844:80"];
        extraOptions = ["--network=slirp4netns"];
      };
    };
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [1844];

  persist.state.dirs = [
    {
      directory = "/var/lib/webtlo";
      user = "1000";
      group = "1000";
      mode = "u=rwx,g=,o=";
    }
  ];
}
