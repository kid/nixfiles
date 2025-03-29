{ self, inputs, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
    "${self}/legacy/modules/home-manager/xremap.nix"
  ];

  programs.ghostty.enable = true;
  programs.ranger.enable = true;
}
