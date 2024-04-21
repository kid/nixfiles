{ pkgs, ... }:
{

  fonts = {
    packages = with pkgs; [
      material-symbols

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto

      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];

    enableDefaultPackages = false;

    # TODO: Should this be host specific?
    fontconfig = {
      subpixel.rgba = "none";
      subpixel.lcdfilter = "none";

      hinting.enable = true;
      # hinting.autohint = true;
      hinting.style = "full";
    };

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Color Emoji"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
