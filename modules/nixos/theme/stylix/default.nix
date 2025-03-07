{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_: {
  stylix = {
    enable = true;
    image = ./gruvbox-dark-rainbow.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sizes.terminal = lib.mkDefault 10;
    };
    polarity = "dark";
    targets = {
      # TODO: needed?
      plymouth.enable = true;
      nixvim.plugin = "base16-nvim";
    };
  };
})
