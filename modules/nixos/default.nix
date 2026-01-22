localFlake:
{ inputs', ... }:
let
  inherit (localFlake.nixfiles.lib.helpers) listImportableRecursive;
in
{
  _module.args = {
    # inherit (localFlake) inputs;
    localLib = localFlake.nixfiles.lib;
    inherit (localFlake) nixfiles;
    inherit inputs';
  };

  imports =
    with localFlake.inputs;
    [
      home-manager.nixosModules.default
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
    ]
    ++ listImportableRecursive ../base
    ++ listImportableRecursive ./.;
}
