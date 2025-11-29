{ self, pkgs, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
  ];

  nixfiles = {
    packages = {
      inherit (pkgs) incus opencode;
    };

    services.xremap.enable = true;

    programs.gui.enable = true;
  };
}
