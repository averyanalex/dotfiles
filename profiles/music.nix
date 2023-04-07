{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      mpc-cli
      cantata
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/alex/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "pipewire"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
    };
  };
}
