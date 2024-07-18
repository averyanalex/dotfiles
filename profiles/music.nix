{
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.alex = {
    home.packages = with pkgs;
      [
        mpc-cli # cli mpd client
        mmtc # tui mpd client
        cantata # qt mpd client
        ario # gtk3 mpd client
        cava # music visualizer
        # cassette # yandex music client
      ]
      ++ [
        inputs.tmpfork.legacyPackages.x86_64-linux.cassette
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

  persist.state.homeDirs = [".local/share/cassette"];
}
