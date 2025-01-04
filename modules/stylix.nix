{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    image = ./home-manager/wallpapers/gruvbox-dark-rainbow.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    fonts = {
      monospace = {
        # name = "FiraCode Nerd Font";
        # package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sizes.terminal = lib.mkDefault 10;
    };
    polarity = "dark";
  };
}
