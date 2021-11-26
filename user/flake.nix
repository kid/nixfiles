{
  description = "Home Manager flake";
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs @ { self, home-manager, ... }: 
  let username = "kid";
  in {
    homeConfigurations = {
      nixos = home-manager.lib.homeManagerConfiguration {
        inherit username;
        system = "x86_64-linux";
        homeDirectory = "/home/${username}";

        configuration.imports = [
          ./modules/shell.nix
        ];
      };
    };
  };
}
