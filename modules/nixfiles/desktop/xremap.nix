{
  inputs,
  den,
  nf,
  ...
}:
{
  flake-file.inputs.xremap = {
    url = "github:xremap/nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };

  nf.desktop.xremap = {
    nixos = {
      imports = [ inputs.xremap.nixosModules.default ];
      services.xremap.enable = false;
    };

    homeManager = {
      imports = [ inputs.xremap.homeManagerModules.default ];

      services.xremap = {
        enable = true;
        watch = true;
        config.keymap = [
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

    includes = [
      (den.lib.policy.when ({ user, ... }: user.hasAspect nf.desktop.plasma) {
        homeManager.services.xremap.withKDE = true;
      })
    ];
  };
}
