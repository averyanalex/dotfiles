{
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      mpc-cli # cli mpd client
      mmtc # tui mpd client
      cantata # qt mpd client
      ario # gtk3 mpd client
      cava # music visualizer
      # cassette # yandex music client
    ];
    # ++ [
    #   inputs.nixpkgs-master.legacyPackages.x86_64-linux.cassette
    # ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/alex/Music";
    };

    programs.ncmpcpp = {
      enable = true;
    };
  };

  persist.state.homeDirs = [".local/share/cassette"];
}
