{
  xsession.enable = true;

  programs.zsh.profileExtra = builtins.readFile ./files/zprofile.sh;

  home.file.".xinitrc".source = ./files/xinitrc.sh;

  home.file.".config/leftwm/config.toml".source = ./files/leftwm/config.toml;
  home.file.".config/leftwm/themes/current/up".source = ./files/leftwm/up;
  home.file.".config/leftwm/themes/current/down".source = ./files/leftwm/down;
  home.file.".config/leftwm/themes/current/change_to_tag".source = ./files/leftwm/change_to_tag;
  home.file.".config/leftwm/themes/current/theme.toml".source = ./files/leftwm/theme.toml;
  home.file.".config/leftwm/themes/current/polybar.ini".source = ./files/leftwm/polybar.ini;
  home.file.".config/leftwm/themes/current/template.liquid".source = ./files/leftwm/template.liquid;
}
