{ pkgs, lib, ... }:
{
  imports = [ ./config.nix ];

  wayland.windowManager.hyprland.enable = true;

  xdg.configFile.hypr = {
    source = lib.cleanSourceWith {
      filter =
        name: _type:
        let
          baseName = baseNameOf (toString name);
        in
        !(lib.hasSuffix ".nix" baseName);

      src = lib.cleanSource ./.;
    };

    recursive = true;
  };

  # TODO move all of this:

  home.packages = with pkgs; [
    # hyprprop

    cliphist
    dunst
    playerctl
    wofi
    wl-clipboard
    wl-clip-persist
    socat

    # for eww
    jaq

    # libsForQt5.polkit-kde-agent
    libsForQt5.kwallet
    libsForQt5.kwallet-pam
    polkit_gnome
  ];

  home.pointerCursor = {
    # package = pkgs.bibata-cursors;
    # name = "Bibata-Modern-Classic";
    # size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  systemd.user.services = {
    # kwallet = {
    #   Unit = {
    #     Description = "kwallet";
    #     After = [ "graphical-session.target" ];
    #     Wants = [ "graphical-session.target" ];
    #   };
    #   Install = {
    #     WantedBy = [ "graphical-session.target" ];
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.libsForQt5.kwallet}/bin/kwalletd5";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
    # polkit-kde-authentication-agent-1 = {
    #   Unit = {
    #     Description = "polkit-kde-authentication-agent-1";
    #     After = [ "graphical-session.target" ];
    #     Wants = [ "graphical-session.target" ];
    #   };
    #   Install = {
    #     WantedBy = [ "graphical-session.target" ];
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
