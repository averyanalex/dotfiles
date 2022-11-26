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
        decentraleyes
        ublock-origin
        canvasblocker
        # i-dont-care-about-cookies
        cookies-txt
        # ipfs-companion
        bitwarden
        copy-selection-as-markdown
        temporary-containers
      ];
      profiles = {
        default = {
          isDefault = true;
          settings = {
            # Remove import bookmarks button and remove default bookmarks
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.bookmarks.addedImportButton" = true;

            # Locale
            "general.useragent.locale" = "en-US";
            "browser.search.region" = "RU";
            "browser.search.isUS" = false;

            # Alfis, I2P, tor TLD's
            "browser.fixup.domainsuffixwhitelist.mirror" = true;
            "browser.fixup.domainsuffixwhitelist.screen" = true;
            "browser.fixup.domainsuffixwhitelist.merch" = true;
            "browser.fixup.domainsuffixwhitelist.index" = true;
            "browser.fixup.domainsuffixwhitelist.onion" = true;
            "browser.fixup.domainsuffixwhitelist.anon" = true;
            "browser.fixup.domainsuffixwhitelist.conf" = true;
            "browser.fixup.domainsuffixwhitelist.ygg" = true;
            "browser.fixup.domainsuffixwhitelist.srv" = true;
            "browser.fixup.domainsuffixwhitelist.btn" = true;
            "browser.fixup.domainsuffixwhitelist.mob" = true;
            "browser.fixup.domainsuffixwhitelist.i2p" = true;

            # Yggdrasil tweaks
            "network.http.fast-fallback-to-IPv4" = false;
            "browser.fixup.fallback-to-https" = false;
            "browser.fixup.alternate.enabled" = false;
            "network.dns.disableIPv6" = false;

            # Isolation
            "browser.contentblocking.category" = "strict";
            "privacy.partition.serviceWorkers" = true; # isolate service workers

            # Cleanup
            "privacy.clearOnShutdown.offlineApps" = true;
            # "privacy.sanitize.sanitizeOnShutdown" = true;
            # "privacy.sanitize.timeSpan" = 0;

            # Cache and storage
            # "browser.cache.disk.enable" = true; # lw: false. disable disk cache
            # prevent media cache from being written to disk in pb, but increase max cache size to avoid playback issues
            # "browser.privatebrowsing.forceMediaMemoryCache" = true;
            # "media.memory_cache_max_size" = 65536;
            # lw: disable favicons in profile folder and page thumbnail capturing
            # "browser.shell.shortcutFavicons" = true; # lw: false
            # "browser.pagethumbnails.capturing_disabled" = false; # lw: true
            "browser.helperApps.deleteTempFileOnExit" = true; # delete temporary files opened with external apps

            # /** [SECTION] HISTORY AND SESSION RESTORE
            #  * since we hide the UI for modes other than custom we want to reset it for
            #  * everyone. same thing for always on PB mode.
            #  */
            # pref("privacy.history.custom", true);
            # pref("browser.privatebrowsing.autostart", false);
            # defaultPref("browser.sessionstore.privacy_level", 2); // prevent websites from storing session data like cookies and forms

            # History and session restore
            "browser.formfill.enable" = false; # disable form history
            # "browser.sessionstore.interval" = 60000; # increase time between session saves

            # Query stripping
            # "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";

            # # HTTPS
            # "dom.security.https_only_mode" = true; # only allow https in all windows, including private browsing
            # "network.auth.subresource-http-auth-allow" = 1; # block HTTP authentication credential dialogs
            # "security.mixed_content.block_display_content" = true; # block insecure passive content

            # # Referers
            # "network.http.referer.XOriginPolicy" = 0; # default, might be worth changing to 2 to stop sending them completely
            # "network.http.referer.XOriginTrimmingPolicy" = 2; # trim referer to only send scheme, host and port

            # # WebRTC
            # "media.peerconnection.ice.no_host" = true; # don't use any private IPs for ICE 
            # "media.peerconnection.ice.default_address_only" = true; # use a single interface for ICE candidates, the vpn one when a vpn is used

            # Proxy
            "network.gio.supported-protocols" = ""; # disable gio as it could bypass proxy
            "network.file.disable_unc_paths" = true; # hidden, disable using uniform naming convention to prevent proxy bypass
            "network.proxy.socks_remote_dns" = true; # forces dns query through the proxy when using one
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = true; # force webrtc inside proxy when one is used

            # # DNS
            # "network.trr.confirmationNS" = "skip"; # skip undesired doh test connection
            # "network.dns.disablePrefetch" = true; # disable dns prefetching

            # # Prefetching and speculative connections
            # "network.predictor.enabled" = false;
            # "network.prefetch-next" = false;
            # "network.http.speculative-parallel-limit" = 0;
            # "browser.places.speculativeConnect.enabled" = false;
            # # disable speculative connections and domain guessing from the urlbar
            # "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0; # default v104+
            # "browser.urlbar.speculativeConnect.enabled" = false;
            # # "browser.fixup.alternate.enabled" = false; # default v104+

            # Offline
            # let users set the browser as offline, without the browser trying to guess
            # "network.manage-offline-status" = false;

            # RFP
            # "privacy.resistFingerprinting" = true;
            # rfp related settings
            # "privacy.resistFingerprinting.block_mozAddonManager" = true; # prevents rfp from breaking AMO
            # "browser.startup.blankWindow" = false; # if set to true it breaks RFP windows resizing
            # "browser.display.use_system_colors" = false; # default but enforced due to RFP
            # increase the size of new RFP windows for better usability, while still using a rounded value.
            # if the screen resolution is lower it will stretch to the biggest possible rounded value.
            # also, expose hidden letterboxing pref but do not enable it for now.
            # "privacy.window.maxInnerWidth" = 1600;
            # "privacy.window.maxInnerHeight" = 900;
            # "privacy.resistFingerprinting.letterboxing" = false;

            # WebGL
            # "webgl.disabled" = false; # lw: true

            # # Certificates
            # "security.cert_pinning.enforcement_level" = 2; # enable strict public key pinning, might cause issues with AVs
            # # enable safe negotiation and show warning when it is not supported. might cause breakage.
            # "security.ssl.require_safe_negotiation" = true;
            # "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            # "security.remote_settings.crlite_filters.enabled" = true;
            # # "security.OCSP.require" = true;

            # # TLS/SSL
            # "security.tls.enable_0rtt_data" = false; # disable 0 RTT to improve tls 1.3 security
            # "security.tls.version.enable-deprecated" = false; # make TLS downgrades session only by enforcing it with pref()
            # # show relevant and advanced issues on warnings and error screens
            # "browser.ssl_override_behavior" = 1;
            # "browser.xul.error_pages.expert_bad_cert" = true;

            # # Permissions
            # "permissions.delegation.enabled" = false; # force permission request to show real origin
            # "permissions.manager.defaultsUrl" = ""; # revoke special permissions for some mozilla domains

            # Fonts
            # "gfx.font_rendering.opentype_svg.enabled" = false; # disale svg opentype fonts

            # Safe browsing
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.provider.google4.gethashURL" = "";
            "browser.safebrowsing.provider.google4.updateURL" = "";
            "browser.safebrowsing.provider.google.gethashURL" = "";
            "browser.safebrowsing.provider.google.updateURL" = "";
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
            "browser.safebrowsing.downloads.remote.block_uncommon" = false;
            "browser.safebrowsing.passwords.enabled" = false;
            "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
            "browser.safebrowsing.provider.google4.dataSharingURL" = "";

            # Others
            # "network.IDN_show_punycode" = true; # use punycode in idn to prevent spoofing
            "pdfjs.enableScripting" = false; # disable js scripting in the built-in pdf reader

            # Location
            # replace google with mozilla as the default geolocation provide and prevent use of OS location services
            "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
            "geo.provider.ms-windows-location" = false;
            "geo.provider.use_corelocation" = false;
            "geo.provider.use_gpsd" = false;
            "geo.provider.use_geoclue" = false;

            # Language
            # pref("javascript.use_us_english_locale", true);
            # pref("intl.accept_languages", "en-US, en");
            # // disable region specific updates from mozilla
            # lockPref("browser.region.network.url", "");
            # lockPref("browser.region.update.enabled", false);

            # DRM
            "media.eme.enabled" = false; # master switch for drm content
            "media.gmp-manager.url" = "data:text/plain,"; # prevent checks for plugin updates when drm is disabled
            # disable the widevine and the openh264 plugins
            "media.gmp-provider.enabled" = false;
            "media.gmp-gmpopenh264.enabled" = false;

            # Search and urlbar
            # lw: disable search suggestion and do not update opensearch engines
            # "browser.urlbar.suggest.searches" = true; # lw: false
            # "browser.search.suggest.enabled" = true; # lw: false
            # "browser.search.update" = true; # lw: false
            # "browser.urlbar.quicksuggest.enabled" = true; # lw: false
            "browser.urlbar.quicksuggest.dataCollection.enabled" = false; # custom
            "browser.urlbar.quicksuggest.onboardingDialogChoice" = "reject_2"; # custom
            "browser.urlbar.quicksuggest.shouldShowOnboardingDialog" = false; # custom

            # Downloads
            # user interaction should always be required for downloads, as a way to enhance security by asking the user to specific a certain save location
            # "browser.download.useDownloadDir" = false;
            # "browser.download.autohideButton" = false; # do not hide download button automatically
            # "browser.download.manager.addToRecentDocs" = true; # lw: false. do not add downloads to recents
            # "browser.download.alwaysOpenPanel" = false; # do not expand toolbar menu for every download, we already have enough interaction

            # Autoplay
            # block autoplay unless element is clicked, and apply the policy to all elements including muted ones
            "media.autoplay.blocking_policy" = 2;
            "media.autoplay.default" = 5;

            # Pop-ups and windows
            # "dom.disable_beforeunload" = false; # lw: true. disable "confirm you want to leave" pop-ups
            # "dom.disable_open_during_load" = false; # lw: true. block pop-ups windows
            # lw: "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
            # prevent scripts from resizing existing windows and opening new ones, by forcing them into new tabs that can't be resized as well
            # "dom.disable_window_move_resize" = true;
            # "browser.link.open_newwindow" = 3;
            # "browser.link.open_newwindow.restriction" = 0;

            # Mouse
            # lw: "middlemouse.contentLoadURL" = false; # prevent mouse middle click from opening links

            # Extensions
            # "extensions.webextensions.restrictedDomains" = "";
            # "extensions.enabledScopes" = 5; # hidden
            # "extensions.postDownloadThirdPartyPrompt" = false;
            # "extensions.systemAddon.update.enabled" = false;
            # "extensions.systemAddon.update.url" = "";
            # "extensions.webcompat-reporter.enabled" = false;
            # "extensions.webcompat-reporter.newIssueEndpoint" = "";

            # /** [SECTION] EXTENSION FIREWALL
            #  * the firewall can be enabled with the below prefs, but it is not a sane default:
            #  * defaultPref("extensions.webextensions.base-content-security-policy", "default-src 'none'; script-src 'none'; object-src 'none';");
            #  * defaultPref("extensions.webextensions.base-content-security-policy.v3", "default-src 'none'; script-src 'none'; object-src 'none';");
            #  */
            #

            # Updater
            "app.update.auto" = false;
            "app.update.checkInstallTime" = false; # custom

            # Sync
            "identity.fxaccounts.enabled" = false;

            # Lockwise
            "signon.rememberSignons" = false;
            "signon.management.page.breach-alerts.enabled" = false; # custom
            "signon.autofillForms" = false;
            "extensions.formautofill.available" = "off";
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.formautofill.creditCards.available" = false;
            "extensions.formautofill.heuristics.enabled" = false;
            "signon.formlessCapture.enabled" = false;

            # Containers
            # enable containers and show the settings to control them in the stock ui
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;

            # Devtools
            # disable chrome and remote debugging
            # "devtools.chrome.enabled" = false;
            # "devtools.debugger.remote-enabled" = false;
            # "devtools.remote.adb.extensionURL" = "";
            # "devtools.selfxss.count" = 0; # required for devtools console to work

            # Others
            "browser.translation.engine" = ""; # remove translation engine
            "accessibility.force_disabled" = 1; # block accessibility services
            "webchannel.allowObject.urlWhitelist" = ""; # do not receive objects through webchannels
            "services.settings.server" = "https://%.invalid"; # set the remote settings URL (REMOTE_SETTINGS_SERVER_URL in the code)

            # Branding
            # "app.support.baseURL" = "https://librewolf.net/docs/faq/#";
            # "browser.search.searchEnginesURL" = "https://librewolf.net/docs/faq/#how-do-i-add-a-search-engine";
            # "browser.geolocation.warning.infoURL" = "https://librewolf.net/docs/faq/#how-do-i-enable-location-aware-browsing";
            # "app.feedback.baseURL" = "https://librewolf.net/#questions";
            # defaultPref("app.releaseNotesURL", "https://gitlab.com/librewolf-community/browser");
            # defaultPref("app.releaseNotesURL.aboutDialog", "https://gitlab.com/librewolf-community/browser");
            # defaultPref("app.update.url.details", "https://gitlab.com/librewolf-community/browser");
            # defaultPref("app.update.url.manual", "https://gitlab.com/librewolf-community/browser");

            # First launch
            "browser.startup.homepage_override.mstone" = "ignore";
            "startup.homepage_override_url" = "about:blank";
            # "browser.startup.homepage" = "https://search.nixos.org"; # custom
            "startup.homepage_welcome_url" = "about:blank";
            "startup.homepage_welcome_url.additional" = "";
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.uitour.enabled" = false;
            "browser.uitour.url" = "";
            "browser.shell.checkDefaultBrowser" = false;

            # New tab page
            #  * we want the new tab page to display nothing but the search bar without anything distracting.
            #  */
            # defaultPref("browser.newtab.preload", false);
            # defaultPref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
            # defaultPref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
            # defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false);
            # // hide pocket and sponsored content, from new tab page and search bar
            # lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
            # lockPref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
            # lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
            # lockPref("browser.newtabpage.activity-stream.feeds.section.topstories.options", "{\"hidden\":true}"); // hide buggy pocket section from about:preferences#home
            # lockPref("browser.newtabpage.activity-stream.showSponsored", false);
            # lockPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
            # lockPref("browser.newtabpage.activity-stream.telemetry", false);
            # lockPref("browser.newtabpage.activity-stream.default.sites", "");
            # lockPref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
            # lockPref("browser.newtabpage.activity-stream.discoverystream.enabled", false);
            # lockPref("browser.newtabpage.activity-stream.feeds.snippets", false); // default

            # About
            # remove annoying ui elements from the about pages, including about:protections
            "browser.contentblocking.report.lockwise.enabled" = false;
            "browser.contentblocking.report.monitor.enabled" = false;
            "browser.contentblocking.report.hide_vpn_banner" = true;
            "browser.contentblocking.report.vpn.enabled" = false;
            "browser.contentblocking.report.show_mobile_app" = false;
            "browser.vpn_promo.enabled" = false;
            "browser.promo.focus.enabled" = false;
            # ...about:addons recommendations sections and more
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.getAddons.cache.enabled" = false; # disable fetching of extension metadata
            "lightweightThemes.getMoreURL" = ""; # disable button to get more themes
            # ...about:preferences#home
            "browser.topsites.useRemoteSetting" = false; # hide sponsored shortcuts button
            # ...and about:config
            "browser.aboutConfig.showWarning" = false;
            # hide about:preferences#moreFromMozilla
            "browser.preferences.moreFromMozilla" = false;

            # /** [SECTION] RECOMMENDED
            #  * disable all "recommend as you browse" activity.
            #  */
            # lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
            # lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
            #

            # Disable telemetry
            "toolkit.telemetry.unified" = false; # master switch
            "toolkit.telemetry.enabled" = false; # master switch
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabledFirstSession" = false; # default
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false; # default
            "toolkit.telemetry.cachedClientID" = "";
            "toolkit.telemetry.previousBuildID" = "";
            "toolkit.telemetry.server_owner" = "";
            "toolkit.coverage.opt-out" = true; # hidden
            "toolkit.telemetry.coverage.opt-out" = true; # hidden
            "toolkit.coverage.enabled" = false;
            "toolkit.coverage.endpoint.base" = "";
            "toolkit.crashreporter.infoURL" = "";
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "security.protectionspopup.recordEventTelemetry" = false;
            "browser.ping-centre.telemetry" = false;
            # opt-out of normandy and studies
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "app.shield.optoutstudies.enabled" = false;
            # disable personalized extension recommendations
            "browser.discovery.enabled" = false;
            "browser.discovery.containers.enabled" = false;
            "browser.discovery.sites" = "";
            # disable crash report
            "browser.tabs.crashReporting.sendReport" = false;
            "breakpad.reportURL" = "";
            # disable connectivity checks
            "network.connectivity-service.enabled" = false;
            # disable captive portal
            "network.captive-portal-service.enabled" = false;
            "captivedetect.canonicalURL" = "";
            # prevent sending server side analytics
            "beacon.enabled" = false;
          };
        };
      };
    };
  };

  persist.state.homeDirs = [ ".mozilla" ];
}
