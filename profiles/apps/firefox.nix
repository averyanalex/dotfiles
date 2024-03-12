{pkgs, ...}: {
  home-manager.users.alex = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
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
            metamask
          ];
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;

            # Disable pocket
            "extensions.pocket.enabled" = false;
            "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;

            # Block DRM
            "media.eme.enabled" = false;
            "media.gmp-manager.url" = "data:text/plain,";
            "media.gmp-provider.enabled" = false;
            "media.gmp-gmpopenh264.enabled" = false;

            # New tab
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          };
        };
      };
    };
  };

  persist.state.homeDirs = [".mozilla"];
}
