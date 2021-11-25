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
 
      hostDefaults.channelName = "unstable";

      hostDefaults.modules = [
        ./modules

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      hosts.nixos-dev.modules = [
        ./hosts/nixos-dev.nix
        # ./config/users.nix
      ];

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          buildInputs = [
            nixpkgs-fmt
          ];
        };
      };
    };
}
