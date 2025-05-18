{
  pkgs,
  ...
}:
{
  imports = [
    ./cli.nix
    ./ssh.nix
    ./firefox.nix
  ];

  # xdg.enable = true;

  home.packages = with pkgs; [
    winbox4
  ];
}
