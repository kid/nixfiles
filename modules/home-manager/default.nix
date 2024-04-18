{ pkgs, ... }:
let fontSize = 14;
in {
  imports = [
    ./fonts.nix
    ./editor.nix
    ./cli.nix
    ./git.nix
    ./ssh.nix
    ./kitty.nix
    ./firefox.nix
  ];

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
  };

  programs.wezterm.enable = true;
  programs.wezterm.enableZshIntegration = true;
  programs.wezterm.extraConfig = ''
    return {
      command_palette_font_size = ${builtins.toString fontSize},
    }
  '';

  xdg.enable = true;

  home.stateVersion = "22.05";

  stylix = {
    image = ./wallpapers/gruvbox-dark-rainbow.png;
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      };
      sizes.terminal = fontSize;
    };
    polarity = "dark";
  };
}
