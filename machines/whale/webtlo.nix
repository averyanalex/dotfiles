{pkgs, ...}: let
  dockerImage = pkgs.dockerTools.pullImage {
    imageName = "berkut174/webtlo";
    finalImageTag = "latest";
    imageDigest = "sha256:c6c4c7395dba1fba97381be484634b2aa37053c558a9ebb0e98558c65a26dda2";
    sha256 = "sha256-TyChsTuR6JuRSeAJlER2zkvyOWLqB+zlz7FiVh0aPnI=";
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

  networking.firewall.extraInputRules = ''
    ip saddr { 10.57.1.40, 10.57.1.41 } tcp dport 1844 accept
  '';

  persist.state.dirs = [
    {
      directory = "/var/lib/webtlo";
      user = "1000";
      group = "1000";
      mode = "u=rwx,g=,o=";
    }
  ];
}
