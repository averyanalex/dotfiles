{
  home-manager.users.alex = {
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
      };
      profiles = {
        gpu-hq = {
          scale = "ewa_lanczossharp";
          cscale = "ewa_lanczossharp";
          hwdec = "vaapi";
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";
        };
      };
    };
  };
}
