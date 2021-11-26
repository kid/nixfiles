{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.modules.shell;
in
{
  options.modules.shell = {
    enable = mkEnableOption "Shell configuration";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      home.packages = with pkgs; [
        git
        # home-manager
      ];

      programs.starship.enable = true;
      programs.starship.enableZshIntegration = true;

      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;

      programs.zsh = {
        enable = true;
        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
            { name = "plugins/fancy-ctrl-z"; tags = [ from:oh-my-zsh ]; }
            { name = "Aloxaf/fzf-tab"; }
            { name = "agkozak/zsh-z"; }
          ];
        };
      };
    };
  };
}
