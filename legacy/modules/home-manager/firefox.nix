{
  pkgs,
  ...
}:
let
  policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DontCheckDefaultBrowser = true;
    DisablePocket = true;
    SearchBar = "unified";
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
  };
  # TODO: replace with config value here
  profiles = {
    kid = {
      # extensions = with inputs.firefox-addons.packages.x86_64-linux; [
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        sponsorblock
        ublock-origin
        consent-o-matic
        improved-tube
        sidebery
        onepassword-password-manager
        proton-pass
        plasma-integration
      ];

      search = {
        force = true;

        engines = {
          youtube = {
            name = "YouTube";
            definedAliases = [ "@yt" ];
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          github = {
            name = "GitHub";
            definedAliases = [ "@gh" ];
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          nix-packages = {
            name = "Nix Packages";
            definedAliases = [ "@np" ];
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          nixos-options = {
            name = "Nix Options";
            definedAliases = [ "@no" ];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [
              { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
            ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };

          rottentomatoes = {
            name = "RottenTomatoes";
            definedAliases = [ "@rt" ];
            urls = [
              {
                template = "https://www.rottentomatoes.com/search";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };

      settings = {
        "browser.sessionstore.resuming_after_os_restart" = true;
        "browser.sessionstore.restore_on_demand" = false;
        "browser.sessionstore.restore_pinned_tabs_on_demand" = false;
        "browser.startup.page" = 3;
        "browser.tabs.groups.enable" = true;
        "browser.tabs.tabMinWidth" = 85;
        "browser.urlbar.openintab" = true;
        "signon.rememberSignons" = false;
        # "network.dns.echconfig.enabled" = false;
        # "network.dns.echconfig.fallback_to_origin_when_all_failed" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

in
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    inherit policies profiles;
  };

  programs.floorp = {
    enable = false;
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    inherit policies profiles;
  };

  stylix.targets.firefox.profileNames = [ "kid" ];
  stylix.targets.floorp.profileNames = [ "kid" ];
}
