{
  imports = [
    ./eww
    ./swaybg.nix
    ./hyprland
    ./sway.nix
  ];

  programs.eww-hyprland.enable = true;
  programs.zsh.profileExtra = builtins.readFile ../files/zprofile.sh;
}
