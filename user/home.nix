{ pkgs, ... }:
{
  imports = [
    ./modules/shell.nix
    ./modules/fonts.nix
    ./modules/desktop.nix
  ];

  programs.home-manager.enable = true;
}
