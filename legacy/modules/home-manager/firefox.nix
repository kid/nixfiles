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
        improved-tube
        plasma-integration
        onepassword-password-manager
      ];
      search.force = true;

      search.engines = {
        "Youtube" = {
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

        "GitHub" = {
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

        "Nix Packages" = {
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

        "Nix Options" = {
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

        "RottenTomatoes" = {
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

      settings = {
        "browser.sessionstore.restore_on_demand" = false;
        "signon.rememberSignons" = false;
        # "network.dns.echconfig.enabled" = false;
        # "network.dns.echconfig.fallback_to_origin_when_all_failed" = true;
      };
    };
  };

in
{
  programs.firefox = {
    enable = true;
    inherit policies profiles;
  };

  programs.floorp = {
    enable = true;
    inherit policies profiles;
  };

  stylix.targets.firefox.profileNames = [ "kid" ];
  # stylix.targets.floorp.profileNames = [ "kid" ];
}
