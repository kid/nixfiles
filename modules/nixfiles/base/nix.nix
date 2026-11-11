{ inputs, ... }:
{
  nf.base.os = {
    # nh already prints a package diff on switch.
    srvos.update-diff.enable = false;

    nix = {
      settings = {
        experimental-features = [ "pipe-operators" ];

        substituters = [
          "https://kidibox.cachix.org"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
          "https://nix-gaming.cachix.org"
        ];

        trusted-public-keys = [
          "kidibox.cachix.org-1:BN875x9JUW61souPxjf7eA5Uh2k3A1OSA1JIb/axGGE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };
    };
  };

  # Macs run Determinate Nix (nix.enable = false), so srvos' Nix mixins would be no-ops there.
  nf.base.darwin =
    { config, lib, ... }:
    {
      imports = [ inputs.srvos.darwinModules.desktop ];

      # srvos enables this unconditionally; nix-darwin asserts it needs nix.enable.
      nix.optimise.automatic = lib.mkIf (!config.nix.enable) false;
    };

  nf.base.nixos = {
    imports = with inputs.srvos.nixosModules; [
      desktop
      mixins-nix-experimental
      mixins-trusted-nix-caches
      mixins-systemd-boot
    ];

    nix.settings.allowed-users = [ "@wheel" ];
  };
}
