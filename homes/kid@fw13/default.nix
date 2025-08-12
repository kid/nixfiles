{ self, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
  ];

  nixfiles = {
    services.xremap.enable = true;

    programs.gui.enable = true;
  };
}
