{
  user.name = "kid";

  hm = {
    imports = [
      ../modules/home-manager/wallpaper.nix
      ../modules/home-manager/desktop.nix
      ./home-manager/desktop.nix
    ];
  };
}
