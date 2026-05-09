{ inputs, ... }:
{
  den.hosts.x86_64-linux.vulkan = {
    users.kid = { };
  };

  den.aspects.vulkan = {
    nixos.imports = [
      ./_configuration.nix
      ./_disko-config.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
    ])
    ++ (with inputs.nix-gaming.nixosModules; [
      wine
      pipewireLowLatency
      platformOptimizations
    ])
    ++ (with inputs; [
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
      lanzaboote.nixosModules.lanzaboote
      # niri.nixosModules.niri
    ]);

    nixos.nixpkgs = {
      overlays = with inputs; [
        nur.overlays.default
        # niri.overlays.niri
      ];

      config = {
        allowUnfree = true;
        allowBroken = false;
        allowAliases = false;
      };
    };

    # configurationRevision = inputs.self.shortRev or inputs.self.dirtyShortRev or "dirty";
    # nixos.label = "${config.system.nixos.version}-nixfiles-${config.system.configurationRevision}";
  };
}
