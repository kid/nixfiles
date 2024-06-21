{
  user.name = "kid";

  imports = [../modules/nixos/leftwm.nix];

  hm = {
    imports = [
      ../modules/home-manager/wallpaper.nix
      ../modules/home-manager/desktop.nix
      ../modules/home-manager/leftwm.nix
      ./home-manager/desktop.nix
    ];
  };
}
