{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, utils, home-manager, ... }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      # channels.nixpkgs.overlaysBuilder = channels: [
      #   # self.overlay
      #   home-manager.overlay
      # ];

      hostDefaults.modules = [
        ./modules
        ./modules/options.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      hosts.nixos-dev.modules = [
        ./hosts/nixos-dev.nix
      ];

      hosts.test-vm.modules = [
        ./hosts/test-vm.nix
        {
          services.openssh.enable = true;
        }
      ];

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          buildInputs = [
            fup-repl
            nixpkgs-fmt
          ];
        };

        homeConfigurations.foo = {};
      };
    };
}
