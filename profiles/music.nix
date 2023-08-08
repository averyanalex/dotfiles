{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      mpc-cli # cli mpd client
      mmtc # tui mpd client
      cantata # qt mpd client
      ario # gtk3 mpd client
      cava # music visualizer
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/alex/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
    };
  };
}
