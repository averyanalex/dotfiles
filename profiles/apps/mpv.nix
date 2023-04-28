{pkgs, ...}: {
  home-manager.users.alex = {
    programs.mpv = {
      enable = true;
      package = pkgs.unstable.mpv;
      config = {
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
      };
      profiles = {
        gpu-hq = {
          hwdec = "vaapi";
          vo = "gpu-next";
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";
        };
      };
    };
  };
}
