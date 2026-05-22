{
  inputs,
  lib,
  nf,
  ...
}:
{
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
      { config, ... }:
      {
        imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

        programs.plasma = {
          enable = true;
          overrideConfig = true;
          powerdevil.AC = {
            dimDisplay.enable = false;
            turnOffDisplay.idleTimeout = "never";
          };
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

        gtk.gtk4.theme = config.gtk.theme;
        qt.platformTheme.name = lib.mkForce "kde";
      };
  };
}
