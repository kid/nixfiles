{
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in
{
  options.nixfiles.programs.defaults = {
    browser = mkOption {
      default = "firefox";
      type = enum [
        "firefox"
        "floorp"
      ];
    };

    shell = mkOption {
      default = "zsh";
      type = enum [
        "bash"
        "zsh"
        "fish"
        "nushell"
      ];
    };

    terminal = mkOption {
      default = "wezterm";
      type = enum [
        "wezterm"
        "ghostty"
        "kitty"
      ];
    };

    launcher = mkOption {
      default = "krunner";
      type = enum [
        "krunner"
      ];
    };
  };
}
