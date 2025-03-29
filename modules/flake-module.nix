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
          (self + /modules/nixos/default.nix)
        ];
      };

      default = throw "There is no default module.";
    };

    homeModules = {
      nixfiles = mkModule {
        class = "home";
        modules = [ (self + /modules/home/default.nix) ];
      };

      default = throw "There is no default module.";
    };
  };
}
