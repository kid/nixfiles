{ inputs, ... }:
{
  imports = with inputs; [
    home-manager.nixosModules.default
    nixos-facter-modules.nixosModules.facter
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence
    preservation.nixosModules.preservation
    stylix.nixosModules.stylix
    ucodenix.nixosModules.default
    sops-nix.nixosModules.sops
    xremap.nixosModules.default
    nur.modules.nixos.default
    chaotic.nixosModules.default
    nix-gaming.nixosModules.wine
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
    lanzaboote.nixosModules.lanzaboote
    niri.nixosModules.niri
  ];
}
