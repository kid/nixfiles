{ self, ... }:
let
  inherit (builtins) throw;

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

      default = throw "There is no default module.";
    };

    homeModules = {
      nixfiles = mkModule {
        class = "homeManager";
        modules = [ (self + /modules/home) ];
      };

      default = throw "There is no default module.";
    };
  };
}
