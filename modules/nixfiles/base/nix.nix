{ inputs, ... }:
let
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
in
{
  # No nixpkgs follows: Determinate recommends against it (FlakeHub Cache misses).
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

  nf.base.os = {
    # nh already prints a package diff on switch.
    srvos.update-diff.enable = false;
  };

  # Macs run Determinate Nix: its module forces nix.enable = false, so nix-darwin ignores nix.settings
  # and srvos' Nix mixins would be no-ops there. Settings go to /etc/nix/nix.custom.conf instead,
  # as extra-* so they add to Determinate's defaults (cache.nixos.org, nix-command, flakes).
  nf.base.darwin =
    { config, lib, ... }:
    {
      imports = [
        inputs.srvos.darwinModules.desktop
        inputs.determinate.darwinModules.default
      ];

      determinateNix.customSettings = lib.mapAttrs' (name: lib.nameValuePair "extra-${name}") (
        settings
        // {
          # srvos sets this via nix.settings, which is ignored here.
          trusted-users = [ "@admin" ];
        }
      );

      # The installer's comment-only file (DetSys v0.33.0, v0.34.0); anything else aborts activation.
      environment.etc."nix/nix.custom.conf".knownSha256Hashes = [
        "6787fade1cf934f82db554e78e1fc788705c2c5257fddf9b59bdd963ca6fec63"
        "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"
      ];

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

    nix.settings = settings // {
      allowed-users = [ "@wheel" ];
    };
  };
}
