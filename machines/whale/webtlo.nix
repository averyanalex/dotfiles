{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "berkut174/webtlo";
    finalImageTag = "latest";
    imageDigest = "sha256:522ceaa41c39ff46825d5fcab9908c8b806d4b7bf5ce70c2f2a61305d8cff440";
    sha256 = "sha256-UioNfJ1YfQMb12mQ5sRACxcZoNQ0CyxYtVzoM77Ikug=";
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
