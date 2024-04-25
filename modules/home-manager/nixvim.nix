{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = false;
    plugins.lightline.enable = true;
  };
}
