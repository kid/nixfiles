{ inputs, lib, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:danth/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nur.follows = "nur";
  };

  nf.stylix = {
    os =
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

    nixos = {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix.targets.qt.enable = lib.mkDefault false;
    };

    darwin = {
      imports = [ inputs.stylix.darwinModules.stylix ];
    };
  };
}
