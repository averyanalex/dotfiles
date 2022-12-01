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
      ];
    };
    cache.homeDirs = [ ".cache" ];
  };
}
