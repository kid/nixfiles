{ pkgs, ... }:
{
  imports = [
    ./editor.nix
    ./cli.nix
    ./git.nix
    ./ssh.nix
    ./kitty.nix
  ];

  programs.home-manager = {
    enable = true;
  };

  xdg.enable = true;
}
