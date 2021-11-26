{
  description = "Home Manager flake";
  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
  };

  outputs = inputs @ { self, home-manager, ... }:
    let username = "kid";
    in
    {
      homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          inherit username;

          system = "x86_64-linux";
          homeDirectory = "/home/${username}";

          configuration = import ./home.nix;
        };
      };
    };
}
