{ inputs, ... }:
{
  imports = with inputs; [
    plasma-manager.homeManagerModules.plasma-manager
    sops-nix.homeManagerModules.sops
    xremap.homeManagerModules.default
  ];
}
