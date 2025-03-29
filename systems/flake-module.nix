{
  self,
  lib,
  inputs,
  ...
}:
let
  inherit (lib.lists) concatLists optionals;
in
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easy-hosts = {
    autoConstruct = true;
    path = ./.;

    perClass = class: {
      modules = concatLists [
        [
          "${self}/modules/base"
          "${self}/modules/${class}"
          {
            nixpkgs.config.allowUnfree = true;
          }
        ]

        (optionals (class != "iso") [
          "${self}/homes"
        ])
      ];
    };

    # hosts = {
    #   nixos.class = "nixos";
    #   testvm.class = "nixos";
    # };
  };
}
