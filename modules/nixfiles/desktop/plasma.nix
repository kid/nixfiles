{
  inputs,
  lib,
  nf,
  ...
}:
{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager/trunk";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  nf.desktop.plasma = {
    includes = [ nf.desktop.wayland ];
    nixos = {
      security.pam.services.sddm.kwallet.enable = true;

      services = {
        displayManager.sddm = {
          enable = true;
          settings.General.InputMethod = "";
        };

        desktopManager.plasma6 = {
          enable = true;
          enableQt5Integration = false;
        };
      };
    };

    homeManager =
      { ... }:
      {
        imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

        programs.plasma = {
          enable = true;
          overrideConfig = true;
          fonts.general = {
            family = "JetBrains Mono";
            pointSize = 12;
          };
          panels = [
            {
              location = "top";
              widgets = [
                {
                  name = "org.kde.plasma.kickoff";
                  config.General.icon = "nix-snowflake-white";
                }
                {
                  name = "org.kde.plasma.icontasks";
                  config.General.launchers = [ "applications:steam.desktop" ];
                }
                "org.kde.plasma.panelspacer"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
                "org.kde.plasma.marginsseparator"
              ];
            }
          ];
          configFile.kwinrc.ModifierOnlyShortcuts.Meta = "";
          session = {
            general.askForConfirmationOnLogout = false;
            sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
          };
          shortcuts.plasmashell."activate application launcher" = [ "Alt+F1" ];
        };

        # TODO: should this be dependend on nf.desktop.plasma or even move there?
        qt.platformTheme.name = lib.mkForce "kde";
      };
  };
}
