{ pkgs, ... }:
{
  imports = [
    ./editor.nix
    ./cli.nix
    ./git.nix
    ./ssh.nix
    ./kitty.nix
  ];

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
  };

  programs.wezterm.enable = true;

  xdg.enable = true;

  home.stateVersion = "22.05";

  stylix = {
    image = ./wallpapers/gruvbox-dark-rainbow.png;
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      };
      sizes.terminal = 11;
    };
    polarity = "dark";
  };
}
