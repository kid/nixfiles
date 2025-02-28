{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.eww-hyprland;
  dependencies = with pkgs; [
    cfg.package
    config.wayland.windowManager.hyprland.package
    jaq
    socat
    bash
    ripgrep
  ];

  reload_script = pkgs.writeShellScript "reload_eww" ''
    windows=$(eww windows | rg '\*' | tr -d '*')

    systemctl --user restart eww.service

    echo $windows | while read -r w; do
      eww open $w
    done
  '';
in
{
  options.programs.eww-hyprland = {
    enable = lib.mkEnableOption "Eww Hyprland config";

    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.eww;
      defaultText = lib.literalExpression "pkgs.eww-wayland";
      description = "Eww package to use.";
    };

    autoReload = lib.mkOption {
      type = lib.types.bool;
      default = true;
      defaultText = lib.literalExpression "false";
      description = "Wether to restart the eww daemon and windows on change";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile.eww = {
      source = lib.cleanSourceWith {
        filter =
          name: _type:
          let
            baseName = baseNameOf (toString name);
          in
          !(lib.hasSuffix ".nix" baseName); # && (baseName != "_colors.scss");
        src = lib.cleanSource ./.;
      };

      recursive = true;

      onChange = if cfg.autoReload then reload_script.outPath else "";
    };

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
