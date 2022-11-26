{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      texstudio
      texlive.combined.scheme-full
      hunspell
      hunspellDicts.en-us
      hunspellDicts.ru-ru
    ];
  };
}
