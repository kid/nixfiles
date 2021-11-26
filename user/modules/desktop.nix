{ config, ... }:
{
  # home.file.".xinitrc".source = ../files/xinitrc.sh;
  # home.file."${config.home.homeDirectory}.zprofile".source = ../files/zprofile.sh;

  programs.zsh.profileExtra = builtins.readFile ../files/zprofile.sh;
}
