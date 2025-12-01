{ self, ... }:
let
  mkModule =
    {
      name ? "nixfiles",
      class,
      modules,
    }:
    {
      _class = class;
      _file = "${self.outPath}/flake.nix#${class}Modules.${name}";

      imports = modules;
    };
in
{
  flake = {
    nixosModules = {
      nixfiles = mkModule {
        class = "nixos";
        modules = [
          (self + /modules/base)
          (self + /modules/nixos)
        ];
      };
    };

    darwinModules = {
      nixfiles = mkModule {
        class = "darwin";
        modules = [
          (self + /modules/base)
        ];
      };
    };

    homeModules = {
      nixfiles = mkModule {
        class = "homeManager";
        modules = [
          (self + /modules/home)
        ];
      };
    };
  };
}
