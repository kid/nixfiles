{
  pkgs,
  ...
}:
{
  imports = [
    ./cli.nix
    ./git.nix
    ./ssh.nix
    ./firefox.nix
  ];

  # xdg.enable = true;

  home.packages = with pkgs; [
    winbox4
  ];
}
