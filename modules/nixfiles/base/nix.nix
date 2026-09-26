{ lib, ... }:
{
  nf.base.os = { pkgs, ... }: {
    nix = {
      channel.enable = lib.mkDefault false;
      package = pkgs.nixVersions.latest;

      # Fallback quickly if substituters are not available.
      settings = {
        connect-timeout = lib.mkDefault 5;
        fallback = true;
        max-free = lib.mkDefault (3000 * 1024 * 1024);
        min-free = lib.mkDefault (512 * 1024 * 1024);
        builders-use-substitutes = true;

        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];

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

  nf.base.nixos = {
    nix = {
      settings = {
        allowed-users = [ "@wheel" ];
        trusted-users = [ "@wheel" ];
      };

      optimise.automatic = true;

      daemonCPUSchedPolicy = lib.mkDefault "batch";
      daemonIOSchedClass = lib.mkDefault "idle";
      daemonIOSchedPriority = lib.mkDefault 7;
    };

    systemd.services.nix-gc.serviceConfig = {
      CPUSchedulingPolicy = "batch";
      IOSchedulingClass = "idle";
      IOSchedulingPriority = 7;
    };

    # Make builds to be more likely killed than important services.
    # 100 is the default for user slices and 500 is systemd-coredumpd@
    # We rather want a build to be killed than our precious user sessions as builds can be easily restarted.
    systemd.services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 250;
  };
}
