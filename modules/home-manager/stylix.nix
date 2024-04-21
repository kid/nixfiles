{ pkgs, lib, ... }:
{
  stylix = {
    image = ./wallpapers/gruvbox-dark-rainbow.png;
    fonts = {
      monospace = {
        # name = "FiraCode Nerd Font";
        # package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        name = "JetBrainsMono Nerd Font";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
      };
      sizes.terminal = lib.mkDefault 10;
    };
    polarity = "dark";
  };
}
