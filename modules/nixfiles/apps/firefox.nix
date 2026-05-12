{ inputs, ... }:
{
  nf.apps.firefox = {
    nixos = {
      imports = [ inputs.nur.modules.nixos.default ];
    };

    darwin = {
      imports = [ inputs.nur.modules.darwin.default ];

      nixpkgs.overlays = [
        inputs.nixpkgs-firefox-darwin.overlay
      ];
    };

    homeManager =
      { config, pkgs, ... }:
      {
        programs.firefox = {
          enable = true;
          configPath = "${config.xdg.configHome}/mozilla/firefox";
          nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
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
          profiles.kid = {
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
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
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
              "browser.urlbar.openintab" = false;
              "signon.rememberSignons" = false;
              "widget.use-xdg-desktop-portal.file-picker" = 1;
            };
          };
        };

        stylix.targets.firefox.profileNames = [ "kid" ];
      };
  };
}
