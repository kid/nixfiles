{ pkgs, ... }:
{
  home.sessionVariables = {
    # https://github.com/nix-community/home-manager/issues/423
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };

    settings = {
      enable_audio_bell = "no";
      enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";

      background = "#282828";
      foreground = "#ebdbb2";

      color0 = "#282828";
      color8 = "#928374";
      # DarkRed + Red";
      color1 = "#cc241d";
      color9 = "#fb4934";
      # DarkGreen + Green";
      color2 = "#98971a";
      color10 = "#b8bb26";
      # DarkYellow + Yellow";
      color3 = "#d79921";
      color11 = "#fabd2f";
      # DarkBlue + Blue";
      color4 = "#458588";
      color12 = "#83a598";
      # DarkMagenta + Magenta";
      color5 = "#b16286";
      color13 = "#d3869b";
      # DarkCyan + Cyan";
      color6 = "#689d6a";
      color14 = "#8ec07c";
      # LightGrey + White";
      color7 = "#a89984";
      color15 = "#ebdbb2";
    };

    keybindings = {
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+h" = "neighboring_window left";
      "kitty_mod+l" = "neighboring_window right";
      "kitty_mod+j" = "neighboring_window down";
      "kitty_mod+k" = "neighboring_window up";
    };
  };
}
