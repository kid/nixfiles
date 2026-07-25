{ inputs, nf, ... }:
{
  flake-file.inputs.xremap = {
    url = "github:xremap/nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };

  nf.desktop.xremap = { user, ... }: {
    nixos = {
      imports = [ inputs.xremap.nixosModules.default ];
      services.xremap.enable = false;
    };

    homeManager = {
      imports = [ inputs.xremap.homeManagerModules.default ];

      services.xremap = {
        enable = true;
        withKDE = user.hasAspect nf.desktop.plasma;
        config = {
          # Fix compatibility with Wayland applications (particularly games)
          keypress_delay_ms = 20;
          throttle_ms = 10;

          keymap = [
            {
              remap = {
                SUPER-B.launch = [ "firefox" ];
                SUPER-SHIFT-B.launch = [
                  "firefox"
                  "--private-window"
                ];
                SUPER-T.launch = [ "wezterm" ];
                SUPER-P.launch = [ "krunner" ];
              };
            }
          ];
        };
      };
    };
  };
}
