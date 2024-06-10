{
  imports = [
    ./eww
    ./hyprland
  ];

  programs.eww-hyprland.enable = true;
  programs.zsh.profileExtra = builtins.readFile ../files/zprofile.sh;
}
