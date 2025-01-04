{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs.nerd-fonts;
    [
      jetbrains-mono
      fira-code
    ]
    ++ (with pkgs; [
      font-awesome
      lexend
    ]);
}
