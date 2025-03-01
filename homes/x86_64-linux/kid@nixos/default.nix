{ inputs, ... }:
{
  imports = [
    inputs.xremap.homeManagerModules.default
    ../../../legacy/modules/home-manager
    ../../../legacy/modules/home-manager/desktop.nix
    ../../../legacy/modules/home-manager/plasma.nix
    ../../../legacy/modules/home-manager/xremap.nix
  ];
}
