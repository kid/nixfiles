{
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    # workspace = {
    #   lookAndFeel = "org.kde.breezedark.desktop";
    # };

    # TODO: should be specific to the machine
    powerdevil.AC.dimDisplay.enable = false;
    powerdevil.AC.turnOffDisplay.idleTimeout = "never";

    fonts = {
      general = {
        family = "JetBrains Mono";
        pointSize = 12;
      };
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "top";
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake-white";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default.
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [ "applications:steam.desktop" ];
            };
          }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.marginsseparator"
        ];
        # hiding = "autohide";
      }
      # Global menu at the top
      # {
      #   location = "top";
      #   height = 26;
      #   widgets = [ "org.kde.plasma.appmenu" ];
      # }
    ];

    configFile = {
      # Disable "start menu" on the meta key
      kwinrc.ModifierOnlyShortcuts.Meta = "";
    };
  };
}
