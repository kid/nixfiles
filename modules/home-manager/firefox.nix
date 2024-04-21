{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";
    };
    profiles.kid = {
      # extensions = with inputs.firefox-addons.packages.x86_64-linux; [
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        sponsorblock
        ublock-origin
        improved-tube
        onepassword-password-manager
      ];
      search.force = true;

      search.engines = {
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
      };
    };
  };
}
