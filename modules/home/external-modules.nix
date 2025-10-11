{ inputs, ... }:
{
  imports = with inputs; [
    impermanence.homeManagerModules.impermanence
    plasma-manager.homeModules.plasma-manager
    sops-nix.homeManagerModules.sops
    xremap.homeManagerModules.default
  ];
}
