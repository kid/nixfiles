{ pkgs, ... }:
{
  imports = [
    ./modules/fonts.nix
    ./modules/shell.nix
    ./modules/editor.nix
    ./modules/desktop.nix
  ];

  programs.home-manager.enable = true;
}
