{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixfiles.theme.stylix;
in
{
  options.nixfiles.theme.stylix = {
    enable = mkEnableOption "Stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ./gruvbox-dark-rainbow.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font Propo";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sizes.terminal = lib.mkDefault 11;
      };
      polarity = "dark";
      targets = {
        # TODO: needed?
        plymouth.enable = true;
        nixvim.plugin = "base16-nvim";
      };
    };
  };
}
