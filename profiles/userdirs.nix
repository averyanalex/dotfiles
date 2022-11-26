{
  persist = {
    state = {
      homeDirs = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "projects"
        ".ssh"
        ".gnupg"
      ];
    };
    cache.homeDirs = [ ".cache" ];
  };
}
