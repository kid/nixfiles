{ config, ... }:
{
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
        command_palette_font_size = ${builtins.toString config.stylix.fonts.sizes.terminal},
        keys = {
          { key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection 'Left' },
          { key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection 'Up' },
          { key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection 'Down' },
          { key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection 'Right' },
        }
      }
    '';
  };

  xdg.enable = true;

  home.stateVersion = "22.05";
}
