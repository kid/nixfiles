{ inputs, ... }:
{
  imports = with inputs; [
    home-manager.nixosModules.default
    auto-cpufreq.nixosModules.default
    nixos-facter-modules.nixosModules.facter
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence
    stylix.nixosModules.stylix
    ucodenix.nixosModules.default
    sops-nix.nixosModules.sops
    nixvim.nixosModules.nixvim
    nixvim.nixosModules.config
    xremap.nixosModules.default
    nur.modules.nixos.default
    chaotic.nixosModules.default
    nix-gaming.nixosModules.ntsync
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
  ];
}
