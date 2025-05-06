{ self, pkgs, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
    # "${self}/legacy/modules/home-manager/xremap.nix"
  ];

  nixfiles = {
    packages = {
      inherit (pkgs) freecad-wayland winbox4;
    };

    services.xremap.enable = true;

    programs.gui.enable = true;
  };
}
