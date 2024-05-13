{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    plugins.lualine.enable = true;

    opts = {
      number = true;
      relativenumber = true;
    };
  };
}
