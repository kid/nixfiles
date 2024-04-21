(
  { pkgs, inputs, ... }:
  {
    imports = [
      inputs.hm.darwinModules.home-manager
      inputs.stylix.darwinModules.stylix
      ../modules/darwin
      ../profiles/work.nix
    ];

    nixpkgs = {
      config = {
        allowBroken = true;
        allowUnfree = true;
      };
      overlays = [
        inputs.nur.overlay
        inputs.nixpkgs-firefox-darwin.overlay
      ];
    };
    hm.programs.firefox.package = pkgs.firefox-bin;

    hm.stylix.fonts.sizes.terminal = 12;
  }
)
