{ inputs, lib, ... }:
{
  nf.stylix.nixos =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        image = lib.mkDefault ./gruvbox-dark-rainbow.png;
        base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
        fonts = {
          monospace = {
            name = lib.mkDefault "JetBrainsMono Nerd Font Propo";
            package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
          };
          sizes.terminal = lib.mkDefault 11;
        };
        polarity = lib.mkDefault "dark";
        targets.qt.enable = lib.mkDefault false;
      };
    };
}
