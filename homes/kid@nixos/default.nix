{ self, pkgs, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
    "${self}/legacy/modules/home-manager/xremap.nix"
  ];

  programs.ghostty.enable = true;
  programs.ranger.enable = true;

  nixfiles = {
    packages = {
      inherit (pkgs) freecad-wayland;
    };

    services.xremap.enable = true;
  };
}
