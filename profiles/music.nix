{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      mpc-cli
      cantata
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/alex/Music";
    };
  };
}
