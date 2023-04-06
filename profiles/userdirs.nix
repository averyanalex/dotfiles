{
  persist = {
    state = {
      homeDirs = [
        ".ssh"
        "Documents"
        "Downloads"
        "Music"
        "Notes"
        "Pictures"
        "projects"
      ];
    };
    cache.homeDirs = [".cache" ".cargo"];
  };
}
