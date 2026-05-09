{
  inputs,
  den,
  lib,
  ...
}:
{
  imports = [
    inputs.den.flakeModule
  ];

  systems = lib.systems.flakeExposed;

  den = {
    default = {
      includes = [
        den.provides.inputs'
        den.provides.self'
      ];

      nixos.system.stateVersion = lib.mkDefault "25.05";
      homeManager.home.stateVersion = lib.mkDefault "25.05";
      darwin.system.stateVersion = lib.mkDefault 6;
    };

    schema.user.classes = lib.mkDefault [ "homeManager" ];

    ctx.user.includes = [ den._.mutual-provider ];

    aspects = {
      vulkan = {
        includes = [ den.provides.hostname ];

        # nixos = _: {
        #   imports = [
        #     ../systems/x86_64-nixos/vulkan
        #   ];
        # };
      };

      # fw13 = {
      #   includes = [ den.provides.hostname ];
      #
      #   nixos = _: {
      #     imports = [
      #       ../systems/x86_64-nixos/fw13
      #     ];
      #   };
      # };

      # kid = {
      #   includes = [
      #     den.provides.define-user
      #     den.provides.primary-user
      #   ];
      #
      #   # homeManager = _: { imports = [ "../homes/kid@vulkan" ]; };
      #   # provides.vulkan.homeManager = _: { imports = [ "../homes/kid@vulkan" ]; };
      #   # provides.fw13.homeManager = _: { imports = [ "../homes/kid@fw13" ]; };
      # };
    };
  };
}
