{ inputs, ... }:
{
  imports = with inputs; [
    impermanence.homeManagerModules.impermanence
    plasma-manager.homeManagerModules.plasma-manager
    sops-nix.homeManagerModules.sops
    xremap.homeManagerModules.default
  ];
}
