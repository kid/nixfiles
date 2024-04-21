{ config, ... }: {
  imports = [
    ./stylix.nix
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

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        command_palette_font_size = ${
          builtins.toString config.stylix.fonts.sizes.terminal
        },
      }
    '';
  };

  xdg.enable = true;

  home.stateVersion = "22.05";
}
