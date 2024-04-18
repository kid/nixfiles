{ pkgs, ... }: {
  stylix = {
    image = ./home-manager/wallpapers/gruvbox-dark-rainbow.png;
    base16Scheme =
      "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
