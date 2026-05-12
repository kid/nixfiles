{ inputs, lib, ... }:
let
  mod =
    { pkgs, ... }:
    {
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
      };
    };
in
{
  nf.stylix.nixos = {
    imports = [
      inputs.stylix.nixosModules.stylix
      mod
    ];

    stylix.targets.qt.enable = lib.mkDefault false;
  };

  nf.stylix.darwin = {
    imports = [
      inputs.stylix.darwinModules.stylix
      mod
    ];
  };
}
