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

    homeManager =
      { pkgs, ... }:
      let
        scoped =
          cmd:
          [
            "${pkgs.systemd}/bin/systemd-run"
            "--user"
            "--scope"
            "--quiet"
          ]
          ++ cmd;
      in
      {
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
                  SUPER-B.launch = scoped [ "firefox" ];
                  SUPER-SHIFT-B.launch = scoped [
                    "firefox"
                    "--private-window"
                  ];
                  SUPER-T.launch = scoped [ "wezterm" ];
                  SUPER-P.launch = scoped [ "krunner" ];
                };
              }
            ];
          };
        };
      };
  };
}
