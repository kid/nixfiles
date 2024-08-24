{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = false;
    plugins.lualine.enable = true;

    opts = {
      number = true;
      relativenumber = true;
    };
  };
}
