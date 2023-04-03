{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    programs.firefox = {
      enable = true;
      # package = pkgs.firefox-wayland;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        # canvasblocker
        # cookies-txt
        # copy-selection-as-markdown
        decentraleyes
        # i-dont-care-about-cookies
        # ipfs-companion
        # temporary-containers
        ublock-origin
      ];
      profiles = {
        default = {
          isDefault = true;
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
      };
    };
  };

  persist.state.homeDirs = [ ".mozilla" ];
}
