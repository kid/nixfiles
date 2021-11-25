{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    devshell.url = github:numtide/devshell;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, utils, home-manager, ... }:
    # let
    #   suites = import ./suites.nix { inherit utils; };
    # in
    # with suites.nixosModules;
    utils.lib.mkFlake {
      inherit self inputs;
      # inherit (suites) nixosModules;

      channelsConfig.allowUnfree = true;

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        ./modules/shared-configuration.nix
        ./config/users.nix
      ];

      hosts.nixos-dev.modules = [
        ./hosts/nixos-dev.nix
      ];

      outputBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {};
      };
    };
}
